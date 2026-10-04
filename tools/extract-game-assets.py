#!/usr/bin/env python3
"""Extract the game's AssetBundles from the packed fragment and export assets.

`assets/AssetBundles/` ships the whole art/audio payload as one concatenated
blob plus index files:

    BundleFragment0.bytes     522 MB of concatenated UnityFS bundles
    BundleOffsetTable.bytes   name -> offset into the fragment
    AliasOffsetTable.bytes    alias-name -> offset
    gameres                   text manifest (also .version sidecars)
    datatable download packageres lua dllres   smaller manifests

Formats reverse-engineered from these files:

  *OffsetTable*:  int32 fragmentCount, then a 7-bit-length-prefixed fragment
  name per fragment, then per record `int32 offset`, `int32 unused`,
  `lp7 string name`. Bundles are laid out contiguously in the fragment, so each
  record's extent is [offset, next record's offset).

  *Manifest*: INI-ish sections `[Version] [Directories] [Paths] [Bundles]
  [Groups]`, comma separated. A `[Paths]` row is
  `pathIndex,directoryIndex,fileName`; a `[Bundles]` row is
  `idx,name,crc,size,pathIndices|pipe|separated,,,aliasName`. The pipe-separated
  index list in field 5 is what lets each extracted object be written back under
  its original in-game asset path instead of a Unity-internal name.

The fragment is memory-mapped and sliced in place, so no 522 MB of intermediate
bundle files are written.

Usage:
  python3 tools/extract-game-assets.py [AssetBundlesDir] [outDir] [options]
    --inventory-only     only parse manifests and list bundles
    --limit N            stop after N bundles this run
    --budget SECONDS     stop when the time budget is exhausted
    --force              re-extract bundles already recorded as done
"""

import io
import json
import mmap
import multiprocessing
import os
import re
import struct
import sys
import time
import traceback
import warnings

import UnityPy

# The studio stripped the real Unity version out of the shipped bundles: every
# one carries the literal version strings "5.x.x" and "0.0.0", so UnityPy
# cannot infer it and refuses to parse. The real engine is recorded in the
# build's own globalgamemanagers (PlayerSettings/BuildSettings m_Version), which
# the unity asset pass reports as 2019.4.41f1.
UNITY_VERSION = "2019.4.41f1"
UnityPy.config.FALLBACK_UNITY_VERSION = UNITY_VERSION
warnings.filterwarnings("ignore")


def _disable_filesystem_dependency_scan():
    """Stop UnityPy from walking the whole disk to resolve bundle externals.

    Each game bundle references assets that live in *other* bundles. Loaded one
    at a time, those pointers cannot resolve, and UnityPy falls back to
    `Environment.find_file`, which walks the entire filesystem through fsspec
    looking for a file that is not there. Profiling 40 bundles cost 6.9 million
    `walk` calls - it dominated the whole sweep by three orders of magnitude.

    The fallback is not just slow but wrong for this use: it would happily
    resolve a pointer to some unrelated local file. Callers only need a miss,
    and `ContainerHelper.parse_preload_table` already treats an unresolved
    pointer as "skip". So this keeps the cheap in-environment lookup and turns
    the disk walk into an immediate miss.
    """
    try:
        from UnityPy.environment import Environment, simplify_name
    except ImportError:  # pragma: no cover - depends on the UnityPy version
        return

    def find_file(self, name, is_dependency=True):
        return self.get_cab(simplify_name(name)) or None

    Environment.find_file = find_file


_disable_filesystem_dependency_scan()


# --------------------------------------------------------------------------
# primitives
# --------------------------------------------------------------------------
def lp7(buf, p):
    """Decode .NET's 7-bit-encoded int (BinaryReader string length prefix)."""
    n = 0
    shift = 0
    while True:
        c = buf[p]
        p += 1
        n |= (c & 0x7F) << shift
        if not (c & 0x80):
            return n, p
        shift += 7


