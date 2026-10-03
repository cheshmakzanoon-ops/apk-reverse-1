#!/usr/bin/env python3
"""Extract the XLua script bundle `assets/lwScripts/LWScripts.data`.

Container format reverse-engineered from the game's own loader, the decompiled
`LWLuaFile._Load` (source-app/csharp/Assembly-CSharp/LWLuaFile.cs):

    "LWLF"                 4 bytes, magic (LWLuaFileUtil.s_Magic)
    int32  fileVersion     LWLuaFileUtil.EncryptedFileVersion(2) => payloads
                           are SuperEncrypt-ed; OriginalFileVersion(1) => plain
    int32  <version fields>
    int32  entryCount
    entryCount x {
        string name        .NET BinaryReader string: 7-bit-encoded length
                           prefix + UTF-8 bytes
        int32  length
        byte   data[length]
    }

Each payload is Lua 5.3 bytecode (luac), which is what ships. This tool only
unpacks the container; run tools/decompile-lua-src.py to turn bytecode back
into source.

Usage:  python3 tools/extract-lua.py [LWScripts.data] [out-dir]
"""

import os
import struct
import sys

LUA_SIG = b"\x1bLua"
MAGIC = b"LWLF"


def read_7bit_len(buf, pos):
    """Decode .NET's 7-bit-encoded unsigned int used by BinaryReader.ReadString."""
    result = 0
    shift = 0
    while True:
        if pos >= len(buf):
            raise ValueError("truncated length prefix")
        b = buf[pos]
        pos += 1
        result |= (b & 0x7F) << shift
        if not (b & 0x80):
            return result, pos
        shift += 7
        if shift > 28:
            raise ValueError("length prefix too long")


def read_bstr(buf, pos):
    n, pos = read_7bit_len(buf, pos)
    if n < 0 or pos + n > len(buf):
        raise ValueError("bad string length %d at %d" % (n, pos))
    return buf[pos:pos + n].decode("utf-8", "replace"), pos + n


def read_i32(buf, pos):
    return struct.unpack_from("<i", buf, pos)[0], pos + 4


def parse(buf, count_offset):
    """Try reading entryCount as a little-endian int32 at `count_offset`."""
    pos = count_offset
    n, pos = read_i32(buf, pos)
    if n <= 0 or n > 1_000_000:
        raise ValueError("implausible entry count %d at offset %d" % (n, count_offset))
    entries = []
    for i in range(n):
        try:
            name, pos = read_bstr(buf, pos)
        except ValueError as e:
            raise ValueError("entry %d/%d name failed: %s" % (i, n, e))
        length, pos = read_i32(buf, pos)
        if length < 0 or pos + length > len(buf):
            raise ValueError(
                "entry %d/%d %r length %d overruns file (pos=%d size=%d)"
                % (i, n, name, length, pos, len(buf))
            )
        entries.append((name, pos, length))
        pos += length
    if pos != len(buf):
        raise ValueError(
            "entries consumed %d of %d bytes (%d trailing) - count is wrong"
            % (pos, len(buf), len(buf) - pos)
        )
    return n, entries


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else (
        "decompiled/unity/assets/lwScripts/LWScripts.data")
    out = sys.argv[2] if len(sys.argv) > 2 else "source-app/lua/luac"

    with open(src, "rb") as f:
        buf = f.read()

    if buf[:4] != MAGIC:
        sys.exit("error: bad magic %r, expected %r" % (buf[:4], MAGIC))

    file_version, p = read_i32(buf, 4)
    f1, p1 = read_i32(buf, p)
    f2, p2 = read_i32(buf, p1)
    print("magic          : %s" % buf[:4].decode())
    print("fileVersion    : %d (%s)"
          % (file_version,
             "ENCRYPTED - payloads need SuperDecrypt" if file_version == 2
             else "original/plain"))
    print("next two int32 : %d, %d" % (f1, f2))

    # The loader reads (fileVersion, version, entryCount) from offsets 4/8/12.
    # Validate that reading; fall back to the swapped order if it does not close.
    chosen = None
    for count_offset, note in ((12, "entryCount@12 (loader order)"),
                               (8, "entryCount@8 (swapped)")):
        try:
            n, entries = parse(buf, count_offset)
        except ValueError as e:
            print("  reject %-28s %s" % (note, e))
            continue
        print("  accept %-28s entryCount=%d, consumes file exactly" % (note, n))
        chosen = (count_offset, n, entries)
        break
    if chosen is None:
        sys.exit("error: could not find a consistent entry count")
    count_offset, n, entries = chosen

    if file_version == 2:
        sys.exit("error: fileVersion 2 payloads are SuperEncrypt-ed; "
                 "implement EncryptUtils.SuperDecrypt before extracting")

    if os.path.isdir(out):
        for root, dirs, files in os.walk(out, topdown=False):
            for name in files:
                os.remove(os.path.join(root, name))
            for name in dirs:
                os.rmdir(os.path.join(root, name))

    sig_ok = 0
    total = 0
    exts = {}
    for name, pos, length in entries:
        rel = name.replace("\\", "/")
        dest = os.path.join(out, rel)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        data = buf[pos:pos + length]
        with open(dest, "wb") as f:
            f.write(data)
        total += length
        ext = os.path.splitext(rel)[1] or "(none)"
        exts[ext] = exts.get(ext, 0) + 1
        if data.startswith(LUA_SIG):
            sig_ok += 1

    print("\nextracted %d files (%d bytes) to %s"
          % (len(entries), total, out))
    print("payloads starting with \\x1bLua : %d / %d" % (sig_ok, len(entries)))
    print("by extension                    : %s"
          % ", ".join("%s=%d" % kv for kv in sorted(exts.items())))
    print("total bytes accounted           : %d / %d"
          % (len(buf), total))
    if sig_ok != len(entries):
        print("WARNING: not every payload looks like Lua bytecode")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
