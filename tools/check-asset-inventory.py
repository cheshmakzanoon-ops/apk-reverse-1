#!/usr/bin/env python3
"""Check that source-app/game-assets/ and its inventory still agree.

The bundle sweep is resumable, re-runnable and can be cut short by its time
budget, so the output can drift from the record of what produced it in ways that
are invisible in a file browser: a file left behind by a revision that wrote to
a different path, a row for a bundle that was never actually re-extracted, an
inventory entry pointing at a file that is gone. Every one of those turns
"recovered assets" into a claim nobody has checked.

Exits 0 only if the tree is exactly what the inventory says it is.

  python3 tools/check-asset-inventory.py [source-app/game-assets]
"""

import collections
import json
import os
import sys

# Notes that mean "this object was seen but produced no file", so the row is
# the only record it exists. They must carry name and path_id, or there is no
# way to go back and check the claim against the APK.
NO_FILE_NOTES = ("no pixel data in this bundle", "no audio data in this bundle",
                 "decode failed")


def load(out):
    files = {}
    offsets = []
    objkeys = []
    records = 0
    notes = collections.Counter()
    nameless = []
    absolute = []
    with open(os.path.join(out, "inventory.jsonl"), encoding="utf-8") as f:
        for lineno, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            rec = json.loads(line)
            records += 1
            off = rec.get("off")
            offsets.append(off)
            if rec.get("path_id") is not None:
                objkeys.append((off, rec["path_id"]))
            path = rec.get("file")
            if path:
                files.setdefault(path, []).append(lineno)
                if path.startswith("/") or (os.path.isabs(path)
                                            and ":" in path[:3]):
                    absolute.append(path)
            note = rec.get("note") or ""
            if note:
                notes[note.split(":")[0]] += 1
                if note.startswith(NO_FILE_NOTES):
                    if not rec.get("name") or rec.get("path_id") is None:
                        nameless.append(lineno)
    return files, offsets, records, notes, nameless, absolute, objkeys


def disk_files(out):
    found = {}
    for dirpath, _dirnames, filenames in os.walk(os.path.join(out, "assets")):
        for name in filenames:
            p = os.path.join(dirpath, name)
            found[os.path.relpath(p, out).replace(os.sep, "/")] = \
                os.path.getsize(p)
    return found


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else "source-app/game-assets"
    if not os.path.isdir(os.path.join(out, "assets")):
        print("n/a   %s has not been extracted" % out)
        return 0

    failures = []

    def check(ok, label, detail=""):
        print("  %s  %s%s" % ("ok  " if ok else "FAIL", label,
                              (" - " + detail) if detail else ""))
        if not ok:
            failures.append(label)

    (files, offsets, records, notes, nameless, absolute,
     objkeys) = load(out)
    disk = disk_files(out)

    dangling = sorted(set(files) - set(disk))
    orphans = sorted(set(disk) - set(files))
    empty = sorted(p for p, size in disk.items() if size == 0)
    empty_dirs = [os.path.join(out, "assets", r)
                  for r, d, f in os.walk(os.path.join(out, "assets"))
                  if not d and not f]

    state = {}
    statepath = os.path.join(out, ".state.tsv")
    if os.path.exists(statepath):
        with open(statepath, encoding="utf-8") as f:
            for line in f:
                parts = line.rstrip("\n").split("\t")
                if len(parts) >= 2 and parts[0].isdigit():
                    state[int(parts[0])] = parts[1]

    check(not dangling, "every file the inventory names exists",
          "" if not dangling else "%d missing, e.g. %s" % (len(dangling),
                                                          dangling[:1]))
    check(not orphans, "no file on disk is missing from the inventory",
          "" if not orphans else "%d, e.g. %s" % (len(orphans), orphans[:1]))
    check(not empty, "no zero-byte file was written",
          "" if not empty else "%d, e.g. %s" % (len(empty), empty[:1]))
    check(not empty_dirs, "no empty directories left behind",
          "" if not empty_dirs else "%d" % len(empty_dirs))
    check(not absolute, "inventory paths are relative to the output root",
          "" if not absolute else "%d absolute" % len(absolute))
    check(not nameless,
          "every object with no file records its name and path_id",
          "" if not nameless else "%d rows, first at line %d"
          % (len(nameless), nameless[0]))

    # A bundle contributes many rows - one per object - so what must not repeat
    # is the same object. Appending instead of rebuilding the inventory is what
    # used to write every re-extracted bundle's rows a second time.
    dupes = [k for k, n in collections.Counter(objkeys).items() if n > 1]
    check(not dupes, "no object is recorded twice for the same bundle",
          "" if not dupes else "%d duplicated (bundle, object) pairs"
          % len(dupes))
    check(offsets == sorted(offsets), "the inventory is sorted by fragment offset")

    if state:
        stale = sorted(o for o, s in state.items() if s == "todo")
        check(not stale,
              "no bundle is left marked as not re-extracted",
              "" if not stale else "%d bundles, e.g. offset %d"
              % (len(stale), stale[0]))
        mismatch = sorted(set(state) ^ {o for o in offsets if o is not None})
        check(not mismatch,
              "state file and inventory cover the same bundles",
              "" if not mismatch else "%d offsets differ" % len(mismatch))

    print("\n  %d records, %d bundles, %d files"
          % (records, len(set(offsets)), len(files)))
    for note, n in notes.most_common():
        print("    %-34s %d" % (note, n))

    if failures:
        print("\n%d problem(s)" % len(failures))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
