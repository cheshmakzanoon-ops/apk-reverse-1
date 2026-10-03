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


def safe(s, n=110):
    return re.sub(r"[^A-Za-z0-9._/-]", "_", s)[:n]


# --------------------------------------------------------------------------
# extraction
# --------------------------------------------------------------------------
def export_bundle(data, outdir, paths, inv, stats, nameindex):
    """Load one bundle's bytes and write every asset out. Returns count.

    The bundle's real name is read from its own AssetBundle object rather than
    from the offset table: the table's name/offset pairing does not match the
    actual fragment layout, so trusting it would mislabel every extracted file.
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

    container = {}
    try:
        for k, v in env.container.items():
            container[str(v)] = k
    except Exception:
        pass

    for obj in env.objects:
        tname = obj.type.name
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
            orig = nameindex.get(str(key).rsplit("/", 1)[-1]) or nameindex.get(str(key))
            if orig:
                break
        if not orig and len(paths) == 1:
            orig = paths[0]

        # prefer the game's own asset path from the manifest
        if not orig and paths and len(paths) == 1:
            orig = paths[0]

        stem = safe(os.path.splitext(orig)[0]) if orig else "%s_%d_%s" % (
            safe(name or "unnamed", 70), obj.path_id, tname)

        try:
            if tname in ("Texture2D", "Sprite"):
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
                            "path": orig, "file": p})
                written += 1
            elif tname == "AudioClip":
                samples = getattr(d, "samples", None)
                if not samples:
                    stats["no_audio"] += 1
                    continue
                ext = ".wav" if samples[0][1] == 1 else ".ogg"
                p = os.path.join(outdir, stem + ext)
                os.makedirs(os.path.dirname(p), exist_ok=True)
                with open(p, "wb") as f:
                    f.write(b"".join(s[0] for s in samples))
                inv.append({"bundle": true_name, "type": tname,
                            "path": orig, "file": p})
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
                            "path": orig, "file": p})
                written += 1
        except Exception:
            stats["export_err"] += 1
            if stats["export_err"] <= 3:
                stats["export_err_sample"] = traceback.format_exc(limit=2).strip()
        stats["objects"] += 1
    return written


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

    srt = sorted(recs)
    extents = []
    for i, (off, name) in enumerate(srt):
        end = srt[i + 1][0] if i + 1 < len(srt) else total
        extents.append((off, end, name))
    bad = sum(1 for o, e, n in extents if e <= o)
    print("== %d extents, %d degenerate, span 0..%d (fragment %d bytes)"
          % (len(extents), bad, extents[-1][1], total))
    if bad == len(extents):
        print("error: every extent is degenerate; offset table misparsed", file=sys.stderr)
        return 1

    os.makedirs(out, exist_ok=True)
    statef = os.path.join(out, ".state.tsv")
    done = set()
    if os.path.exists(statef) and not force:
        with open(statef) as f:
            for line in f:
                parts = line.rstrip("\n").split("\t")
                if len(parts) >= 2 and parts[1] == "ok":
                    done.add(parts[0])

    stats = {"objects": 0, "unreadable": 0, "export_err": 0, "no_image": 0,
             "no_audio": 0, "empty_text": 0, "bundles_ok": 0, "bundles_fail": 0}
    invpath = os.path.join(out, "inventory.jsonl")
    start = time.time()
    processed = 0
    truncated = False

    with open(statef, "a") as sf, open(invpath, "a") as invf:
        for off, end, name in extents:
            if name in done:
                continue
            if limit and processed >= limit:
                truncated = True
                break
            if budget and (time.time() - start) > budget:
                print("   time budget reached")
                truncated = True
                break
            processed += 1
            data = mm[off:end]
            if data[:8] != b"UnityFS\x00":
                stats["bundles_fail"] += 1
                sf.write("%s\tbadmagic\t%d\t%d\n" % (name, off, end))
                continue
            inv = [{"bundle": name}]
            try:
                w = export_bundle(data, os.path.join(out, "assets"), bpaths.get(name, []),
                                  inv, stats, nameindex)
                stats["bundles_ok"] += 1
                for rec in inv[1:]:
                    invf.write(json.dumps(rec, ensure_ascii=False) + "\n")
                sf.write("%s\tok\t%d\t%d\n" % (name, off, end - off))
            except Exception as e:
                stats["bundles_fail"] += 1
                sf.write("%s\terr\t%s\n" % (name, str(e).replace("\n", " ")[:120]))

            if processed % 500 == 0:
                el = time.time() - start
                print("   %d bundles  obj=%-7d ok=%-5d fail=%-4d %.0fs"
                      % (processed, stats["objects"], stats["bundles_ok"],
                         stats["bundles_fail"], el))
                sys.stdout.flush()

    el = time.time() - start
    print("\n== processed %d bundles in %.0fs" % (processed, el))
    for k in ("bundles_ok", "bundles_fail", "objects", "export_err",
              "unreadable", "no_image", "no_audio", "empty_text"):
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