def parse_offset_table(path):
    """-> (fragment_name, [(offset, name), ...])"""
    b = open(path, "rb").read()
    p = 0
    nfrag = struct.unpack_from("<i", b, p)[0]
    p += 4
    frag = None
    out = []
    for _ in range(nfrag):
        ln, p = lp7(b, p)
        name = b[p:p + ln].decode("utf-8", "replace")
        p += ln
        if frag is None:
            frag = name
        else:
            out.extend(_read_records(b, p, ln, name))
    # records live after the header, not inside per-fragment blocks; parse whole
    out = _read_records(b, p, 0, frag)
    return frag, out


def _read_records(b, p, _unused, frag):
    recs = []
    n = len(b)
    while p + 8 <= n:
        off = struct.unpack_from("<i", b, p)[0]
        _sz = struct.unpack_from("<i", b, p + 4)[0]
        try:
            ln, q = lp7(b, p + 8)
        except IndexError:
            break
        if q + ln > n or ln == 0:
            break
        recs.append((off, b[q:q + ln].decode("utf-8", "replace")))
        p = q + ln
    return recs


def parse_manifest(path):
    """-> {directories, paths, bundles, groups}"""
    d = {"Version": "", "Directories": {}, "Paths": {}, "Bundles": {}, "Groups": {}}
    section = None
    if not os.path.exists(path):
        return d
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.rstrip("\r\n")
            if not line.strip():
                continue
            if line.startswith("[") and line.endswith("]"):
                section = line[1:-1]
                continue
            if section is None:
                continue
            parts = line.split(",")
            if section == "Version":
                d["Version"] = line.strip()
            elif section == "Directories":
                d["Directories"][parts[0]] = parts[1] if len(parts) > 1 else ""
            elif section == "Paths":
                d["Paths"][parts[0]] = (parts[1] if len(parts) > 1 else "",
                                        parts[2] if len(parts) > 2 else "")
            elif section == "Bundles":
                if len(parts) >= 5:
                    d["Bundles"][parts[0]] = {
                        "name": parts[1],
                        "crc": parts[2],
                        "size": parts[3],
                        "paths": [x for x in parts[4].split("|") if x != ""],
                    }
            elif section == "Groups":
                d["Groups"][parts[0]] = parts[1] if len(parts) > 1 else ""
    return d


def build_bundle_paths(manifests):
    """bundle name -> [original asset paths]

    Manifest bundle names carry a content hash (`<stem>_<32 hex>.bundle`) while
    the name embedded in the bundle itself does not (`<stem>.bundle`), so index
    both spellings.
    """
    out = {}
    for m in manifests:
        for _idx, info in m["Bundles"].items():
            paths = []
            for pi in info["paths"]:
                t = m["Paths"].get(pi)
                if not t:
                    continue
                d, fn = t
                full = "%s/%s" % (m["Directories"].get(d, ""), fn) if fn else ""
                paths.append(full.strip("/"))
            name = info["name"]
            out[name] = paths
            stem = re.sub(r"_[0-9a-f]{32}(\.bundle)?$", "", name)
            out.setdefault(stem, paths)
            out.setdefault(stem.replace(".bundle", ""), paths)
    return out


MAGIC = b"UnityFS\x00"


def walk_fragment(mm):
    """-> [(offset, size)] for every bundle in the fragment, in layout order.

    Every UnityFS header records the bundle's own total file size, so the
    fragment is self-describing: start at 0 and follow the sizes. This is the
    ground truth the offset table cannot provide -- that table's name/offset
    pairing is shifted by one record (see crosscheck_offsets) and it carries one
    offset that lands in the middle of another bundle, which truncated a 7-byte
    boundary and made two bundles fail to decode.

    The walk is validated by demanding the UnityFS magic at every start offset,
    which is what makes the result trustworthy: a misparse cannot silently
    produce a plausible-looking list.
    """
    out = []
    p = 0
    total = len(mm)
    while p < total:
        if mm[p:p + len(MAGIC)] != MAGIC:
            raise ValueError("no UnityFS header at offset %d" % p)
        ver = struct.unpack_from(">I", mm, p + 8)[0]
        q = p + 12
        end = mm.find(b"\x00", q)
        if end < 0 or end - q > 64:
            raise ValueError("bad version string at offset %d" % p)
        q = end + 1
        end = mm.find(b"\x00", q)
        if end < 0 or end - q > 64:
            raise ValueError("bad revision string at offset %d" % p)
        q = end + 1
        size = struct.unpack_from(">Q", mm, q)[0]
        if size <= 0 or p + size > total:
            raise ValueError("bundle at %d claims size %d (fragment is %d)"
                             % (p, size, total))
        out.append((p, size, ver))
        p += size
    return out


