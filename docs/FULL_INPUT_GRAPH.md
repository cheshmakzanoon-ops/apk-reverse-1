# Full-input graph traversal and checkpoint contract

This milestone addresses the unfinished whole-APK graph job, not the already
validated Farhad viewer. The original `source-app` and `unity-project` trees,
model/animation exporters and Android acceptance expectations are unchanged.

## Evidence driving the change

Run 37233731323 captured 1,947 APK entries, 8,009 Unity units and 985,534 objects.
Its whole-input byte verifier passed. Graph decoding was cancelled; the orphaned
Python process retained the SQLite writer lock, so materialization and diagnostic
queries failed with `database is locked`. Those outcomes are not complete graph
recovery or evidence that the assets do not exist.

The original graph builder writes a separately fsynced JSON blob per newly decoded
object, clears prior graph statuses on rebuild, and has no object-level resume.
That design is inappropriate for this near-million-object input. The new
`tools/recovery_scan.py` keeps compressed, independently hashed trees in SQLite,
commits bounded batches, records durable progress, and resumes only unfinished
objects. Existing original blobs are never replaced. Raw byte capture is still
separate from decoding, resolving dependencies and exporting usable assets.

## Run

```bash
python -m pip install -r requirements-recovery.txt
python tools/recover.py capture --apk original.apk --out recovery/full --max-units 0 --max-gib 18
python tools/recovery_scan.py build recovery/full --max-seconds 600
# Exit 3 means a resumable pause. Run the same command again; do not delete output.
python tools/recovery_scan.py build recovery/full --max-seconds 600
python tools/recovery_scan.py verify recovery/full
python tools/recovery_scan.py inventory recovery/full --out asset-paths.jsonl
python tools/recovery_scan.py backup recovery/full --out graph-catalog.sqlite
```

Use a fresh raw capture for first adoption. The scanner refuses to silently replace
an existing legacy graph. The legacy builder likewise refuses to erase a packed
graph. API callers can bound new work by `max_objects` or stop cooperatively.
The CLI handles SIGINT/SIGTERM after the current object, checkpoints and closes the
database. Unexpected exceptions roll back the in-flight transaction; previously
committed batches remain. An operating-system kill during a loose binary-blob write
or storage failure may still require explicit raw-store repair; it is not claimed
as a certified power-loss recovery mechanism.

## Identity and integrity

A streaming fingerprint binds resumption to original input, parser metadata,
serialized members and original object identities/hashes. Every invocation verifies
the raw capture, and every newly parsed object is checked against its original byte
hash. Captured external-dependency IDs encode their slot ordinal: reconstructing
those exact ordinals avoids parsing every serialized file twice. Whenever a member
is parsed its slot names and object-ID set are independently compared with the
preserved member bytes. Missing or colliding target files retain explicit statuses.

Each new decoded tree stores SHA-256, uncompressed length and a zlib payload.
Readers bound decompression and reject changed hashes, sizes, missing trees,
trailing data or truncated streams. All existing consumers read through
`recovery_graph.tree_for`, so hierarchy/model readers can use either legacy blobs
or compressed trees. Binary data still uses the existing lossless blob references.
Original stream and texture semantics are unchanged.

The graph verifier recomputes expected edges and container paths from each decoded
tree and checks identities, values and counts against the actual database. Source
indexes avoid repeated whole-table scans. This validates the derived graph against
captured decoded data, not the original Unity engine's runtime behavior.

## Completion is not one boolean

`scan_finished` means every captured object received a decoding outcome and all
captured serialized members were visited. `graph_complete` additionally requires
all objects to decode and every non-null reference to resolve. A finished traversal
may be an incomplete graph. Decoder failures, unknown script types and missing
objects stay in the catalog and summary; raw originals remain preserved.

The new CLI returns 0 for a finished traversal, 3 for a resumable pause, and nonzero
on integrity errors. Its `verify` command accepts a structurally verified inventory
with explicit unsupported/unresolved items; it does not change the old strict
`recovery_graph.py verify` behavior. Neither mode implies all assets have exported,
original developer source has been recovered, or an Android game has been rebuilt.

`asset-paths.jsonl` indexes every recognized original AssetBundle container entry
with source/target IDs, exact serialized member and path ID, type and object hash.
Paths are metadata, never output filesystem destinations. A path to a prefab does
not imply its subtree is ready to render. Decode and dependency blockers must be
addressed before selecting a complete gameplay-stage package.

## Operational behavior

A kernel-released lock prevents two scanner writers on the same capture. SQLite
WAL with FULL synchronization permits diagnostics to read committed checkpoints
without contending with the active writer. The bounded SQLite backup API creates a
consistent independent database; never copy a live database while ignoring its WAL.
A catalog backup includes packed trees but **does not include original blob files**.
It is an inspection index, not a standalone source/asset reconstruction package.

The `Full APK graph inventory` workflow processes only the originally supplied,
hash-pinned APK, with read-only repository permissions and no saved credentials.
It retains catalog/summary/path-index evidence for 14 days; raw input remains at its
supplied location. Failed traversal is not relabeled success by artifact upload.
There is no gameplay-server access, new source-code execution, or new Android APK
in this milestone.

Primary storage references: https://www.sqlite.org/wal.html and
https://docs.python.org/3.13/library/sqlite3.html#sqlite3.Connection.backup.
