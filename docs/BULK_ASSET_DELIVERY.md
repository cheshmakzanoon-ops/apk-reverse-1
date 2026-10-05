# Whole-APK neutral asset delivery

This continuation builds on the published full-input scanner at `d26aded`.
It converts all objects of five selected types in the supplied APK, not just the
Farhad bundle recipe. It does not equate neutral exports with rigged prefabs,
source reconstruction, shader fidelity, complete content, or a playable game.
The previous eight-clip Farhad Android acceptance remains a separate result.

## Input and local measurements

The input is exactly 813,035,279 bytes, observed SHA-256
`ccf34af2f1c1c2b0ca8575de2e86fb21bd9f2b1aef5233d35f15a6f9bece88aa`.
Its verified raw capture contains 1,947 ZIP entries, 8,009 Unity units and 985,534
objects. Hash/CRC equality identifies captured bytes, not publisher provenance.

The local bulk pass accounted for all 25,235 selected objects. Initially 217
conversions failed. Investigation produced two adapters rather than relaxed
validation: 79 meshes lacked UV channels but the old exporter generated UV indices;
86 half/float textures contained numeric values that could not be cast to bytes.

| Type | Selected | Exported | Failed | Derivative scope |
|---|---:|---:|---:|---|
| Mesh | 2,665 | 2,665 | 0 | OBJ geometry; not complete rigged prefab |
| Texture2D | 9,491 | 9,440 | 51 | 9,354 PNG plus 86 exact numeric payloads |
| Sprite | 11,752 | 11,751 | 1 | PNG, not original UI layout/behavior |
| AudioClip | 613 | 613 | 0 | Decoded single-sample PCM WAV |
| TextAsset | 714 | 714 | 0 | Binary-preserved script/data payload |
| Total | 25,235 | 25,183 | 52 | Selected object types, not all assets |

The 51 texture failures report an unresolved/empty resource-file name. They are
not proof of missing CDN content. The remaining sprite requires an explicit atlas
binding. Their original captured bytes and failed outcomes remain preserved.
Other object types, dependencies and prefab relationships still require recovery.
TextAsset exports are not evidence of newly recovered developer-written source.

These are local measurements, not predeclared CI results. The local run retained
2,586 already validated legacy OBJ exports and retried the 79 failed meshes using
the native adapter. Fresh workflow runs use `--native-mesh` for every mesh; their
output hashes and counts must come from that run rather than this first delivery.

## Converters

`recovery_audio.py` uses the pinned UnityPy audio path with catalog-scoped resource
resolution. It requires one decoded sample, matching source channel count/rate,
finite source duration and a bounded PCM estimate. It validates the complete RIFF
length/chunk structure, unique format/data chunks and sample/frame length before
accepting a WAV. Multiple subsounds or another output container fail explicitly.
Codec padding may affect decoded duration; no sample-for-sample equivalence to
unavailable original authoring audio is claimed. Encoded originals stay captured.

`recovery_mesh.py` reads native triangle index ranges, index width and baseVertex.
It uses valid OBJ face syntax for each actual position/UV/normal combination,
checks finite channels and valid indices, negates X and reverses winding. Missing
UVs are not fabricated. Skeletons, animations, blend shapes and materials remain
in source objects, not in geometry-only OBJ derivatives. The existing full GLB
prefab pipeline is unchanged.

`recovery_numeric_texture.py` preserves RHalf/RGHalf/RGBAHalf and RFloat/RGFloat/
RGBAFloat payload bytes, including signed values and floating-point bit patterns.
The `.bin` manifest records complete mip extents, dimensions, component format,
little-endian layout and SHA-256. No clamping, color conversion or PNG downgrade
occurs. Some observed names suggest GPU skinning, but their original GPU usage is
not reconstructed or inferred as verified animation behavior. These data textures
are counted separately from displayable PNG textures. Texture arrays fail.

## Resume, verification and delivery

```bash
python -m pip install -r requirements-recovery.txt
python tools/recover.py capture --apk original.apk --out recovery/bulk --max-units 0 --max-gib 18
python tools/recover.py verify recovery/bulk
python tools/recovery_bulk.py recovery/bulk --native-mesh --max-seconds 600
# Repeat only for resumable pause (exit 3). Exit 1 means completed attempts with
# explicit failures; exit 0 means all selected conversions passed; 2 is fatal.
python tools/recovery_delivery.py pack recovery/bulk --out delivery
python tools/recovery_delivery.py verify delivery
```

`--retry-failed` is explicit; prior successful exports are not silently replaced.
Budgets stop after the current object and commit a checkpoint. Original input,
member and object identities are verified. A storage failure is fatal rather than
misclassified as an unsupported media format. An unexpected exception rolls back
its in-flight transaction; completed batches remain. Zero selected objects cannot
produce a vacuous all-exported result. One filesystem lock excludes writers.

The delivery contains `delivery.json`, `objects.jsonl` and sequential ZIP archives
at most 200 MiB each, including ZIP overhead. Every selected object has an outcome;
failed conversions have no payload but retain error details. Each success records
source object hash, serialized member ID, signed path ID, derivative hash, format,
original display name as metadata, and its archive/entry. Only type and validated
object identity form output paths. Duplicate names cannot overwrite another asset.
The archive writer verifies raw/export hashes, output formats and coverage before
publishing its output directory. The standalone verifier rejects extra/missing
files, duplicate IDs or ZIP entries, changed hashes, unsafe paths and false
completeness flags. Original bundles are not included in neutral delivery; preserve
the supplied APK and recovery catalog separately. No Font objects or font files
are part of this five-type export selection.

The `Full APK neutral asset delivery` workflow creates a fresh capture, exports,
packages and verifies it before publishing independently downloadable parts and
an evidence manifest. It has read-only repository permissions, preserves no checkout
credentials, runs no original game code and contacts no game servers. Artifacts
expire after 14 days; the recipe and source are committed, the large derivatives
are GitHub artifacts rather than ordinary Git blobs. The manifest identifies exact
parts; extracting all ZIPs produces identity-addressed folders, not a Unity project.

## Remaining work

Finish/verify the whole-input graph independently, resolve the 52 observed export
failures, select a gameplay-stage prefab set with its dependencies, and connect
verified client logic to those assets. This package advances mass recovery, not a
new Android gameplay build. The original decompiled source trees and previous
Godot/Android acceptance expectations are unchanged.

Primary implementation references: UnityPy 1.25.4 AudioClipConverter and MeshHelper;
Python wave documentation; Unity TextureFormat storage definitions. Resolved
native decoder versions and tool-source commit are retained by the workflow.