def crosscheck_offsets(walk, records):
    """Compare the header walk against the shipped BundleOffsetTable.

    Returns (matched, missing_from_table, table_entries_not_in_walk). The table
    is kept only as a cross-check now; the walk decides the layout.
    """
    offsets = {off for off, _sz, _v in walk}
    table = {off for off, _name in records}
    missing = [(off, sz) for off, sz, _v in walk if off not in table]
    extra = sorted(table - offsets)
    return len(offsets & table), missing, extra


EXPORTED_TYPES = ("Texture2D", "Sprite", "AudioClip", "TextAsset")


def safe(s, n=110):
    return re.sub(r"[^A-Za-z0-9._/-]", "_", s)[:n]


def norm_key(s):
    """Normalise an asset name for a forgiving lookup.

    Manifest file names and the m_Name inside a bundle disagree on punctuation
    (`A_Hero@Farhad_01_S.psd` vs `A_Hero_Farhad_01_S`), so a second index keyed
    on alphanumerics only is what turns "unresolved" into the real in-game path.
    """
    return re.sub(r"[^a-z0-9]", "", str(s).lower())


def safe_path(p):
    """Keep an in-game path intact, only capping over-long single components.

    Truncating the whole path, as this tool used to, silently renamed files
    (`.../A_Hero_Farha.png`) and lost the directory they belong to.
    """
    out = []
    for part in p.split("/"):
        if not part:
            continue
        stem, ext = os.path.splitext(part)
        if len(stem) > 100:
            stem = stem[:100]
        out.append(stem + ext)
    return "/".join(out)


