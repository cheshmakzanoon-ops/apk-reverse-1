# apk-reverse-1 — authorized client recovery

Goal: recover the shipped client code and assets from the authorized
`com.fun.lastwar.gp` APK, establish what is actually present and usable, then
rebuild the game in Godot for Android. **A playable Godot port is not implemented.**
Decompiled source is not necessarily the exact developer-written source, and
server implementation/source files not shipped in the client are not recovered
by unpacking an APK.

## R4: explicit legacy clip export and native playback checks

R4 adds selected AnimationClip export through `--clip OBJECT_ID` on
`tools/recovery_model.py`. Supported uncompressed legacy position, quaternion and
scale curves retain key times and Hermite tangents in self-contained GLBs. Exact
relative paths bind tracks to the selected hierarchy; missing/ambiguous paths and
unsupported formats fail instead of generating partial animation. The optional
`--animation-root TRANSFORM_ID` makes the clip's path root explicit.

The Model bridge workflow tests generated animated static/skinned Unity fixtures,
Khronos validation, numerical AnimationPlayer playback in Godot, and native scene
save/reload. These fixtures are not assets recovered from the game. The full APK
acceptance gate and Android/gameplay work remain unfinished.
See [R4 commands, supported subset and fidelity limits](docs/RECOVERY_R4.md).

## R3: model-to-GLB and native Godot scene bridge

`tools/recovery_model.py` converts a verified captured hierarchy into a self-contained
GLB, retaining triangle geometry, UV0, normals, material slots and supported four-weight
skeletal bindings. Missing references and unsupported skin formats fail explicitly.
Materials are base-color previews; animation/gameplay behavior is not reconstructed.

`godot/scripts/verify_model.gd` imports GLB through Godot's native parser, validates
geometry and skin bindings, saves a PackedScene and validates its reload. The new
Model bridge workflow checks generated static/skinned fixtures through actual UnityPy,
Khronos glTF-Validator and Godot. **These are fixture tests, not newly recovered game
assets, and the Godot harness is not a playable game or Android APK.**

See [R3 commands, coordinate contract and limitations](docs/RECOVERY_R3.md).

## R2: transfer integrity, object relationships, and client-source evidence

R2 adds `tools/input_transfer.py`, `tools/recovery_graph.py`, and
`tools/source_inventory.py`. See [R2 commands and acceptance gates](docs/RECOVERY_R2.md).

- APKs can be split into at most 200 MiB parts and reassembled only after every
  part and the complete file pass size/hash checks. Existing files are never overwritten.
- The additive object graph decodes captured trees, preserves one-based external
  file slots, and resolves PPtrs by serialized member and signed path ID. Missing,
  ambiguous, invalid, and null references are distinct. Limits report partial coverage.
- Hierarchy reports join GameObject, Transform, component, mesh, material, bone,
  and controller references. Parent/child and component/owner bindings are checked
  reciprocally. Reports retain Unity local coordinates; they are not GLB or Godot scenes.
- CI hashes the actual tracked client payload and syntax-checks Lua with an
  explicitly selected Lua 5.3 runtime. It does not execute recovered game scripts.

**The supplied full APK has not yet been processed by R1/R2 in this implementation
session.** Synthetic/parser fixtures are not counts of newly recovered game assets.
Full-APK acquisition remains a manual, authorized workflow; its trigger is unchanged.
A green unit-test job is not proof of complete source, model, or Godot recovery.

## R1: lossless capture and validated neutral exports

The older extractors skipped model objects, used a placeholder mesh writer,
checked only inline texture bytes, and validated their own output inventory
rather than complete input coverage. Their historical "complete recovery" claims
are superseded by the explicit state and verification checks below. The old
README is retained unchanged in [historical recovery notes](docs/legacy-recovery-notes.md)
for format research and provenance, **not as a current completeness certificate**.

The new pipeline is `tools/recover.py` with `tools/recovery_core.py`:

- Preserves the original APK and every ZIP entry in a SHA-256-addressed store.
  Original entry names are metadata, never filesystem output destinations.
- Walks every `UnityFS` extent in each packed fragment, reassembles contiguous
  Unity `.splitN` inputs, and preserves original decompressed serialized members
  and resource streams. The shipped offset table is not used as a slicing oracle.
