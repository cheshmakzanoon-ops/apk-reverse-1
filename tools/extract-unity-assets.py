#!/usr/bin/env python3
"""Extract Unity assets from the game's `assets/bin/Data` payload.

The APK ships Unity's data files in pieces:

    globalgamemanagers                 player settings / type tree
    globalgamemanagers.assets.split0..4  one serialized file, byte-split
    level0                             the boot scene
    sharedassets0.assets.split0..1     the scene's shared assets
    unity default resources            built-in resource bundle
    Resources/unity_builtin_extra      built-in extra resources
    <32-hex-name>                     117 single-Shader serialized files

`<name>.splitN` chunks are raw byte ranges of one file, so they are
concatenated in numeric order before parsing. Everything is then loaded with
UnityPy and exported by type.

Usage: python3 tools/extract-unity-assets.py [binDataDir] [outDir]
"""

import json
import os
import re
import struct
import sys
import traceback

import UnityPy


def concat_splits(d):
    """Rewrite `<name>.splitN` chunks back into a single `<name>` file."""
    made = []
    names = set()
    for f in os.listdir(d):
        m = re.match(r"^(.*)\.split(\d+)$", f)
        if m:
            names.add(m.group(1))
    for base in sorted(names):
        pat = "^" + re.escape(base) + r"\.split\d+$"
        parts = [f for f in os.listdir(d) if re.match(pat, f)]
        parts.sort(key=lambda f: int(f.rsplit(".split", 1)[1]))
        out = os.path.join(d, base)
        with open(out, "wb") as w:
            for p in parts:
                with open(os.path.join(d, p), "rb") as r:
                    w.write(r.read())
        made.append((out, sum(os.path.getsize(os.path.join(d, p)) for p in parts)))
    return made


def typedump(obj):
    """Best-effort JSON for anything without a native exporter."""
    try:
        tree = obj.read_typetree()
    except Exception:
        try:
            return repr(obj.read())[:4000]
        except Exception:
            return None
    return tree


def jsonable(o, depth=0):
    if depth > 12:
        return "<deep>"
    if isinstance(o, dict):
        return {str(k): jsonable(v, depth + 1) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [jsonable(v, depth + 1) for v in o]
    if isinstance(o, (bytes, bytearray)):
        return "<%d bytes>" % len(o)
    if isinstance(o, (int, float, str, bool)) or o is None:
        return o
    return str(o)


def export_one(obj, outdir, counters):
    data = obj.read()
    tname = obj.type.name
    counters["seen"] = counters.get("seen", 0) + 1
    counters.setdefault(tname, 0)
    counters[tname] += 1

    base = "%d_%s" % (obj.path_id, tname)
    name = getattr(data, "m_Name", None) or ""

    def path(ext):
        if name:
            safe = re.sub(r"[^A-Za-z0-9._-]", "_", name)[:80]
            return os.path.join(outdir, "%s__%s.%s" % (safe, base, ext))
        return os.path.join(outdir, "%s.%s" % (base, ext))

    try:
        if tname == "Texture2D":
            img = data.image
            if img is not None:
                img.save(path("png"))
                return "tex"
        elif tname == "Sprite":
            try:
                img = data.image
                if img is not None:
                    img.save(path("png"))
                    return "sprite"
            except Exception:
                pass
        elif tname == "AudioClip":
            samples = getattr(data, "samples", None)
            if samples:
                ext = "wav" if samples[0][1] == 1 else "ogg"
                p = path(ext)
                with open(p, "wb") as f:
                    f.write(b"".join(s[0] for s in samples))
                return "audio"
        elif tname == "TextAsset":
            b = data.m_Script
            if isinstance(b, str):
                b = b.encode("utf-8", "replace")
            with open(path("txt"), "wb") as f:
                f.write(b or b"")
            return "text"
        elif tname == "Mesh":
            try:
                verts = data.m_VertexData
                with open(path("obj"), "w") as f:
                    f.write("# UnityPy mesh %s (%s)\n" % (name, base))
                    f.write("v " + " ".join(map(str, (verts.m_PositionSize and [] or []))) + "\n")
                return "mesh"
            except Exception:
                pass
        elif tname == "Shader":
            with open(path("shader"), "w") as f:
                f.write("// shader %s\n%s\n" % (name, getattr(data, "m_Script", "")))
            return "shader"
        elif tname in ("GameObject", "Component", "MonoBehaviour", "AssetBundle",
                       "ResourceManager", "PreloadData", "SceneAsset"):
            d = typedump(obj)
            with open(path("json"), "w") as f:
                json.dump(jsonable(d), f, indent=1, ensure_ascii=False)
            return "tree"
    except Exception:
        counters.setdefault("export_err", 0)
        counters["export_err"] += 1

    # fallback: always keep the typetree so nothing is silently lost
    try:
        d = typedump(obj)
        if d is not None:
            with open(path("json"), "w") as f:
                json.dump(jsonable(d), f, indent=1, ensure_ascii=False)
            return "tree"
    except Exception as e:
        counters.setdefault("write_err", 0)
        counters["write_err"] += 1
        counters.setdefault("write_err_sample", str(e))
        return None
    counters.setdefault("no_dump", 0)
    counters["no_dump"] += 1
    return None


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else "decompiled/unity/assets/bin/Data"
    out = sys.argv[2] if len(sys.argv) > 2 else "source-app/unity-assets"

    if not os.path.isdir(src):
        sys.exit("error: missing %s (run the unity extract step first)" % src)

    print("== reassembling split serialized files")
    for p, n in concat_splits(src):
        print("   %-42s %9d bytes" % (os.path.basename(p), n))

    targets = []
    for f in sorted(os.listdir(src)):
        p = os.path.join(src, f)
        if not os.path.isfile(p):
            continue
        if f.endswith(".split0") or f.endswith(".split1") or re.search(r"\.split\d+$", f):
            continue
        targets.append(p)

    print("== %d serialized files to parse" % len(targets))
    grand = {}
    per_file = []
    for p in targets:
        sub = os.path.join(out, os.path.splitext(os.path.basename(p))[0])
        # The directory must exist up front: a missing parent turns every
        # per-object export into a silent no-op.
        os.makedirs(sub, exist_ok=True)
        counters = {}
        n_obj = 0
        try:
            env = UnityPy.load(p)
            for obj in env.objects:
                export_one(obj, sub, counters)
                n_obj += 1
        except Exception:
            counters["load_error"] = traceback.format_exc(limit=1).strip()
        for k, v in counters.items():
            if k == "load_error":
                print("   !! %s: %s" % (os.path.basename(p), v))
            else:
                grand[k] = grand.get(k, 0) + v
        per_file.append((os.path.basename(p), n_obj))

    total = sum(grand.values()) - grand.get("seen", 0)
    print("\n== extracted %d objects across %d files -> %s"
          % (grand.get("seen", 0), len(per_file), out))
    for k, v in sorted(grand.items(), key=lambda kv: -kv[1]):
        if k not in ("seen", "load_error", "write_err_sample"):
            print("   %-16s %d" % (k, v))
    print("   export errors : %d" % grand.get("export_err", 0))
    print("   write errors  : %d" % grand.get("write_err", 0))
    print("   no dump       : %d" % grand.get("no_dump", 0))
    if grand.get("write_err_sample"):
        print("   first write error: %s" % grand["write_err_sample"])
    written = sum(len(fs) for _r, _d, fs in os.walk(out))
    print("   files written: %d" % written)
    if grand.get("seen", 0) and written == 0:
        print("error: objects were seen but nothing was written", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