# --------------------------------------------------------------------------
# extraction
# --------------------------------------------------------------------------
def export_bundle(data, outdir, bpaths, inv, stats, nameindex, nameindex_norm):
    """Load one bundle's bytes and write every asset out. -> (written, name)

    The bundle's real name is read from its own AssetBundle object rather than
    from the offset table, because the table's names are shifted by one record
    relative to the fragment layout. The manifest path lookup uses that same
    real name, so the in-game paths written to disk are the bundle's own.

    `outdir` is the assets/ directory; inventory records get paths relative to
    the output root, never absolute ones, so the inventory stays valid when the
    checkout moves.
    """
    env = UnityPy.load(io.BytesIO(data))
    written = 0
    true_name = None
    for obj in env.objects:
        if obj.type.name == "AssetBundle":
            try:
                true_name = getattr(obj.read(), "m_Name", None)
            except Exception:
                true_name = None
            break
    if true_name:
        inv.append({"bundle": true_name, "note": "resolved-name"})

    # Manifest paths for this bundle, keyed by the name the bundle reports
    # about itself. build_bundle_paths indexes both the hashed manifest spelling
    # and the bare stem, so either form resolves.
    paths = []
    if true_name:
        paths = bpaths.get(true_name) or []
        if not paths:
            paths = bpaths.get(re.sub(r"\.bundle$", "", true_name)) or []

    # Stem -> path, restricted to the paths this bundle's own manifest entry
    # lists. Matching inside the bundle is what makes the lookup unambiguous:
    # the game's filenames carry their real extension (.tga, .psd), so guessing
    # extensions cannot find them, and a global stem index would collide across
    # the 11,155 directories.
    local = {}
    for p in paths:
        local.setdefault(norm_key(os.path.splitext(p.rsplit("/", 1)[-1])[0]), p)

    # Inventory paths are relative to the output root, which is the parent of
    # outdir. Everything else in the repository refers to assets by such a path,
    # and an absolute one would bake this machine's layout into a data file.
    rel_root = os.path.dirname(os.path.normpath(outdir))

    def rel(p):
        try:
            return os.path.relpath(p, rel_root).replace(os.sep, "/")
        except ValueError:  # different drive; fall back to the raw path
            return p.replace(os.sep, "/")

    container = {}
    try:
        for k, v in env.container.items():
            container[str(v)] = k
    except Exception:
        pass

    for obj in env.objects:
        tname = obj.type.name
        stats["objects"] += 1
        if tname not in EXPORTED_TYPES:
            # Prefab and model bundles are almost entirely GameObject,
            # Transform, Mesh and Material. None of them is exported and their
            # m_Name is never used to resolve a path, so deserialising one only
            # to discard it was most of the run's cost.
            stats["skipped"] += 1
            continue
        try:
            d = obj.read()
        except Exception:
            stats["unreadable"] += 1
            continue
        name = getattr(d, "m_Name", None) or ""

        # Recover the game's original asset path. The bundle's own container
        # path is the best key; fall back to the object name looked up in the
        # manifest index built from every [Paths] entry.
        orig = None
        try:
            cpath = container.get(str(obj.path_id))
        except Exception:
            cpath = None
        for key in (cpath, name, name + ".png", name + ".prefab",
                    name + ".mat", name + ".anim"):
            if not key:
                continue
            orig = (nameindex.get(str(key).rsplit("/", 1)[-1])
                    or nameindex.get(str(key)))
            if orig:
                break
        if not orig:
            # this bundle's own manifest entry, matched on the filename stem
            for key in (cpath, name):
                if not key:
                    continue
                orig = local.get(norm_key(str(key).rsplit("/", 1)[-1]))
                if orig:
                    break
        if not orig:
            # punctuation-insensitive second chance, globally
            for key in (cpath, name):
                if not key:
                    continue
                orig = nameindex_norm.get(norm_key(str(key).rsplit("/", 1)[-1]))
                if orig:
                    break
        # the bundle's own manifest entry, when it names a single asset
        if not orig and len(paths) == 1:
            orig = paths[0]

        if orig:
            stem = safe_path(os.path.splitext(orig)[0])
        else:
            # Nothing in the manifests names this object. Keep it grouped under
            # its own bundle rather than scattering generated names across the
            # root, where they would overwrite each other's context.
            holder = safe(re.sub(r"\.bundle$", "", true_name or "unnamed"), 80)
            stem = "_unresolved/%s/%s_%d_%s" % (
                holder, safe(name or "unnamed", 60), obj.path_id, tname)

        try:
            if tname in ("Texture2D", "Sprite"):
                if not _pixel_data(d, tname):
                    stats["no_pixel_data"] += 1
                    # `name` and `path_id` are what make this row auditable:
                    # without them a pixel-less texture is indistinguishable
                    # from an asset the tool simply never looked at, and there
                    # is no way to go back and check the claim against the APK.
                    inv.append({"bundle": true_name, "type": tname,
                                "path": orig, "name": name,
                                "path_id": int(obj.path_id),
                                "note": "no pixel data in this bundle"})
                    continue
                img = d.image
                if img is None:
                    stats["no_image"] += 1
                    continue
                # Always PNG: the manifest extension can be .fbx/.psd/.tga for
                # the source asset, but what we have decoded is a raster image.
                p = os.path.join(outdir, stem + ".png")
                os.makedirs(os.path.dirname(p), exist_ok=True)
                img.save(p)
                inv.append({"bundle": true_name, "type": tname,
                            "path": orig, "file": rel(p)})
                written += 1
            elif tname == "AudioClip":
                # `samples` is {stream name: encoded bytes} in current UnityPy,
                # each value already a complete WAV or Ogg file, and a list of
                # (bytes, channels) pairs in older ones. Indexing the dict as a
                # list raised KeyError: 0, which reported all 613 of this game's
                # voice clips as decode failures - and the clip's m_AudioData is
                # zero-length, so nothing about the object hints that the sound
                # is really there. Both shapes are handled; the dict one is the
                # only one this APK produces.
                samples = getattr(d, "samples", None)
                if isinstance(samples, dict):
                    streams = [(k, v) for k, v in sorted(samples.items()) if v]
                    channels = None
                else:
                    streams = [("", b"".join(s[0] for s in samples or []))]
                    channels = (samples[0][1] if samples else None)
                if not streams or not streams[0][1]:
                    stats["no_audio"] += 1
                    inv.append({"bundle": true_name, "type": tname,
                                "path": orig, "name": name,
                                "path_id": int(obj.path_id),
                                "note": "no audio data in this bundle"})
                    continue
                for i, (label, blob) in enumerate(streams):
                    ext = os.path.splitext(label)[1]
                    if not ext:
                        ext = ".wav" if channels == 1 else ".ogg"
                    base = stem if len(streams) == 1 else "%s_%d" % (stem, i)
                    p = os.path.join(outdir, base + ext)
                    os.makedirs(os.path.dirname(p), exist_ok=True)
                    with open(p, "wb") as f:
                        f.write(blob)
                    inv.append({"bundle": true_name, "type": tname,
                                "path": orig, "file": rel(p)})
                    written += 1
            elif tname == "TextAsset":
                b = d.m_Script
                if isinstance(b, str):
                    b = b.encode("utf-8", "replace")
                if not b:
                    stats["empty_text"] += 1
                    continue
                ext = os.path.splitext(orig)[1] if orig else ".txt"
                p = os.path.join(outdir, stem + (ext or ".txt"))
                os.makedirs(os.path.dirname(p), exist_ok=True)
                with open(p, "wb") as f:
                    f.write(b)
                inv.append({"bundle": true_name, "type": tname,
                            "path": orig, "file": rel(p)})
                written += 1
        except Exception as exc:
            stats["export_err"] += 1
            if stats["export_err"] <= 3:
                stats["export_err_sample"] = traceback.format_exc(limit=2).strip()
            # An object that was read but could not be written still has to
            # appear in the inventory. Recording nothing made the failure
            # indistinguishable from an object the sweep never saw, which left
            # 616 textures unaccounted for and no way to go back and check
            # whether they are recoverable with another decoder.
            inv.append({"bundle": true_name, "type": tname, "path": orig,
                        "name": name, "path_id": int(obj.path_id),
                        "note": "decode failed: %s: %s"
                                % (type(exc).__name__, str(exc)[:120])})
    return written, true_name