- Indexes **every** parsed object type, including meshes, materials, transforms,
  animation clips and unknown classes. IDs include unit/member identity and the
  signed Unity path ID; repeated names/path IDs do not overwrite other objects.
- Records external-file and decoded texture/mesh/audio stream dependencies.
  Resolution is restricted to the captured data. Missing and ambiguous references
  are explicit; an empty inline texture buffer is not labeled "CDN-only".
- Preserves binary typetree fields as hash-addressed blobs instead of replacing
  them with `<N bytes>` labels. Raw bytes remain available when decoding fails.
- Exports Mesh to genuine, validated OBJ geometry; Texture2D/Sprite to PNG after
  checking resolved pixel bytes; TextAsset to byte-preserving binary output.
  OBJ is a **geometry export**, not a complete rig/material/animation conversion.
- Verifies blob hashes, input and object coverage, serialized-object byte spans,
  dependency ranges, and the content of successful exports. Empty/missing captures,
  partial scans, corrupt outputs and placeholder OBJ geometry do not pass.

See [the recovery contract and remaining work](docs/RECOVERY_PIPELINE.md).

## Run the new pipeline

Use Python **3.11 or newer**. The APK is input data; none of its code is executed.
The pipeline itself makes no network requests.

```bash
python -m pip install -r requirements-recovery.txt
python -m unittest discover -s tests -v

# Put the authorized APK at input/app.apk. Always use a new snapshot directory.
python tools/recover.py capture --apk input/app.apk --out recovery/snapshot
python tools/recover.py verify recovery/snapshot

# First inspect a bounded set. A limit of 0 attempts every matching object.
python tools/recover.py export recovery/snapshot --types Mesh Texture2D TextAsset --limit 100
python tools/recover.py materialize recovery/snapshot recovered-assets/snapshot
```

The output contains `catalog.sqlite`, `summary.json` and `blobs/`. Materialized
files use object IDs, with JSON sidecars containing their names and provenance.
All generated snapshots are excluded from Git; retain the complete snapshot as
an external artifact, not just the preview files or summary.

`capture --max-units N` bounds **indexing**, not original APK preservation.
Skipped units stay `not_indexed`, the snapshot is `partial`, and the command exits
nonzero. `--max-gib` limits blob storage (16 GiB by default). `--trees` requests
readable typetrees for all objects and may require substantially more storage.
A new output directory is required on rerun: no mixed-version resume is claimed.

## CI and authorized APK acquisition

The **Recovery** GitHub Actions workflow installs the pinned tools and runs all
regression tests, including a small actual Unity serialized-file fixture. It also
records the full installed dependency set.

A manual run can download the exact APK supplied by the requester from Drive,
without the chat connector's per-file download limit, then capture, verify and
attempt bounded neutral exports. This does not contact the game's production
backend or discover/download unrelated content. Reports are uploaded even on
failure. Full snapshots are retained only when the manual `retain_snapshot`
option is enabled; Actions retention is temporary, not permanent archival.

## Existing recovered code: retained, not newly regenerated by this milestone

The following tracked-tree counts are inherited from the preceding revision and
checked by the existing `tools/ci-checks.sh`. They are **not** semantic-equivalence
proofs or newly repeated APK extraction measurements.

| Tracked path | Files |
|---|---:|
| `source-app/src/` | 17,325 |
| `source-app/lua/` | 18,300 |
| `source-app/data-tables-lua/` | 1,277 |
| `source-app/csharp/` | 3,626 |
| `source-app/unity-assets/` | 7,564 |

The existing code trees, Lua repairs and original decompilation scripts are kept.
The source pipeline still needs assembly-by-assembly accounting and behavioral
validation. Legacy exports are not silently treated as new verified captures.

## Completion boundaries

`capture_complete` means the captured APK entries and scheduled Unity units were
preserved/indexed without recorded capture errors. It does **not** mean all
references resolve, every typetree decoded, every model is rigged, all game
content has been acquired, original authoring source is recovered, or an Android
port exists. Inspect `decode_error`, dependency statuses, export statuses and
remaining unattempted objects independently.

Next: run and inspect the real-input capture; finish cross-object prefab,
material, skeleton and animation bindings; reconcile unresolved dependencies
against a matching authorized content snapshot; validate recovered code behavior;
then implement a tested Godot Android gameplay slice. Do not replace missing game
logic/assets with placeholders and describe that as recovery.
