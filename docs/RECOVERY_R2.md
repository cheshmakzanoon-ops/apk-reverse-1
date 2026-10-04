# R2 — verified transfer, object binding, and source inventory

## Status and purpose

R2 implements preparatory recovery capabilities. The whole supplied APK remains
unprocessed in this session: the Drive raw-download connector rejects its
813,035,279 bytes above its 268,435,456-byte limit, and the local runtime cannot
resolve external hosts. No automatic full-APK workflow trigger was added.
The previous capture and source trees are preserved. This is not a Godot port.

The immediate acceptance gate is still a verified capture of the actual APK.
Implementing reference handling does not waive that gate. In particular, fixture
models, fixture hierarchy counts, and syntax-check counts are not new extracted
assets or proof of original developer-source equivalence.

## Transfer without ambiguous or truncated parts

Run where the authorized APK bytes are accessible:

```bash
python tools/input_transfer.py split Last-War-Survival.apk apk-parts
```

This creates four parts for the supplied file size, each at most 200 MiB, plus
`transfer.json`. Transfer the parts and manifest together. Reassembly is:

```bash
python tools/input_transfer.py assemble apk-parts/transfer.json input/app.apk
python tools/recover.py capture --apk input/app.apk --out recovery/snapshot
python tools/recover.py verify recovery/snapshot
```

Checks include part sequence, length, SHA-256, total length, whole-file SHA-256,
nonempty ZIP structure, no path traversal, no symlink parts, and no overwrites.
Failure removes the temporary assembled file. The manifest is a transfer-integrity
record, not publisher-authenticity or Android-signature validation. Original input
bytes and all raw capture blobs remain authoritative.

## Reconstruct exact object references

```bash
python tools/recovery_graph.py build recovery/snapshot
python tools/recovery_graph.py verify recovery/snapshot
```

The graph adds tables to existing schema-1 catalogs without deleting R1 data:
`graph_objects`, `external_slots`, `object_refs`, and `container_paths`.
Every object receives a decoded, decode-failed, or deliberately not-decoded status.
Every PPtr encountered in a decoded tree receives a JSON-pointer location, signed
path ID, file ID, status, and resolved target identity when available. File ID 0
is local; external file IDs are one-based slots of the requesting serialized file.
Path ID 0 is a null pointer, not a missing asset.

All member slots are recorded before references are resolved. Cross-file references
are not guessed from globally reused object names. Bare names use the owning
bundle before global lookup. Conflicting exact matches cannot fall back to a
weaker basename match. Missing slots, missing objects, ambiguous members, resource
files used as object targets, invalid integer ranges, and unavailable content are
separate errors. Nothing is labeled remote/CDN-only without further evidence.

`AssetBundle.m_Container` paths are joined to PPtr identities. Original paths are
metadata, never output destinations. Pair-list and dictionary representations are
supported. This is not yet reconciliation of the game's complete `gameres` manifest.

Graph verification recomputes pointers and container-path joins from hashed decoded
trees, checks coverage, and rejects altered/deleted bindings. Raw-capture validation
runs separately. A graph can be internally consistent yet incomplete because a
tree or external dependency is unavailable; the CLI then exits nonzero.
`--max-objects N` deliberately produces partial status rather than fake completion.

## Hierarchy and model-binding reports

Select a recovered GameObject/Transform ID from the graph/catalog, not a guessed
filename, then export its subtree:

```bash
python tools/recovery_graph.py scene recovery/snapshot \
  --root-object OBJECT_SHA256_ID --out reports/model-hierarchy.json
```

The JSON preserves local translation/quaternion/scale, parent/child relationships,
component owners, mesh/material references, ordered bone arrays and controller
bindings when present in those components. Reciprocal links, cycles, duplicate
children, duplicate components, invalid quaternions, unresolved component pointers,
and node-budget truncation are explicit blockers. `--max-nodes` defaults to 50,000.
A root may be a subtree whose parent is outside the export; its original parent ID
is retained. Unity coordinates are not silently converted to Godot coordinates.

**Hierarchy-complete does not mean renderable-model-complete.** This report does
not synthesize skins, sample animation curves, reinterpret GPU-skinning textures,
convert materials/shaders, or generate Godot gameplay. R1 geometry OBJ exports
still do not carry a complete animated character. Those conversion gates follow
validation of actual captured game inputs.

## Client source evidence

```bash
python -m pip install -r requirements-recovery.txt
python tools/source_inventory.py --repo . --out reports/source --lua53
```

The inventory requires a nonempty tracked `source-app` tree matching HEAD, rejects
symlinks and missing files, records per-file SHA-256/size/type/line count and a
manifest hash, and records the exact commit. Lua compilation explicitly selects
`lupa.lua53`, removes only an initial BOM for compilation (the stored file hash
uses untouched bytes), and uses text-only `load` without invoking returned code.
No game/SDK script is executed. Counts and obvious decompiler markers are evidence
for triage, not semantic-equivalence or buildability certificates. Managed/native
binary counts describe only tracked inputs; absent raw DLLs cannot be assumed
fully analyzed. R2 does not regenerate or silently repair existing source files.

## CI and remaining gates

The existing Recovery test job additionally installs pinned Lupa 2.6, requires
Lua 5.3 and UnityPy 1.25.4 imports, runs regressions, and inventories the actual
tracked source tree. Reports and per-file records are uploaded as CI evidence.
The authorized-APK job remains workflow-dispatch only. Its bounded graph stage
reports incomplete coverage by default (5,000 objects); choose graph_limit=0 only
for a complete run with sufficient storage/time. Use retain_snapshot to preserve
raw output; reports alone are not the recovered assets. Failed graph/export stages
remain visible even when raw capture succeeded.

Next gates: capture/verify the actual APK; inspect representative game models and
streams; reconcile local bundle dependencies and original manifest paths; build
validated skinned GLB/material/animation conversion; verify critical recovered
logic; only then build a Godot Android gameplay slice from those verified inputs.

Primary reference for PPtr semantics:
https://github.com/K0lb3/UnityPy/blob/master/UnityPy/classes/PPtr.py

Pinned Lua runtime selection:
https://pypi.org/project/lupa/2.6/