# Set in main() before any worker pool is forked, so children inherit the
# read-only lookup tables and the fragment mapping without pickling them.
_CTX = {}


def _pixel_data(d, tname):
    """True when the object's pixels are actually present in this bundle.

    Some bundles ship a Texture2D - often a `_gpuskintex` - whose pixel stream
    is empty, because the pixels live in one of the ~25,000 bundles the studio
    serves from its CDN rather than from the APK.

    The check is not defensive tidiness, it is the only thing standing between
    the output and a silent lie. Asked to decode a pixel-less texture, UnityPy
    does not fail: it hands back a full-resolution image whose every channel
    spans the whole 0-255 range, so it saves as a ~130 KB PNG of noise that
    looks exactly like real art in a file browser. The superseded revision of
    this tool wrote 5,281 of those and they accounted for 443 MB of the output
    directory. (PIL does raise "bytes must be in range(0, 256)" for some of
    them, which is why the failure looked like a tool bug rather than missing
    input.) Pixel-less textures are therefore counted and recorded as such, and
    the inventory row carries the object's name and path_id so the claim can be
    re-checked against the APK.
    """
    if tname == "Texture2D":
        return bool(getattr(d, "image_data", None))
    try:
        return bool(getattr(d.m_RD.text.read(), "image_data", None))
    except Exception:
        # Cannot tell; let d.image raise and be reported as a decode failure.
        return True


def _extract_one(job):
    """Worker body: extract one bundle, return everything the parent records."""
    off, end = job
    ctx = _CTX
    stats = {"objects": 0, "unreadable": 0, "export_err": 0, "no_image": 0,
             "no_audio": 0, "empty_text": 0, "bundles_ok": 0, "bundles_fail": 0,
             "skipped": 0, "no_pixel_data": 0}
    inv = [{"bundle": "@%d" % off}]
    try:
        written, true_name = export_bundle(
            ctx["mm"][off:end], ctx["assets"], ctx["bpaths"], inv, stats,
            ctx["nameindex"], ctx["nameindex_norm"])
        stats["bundles_ok"] = 1
        return ("ok", off, end - off, true_name, written, stats, inv[1:])
    except Exception as e:
        stats["bundles_fail"] = 1
        return ("err", off, str(e).replace("\n", " ")[:120], None, 0, stats, [])


def main():
    args = [a for a in sys.argv[1:]]
    src = args[0] if len(args) > 0 else "decompiled/unity/assets/AssetBundles"
    out = args[1] if len(args) > 1 else "source-app/game-assets"
    opt = set(args[2:])

    def optval(flag, default=None):
        if flag in opt:
            return args[args.index(flag) + 1]
        return default

    limit = int(optval("--limit", "0") or 0)
    budget = float(optval("--budget", "0") or 0)
    force = "--force" in opt

    manifest_paths = [os.path.join(src, n) for n in
                      ("gameres", "datatable", "download", "packageres", "lua", "dllres")]
    manifests = [parse_manifest(p) for p in manifest_paths if os.path.exists(p)]
    bpaths = build_bundle_paths(manifests)

    # basename -> in-game path, across every manifest, for naming outputs
    nameindex = {}
    for m in manifests:
        for _di, _fn in m["Paths"].values():
            if _fn:
                nameindex.setdefault(_fn, "%s/%s" % (m["Directories"].get(_di, ""), _fn))
    print("   path index: %d asset names" % len(nameindex))
    # second index keyed on punctuation-free names, so `A_Hero@Farhad_01_S.psd`
    # in a manifest still matches the `A_Hero_Farhad_01_S` inside the bundle
    nameindex_norm = {}
    for fn, full in nameindex.items():
        nameindex_norm.setdefault(norm_key(os.path.splitext(fn)[0]), full)
    print("   normalised path index: %d names" % len(nameindex_norm))

    print("== manifests")
    for p, m in zip([p for p in manifest_paths if os.path.exists(p)], manifests):
        print("   %-14s version=%-6s dirs=%-6d paths=%-6d bundles=%-6d groups=%d"
              % (os.path.basename(p), m["Version"], len(m["Directories"]),
                 len(m["Paths"]), len(m["Bundles"]), len(m["Groups"])))

    frag_name, recs = parse_offset_table(os.path.join(src, "BundleOffsetTable.bytes"))
    frag_path = os.path.join(src, frag_name)
    print("== fragment %s: %d indexed bundles" % (frag_name, len(recs)))

    if "--inventory-only" in opt:
        for off, name in sorted(recs)[:10]:
            print("   @%-10d %s" % (off, name))
        print("   ... (%d total)" % len(recs))
        return 0

    fh = open(frag_path, "rb")
    mm = mmap.mmap(fh.fileno(), 0, access=mmap.ACCESS_READ)
    total = len(mm)

    # The fragment is self-describing: walk it by the size in each UnityFS
    # header instead of deriving extents from the offset table. The walk is
    # what defines the layout; the table is only cross-checked and reported.
    walk = walk_fragment(mm)
    span = sum(sz for _o, sz, _v in walk)
    print("== walked %d bundles, span 0..%d (fragment %d bytes, exact=%s)"
          % (len(walk), span, total, span == total))
    if span != total:
        print("error: bundle sizes do not fill the fragment", file=sys.stderr)
        return 1
    matched, missing, extra = crosscheck_offsets(walk, recs)
    print("   offset-table cross-check: %d/%d walked offsets present, "
          "%d walk entries absent from the table, %d table offsets unused"
          % (matched, len(walk), len(missing), len(extra)))
    for off, sz in missing[:5]:
        print("     walk-only bundle @%d (%d bytes)" % (off, sz))
    for off in extra[:5]:
        print("     table-only offset @%d" % off)
    extents = [(off, off + sz, "walk:%d" % off) for off, sz, _v in walk]

    os.makedirs(out, exist_ok=True)
    statef = os.path.join(out, ".state.tsv")
    invpath = os.path.join(out, "inventory.jsonl")

    # Both sidecars are rebuilt from memory rather than appended to. Appending
    # is what made them grow a duplicate line for every bundle re-extracted:
    # a run sliced by --budget, or one redone after the state key changed, wrote
    # the same offset twice and the inventory ended up with more records than
    # there are files on disk. Keying by the bundle's fragment offset - a
    # property of the bytes, unlike the offset table's shifted names - and
    # rewriting means a re-extract replaces its own rows instead of adding to
    # them, and the output is identical no matter how many runs it took.
    rows = {}   # off -> (status, name, size, written)
    inv = {}    # off -> [record, ...]
    done = set()   # offsets to skip; empty under --force
    # Loaded whether or not --force was given. --force means "redo this
    # bundle's extraction", not "forget that it was ever extracted": loading
    # unconditionally means a --force run stopped by --budget still rewrites
    # the sidecars with the bundles it did not get to, instead of quietly
    # replacing 7,868 records with the few hundred it managed.
    if os.path.exists(statef):
        with open(statef) as f:
            for line in f:
                parts = line.rstrip("\n").split("\t")
                if len(parts) < 2 or not parts[0].isdigit():
                    continue
                off = int(parts[0])
                if parts[1] in ("ok", "todo") and len(parts) >= 5:
                    rows[off] = (parts[1], parts[2], int(parts[3]),
                                 int(parts[4]))
                else:
                    rows[off] = ("err", parts[2] if len(parts) > 2 else "", 0, 0)
        if os.path.exists(invpath):
            with open(invpath) as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        rec = json.loads(line)
                    except ValueError:
                        continue
                    o = rec.get("off")
                    if isinstance(o, int):
                        inv.setdefault(o, []).append(rec)
        if not force:
            done = {str(o) for o, r in rows.items() if r[0] == "ok"}
            if done:
                print("   resuming: %d bundles already extracted" % len(done))

    stats = {"objects": 0, "unreadable": 0, "export_err": 0, "no_image": 0,
             "no_audio": 0, "empty_text": 0, "bundles_ok": 0, "bundles_fail": 0,
             "skipped": 0, "no_pixel_data": 0}
    start = time.time()
    processed = 0
    handled = set()
    truncated = False

    workers = int(optval("--workers", "0") or 0)
    if workers <= 0:
        workers = max(1, min(8, os.cpu_count() or 1))
    pending = [(off, end) for off, end, _n in extents if str(off) not in done]
    if limit:
        pending = pending[:limit]
    print("   %d bundles pending, %d worker(s)" % (len(pending), workers))

    if force:
        # --force means "redo these", and a bundle is not done again until it
        # actually has been. Marking everything this run is *not* going to
        # reach "todo" rather than leaving it "ok" is what keeps a run stopped
        # by the time budget (or by --limit) honest: the untouched bundles would
        # otherwise keep their old "ok" state, the resuming run would skip them,
        # and the sidecars would stay mixed-vintage forever - which is exactly
        # how 53 bundles ended up still carrying the previous revision's
        # inventory rows. Their rows and files are kept in the meantime, because
        # a truncated run must not lose the record of bundles it is not getting
        # to.
        scheduled = {off for off, _end in pending}
        for off, _end, _name in extents:
            if off in scheduled:
                continue
            _status, name, size, w = rows.get(off, ("", "", 0, 0))
            rows[off] = ("todo", name or "?", size, w)

    _CTX.update({"mm": mm, "assets": os.path.join(out, "assets"),
                 "bpaths": bpaths, "nameindex": nameindex,
                 "nameindex_norm": nameindex_norm})

    def jobs():
        for job in pending:
            if budget and (time.time() - start) > budget:
                print("   time budget reached")
                return
            yield job

    def checkpoint():
        """Rewrite both sidecars atomically, sorted by fragment offset."""
        for path, write in (
            (statef, _write_state),
            (invpath, _write_inventory),
        ):
            tmp = path + ".tmp"
            with open(tmp, "w", encoding="utf-8") as f:
                write(f)
            os.replace(tmp, path)

    def _write_state(f):
        for off in sorted(rows):
            status, name, size, w = rows[off]
            if status in ("ok", "todo"):
                f.write("%d\t%s\t%s\t%d\t%d\n" % (off, status, name or "?", size,
                                                 w))
            else:
                f.write("%d\terr\t%s\n" % (off, name))

    def _write_inventory(f):
        for off in sorted(inv):
            for rec in inv[off]:
                f.write(json.dumps(rec, ensure_ascii=False) + "\n")

    def prune_empty_dirs():
        """Remove directories left empty once their files are gone.

        The asset tree is rebuilt across many runs and a re-extract can remove
        files an earlier revision wrote, so the walk accumulates directories
        that hold nothing. Bottom-up, so a parent is only visited after the
        children that made it empty have already been considered.
        """
        root_assets = os.path.join(out, "assets")
        removed = 0
        for dirpath, dirnames, filenames in os.walk(root_assets, topdown=False):
            if dirnames or filenames or dirpath == root_assets:
                continue
            try:
                os.rmdir(dirpath)
                removed += 1
            except OSError:
                pass  # not empty after all; a race is fine, leave it
        return removed

    def handle(res):
        nonlocal processed
        processed += 1
        handled.add(res[1])   # res[1] is the fragment offset in both shapes
        for k, v in res[5].items():
            if k == "export_err_sample":
                stats.setdefault("export_err_sample", v)
            else:
                stats[k] += v
        if res[0] == "ok":
            _kind, off, size, true_name, w, _st, recs = res
            for rec in recs:
                rec["off"] = off
            inv[off] = recs
            rows[off] = ("ok", true_name or "?", size, w)
        else:
            off = res[1]
            inv.pop(off, None)
            rows[off] = ("err", res[2], 0, 0)
        if processed % 250 == 0:
            # Checkpoint as we go. A run stopped by the time budget must not
            # lose the bundles it already extracted, or the next run redoes
            # them.
            checkpoint()
        if processed % 500 == 0:
            el = time.time() - start
            print("   %d bundles  obj=%-7d ok=%-5d fail=%-4d %.0fs"
                  % (processed, stats["objects"], stats["bundles_ok"],
                     stats["bundles_fail"], el))
            sys.stdout.flush()

    pool = None
    try:
        if workers > 1 and len(pending) > 1:
            # Forked workers inherit the read-only tables and the fragment
            # mapping through _CTX, so nothing large is pickled.
            # Unordered on purpose: an ordered iterator stalls behind one
            # slow bundle, which would let a run overshoot its time budget
            # badly. Every record carries its fragment offset, so the sidecars
            # are written in offset order regardless of arrival order.
            pool = multiprocessing.Pool(workers)
            for res in pool.imap_unordered(_extract_one, jobs()):
                handle(res)
                if budget and (time.time() - start) > budget:
                    truncated = True
                    pool.terminate()
                    break
        else:
            for job in jobs():
                handle(_extract_one(job))
                if budget and (time.time() - start) > budget:
                    truncated = True
                    break
    finally:
        if pool is not None:
            pool.close()
            pool.join()
        # A bundle that was scheduled but whose result never came back - the
        # run hit its budget and dropped the in-flight work - is not done, even
        # if the previous run recorded it as such. Saying otherwise here is
        # what let a --force run leave a tail of bundles holding the old
        # revision's inventory rows with no way for the next run to notice.
        for off, _end in pending:
            if off in handled:
                continue
            # Unconditional: the 5th field is the file count, and a bundle that
            # holds only GameObjects legitimately writes none, so using it as a
            # "was previously extracted" marker left exactly those bundles
            # marked done while still holding the old revision's rows.
            _status, name, size, w = rows.get(off, ("", "", 0, 0))
            rows[off] = ("todo", name or "?", size, w)
        checkpoint()
        pruned = prune_empty_dirs()
        if pruned:
            print("   removed %d empty director%s" % (pruned, "y" if pruned == 1 else "ies"))

    el = time.time() - start
    print("\n== processed %d bundles in %.0fs" % (processed, el))
    for k in ("bundles_ok", "bundles_fail", "objects", "skipped", "export_err",
              "unreadable", "no_image", "no_pixel_data", "no_audio", "empty_text"):
        print("   %-14s %d" % (k, stats[k]))
    if stats.get("export_err_sample"):
        print("   export error sample:\n%s" % stats["export_err_sample"])
    written = sum(len(fs) for _r, _d, fs in os.walk(os.path.join(out, "assets")))
    print("   asset files written this run: %d" % written)
    if truncated:
        print("   (stopped early - rerun the same command to continue)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
