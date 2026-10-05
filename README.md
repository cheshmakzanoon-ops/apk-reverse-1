# apk-reverse-1 — authorized client recovery

This repository preserves recovered client code and provides a verified route from
one supplied Android APK into usable assets and Godot. **It is not the complete
original development project or a reconstructed playable game.** Original shipped
bytes, decompiled source, neutral asset derivatives, and newly ported GDScript are
kept distinct.

## Current measured deliverables

The full-input neutral export run completed on GitHub at `760fa6e`. All seven
archive parts were downloaded and independently verified against their manifests:
**25,235 selected objects, 25,183 usable exports, and 52 explicit failures.**

| Original object type | Exported | Failed | Derivative |
|---|---:|---:|---|
| Mesh | 2,665 | 0 | OBJ geometry, not reconstructed rigged prefabs |
| Texture2D | 9,440 | 51 | 9,354 PNG images plus 86 exact half/float numeric payloads |
| Sprite | 11,751 | 1 | PNG images, not recovered UI behavior |
| AudioClip | 613 | 0 | Validated single-sample PCM WAV |
| TextAsset | 714 | 0 | Binary-preserved script/data payload |
| **Total** | **25,183** | **52** | **Five object types, not every game asset type** |

All 2,665 exported meshes additionally loaded through an independent geometry
parser, accounting for 1,776,699 triangle faces. This is derivative validation,
not original-engine, skeletal, material or shader equivalence. The 51 failed
texture records have zero dimensions and no stored inline or streamed pixels;
this is not evidence of missing CDN content. One sprite still needs explicit atlas
binding. Failures and source identities remain visible in the delivery manifest.

The full supplied-APK graph has also finished local traversal with the `e22cbca`
scanner: **984,734 decoded objects, 800 decoding failures, zero unattempted
objects, and 32 unresolved object references**. The failed decodes are all
`MonoBehaviour` script components. Independent graph verification and the exact
asset-path inventory identity are recorded in
[the current acceptance record](docs/FULL_RECOVERY_ACCEPTANCE.json). Complete
traversal is not a complete dependency graph; `graph_complete` remains false.
Local graph results and the separate GitHub full-graph run must not be conflated.

The selected Farhad vehicle has a separate full-model path: seven skinned mesh
parts, its embedded base-color texture, and **eight real animation clips**.
The resulting offline asset viewer passed Android 34 x86_64 emulator animation,
rendering, touch and background/resume checks. The APK contains ARM64 code, but
physical ARM64 execution remains unverified. The previous two-clip path remains
available for regression. See [Android acceptance](docs/ANDROID_RUNTIME_ACCEPTANCE.json)
and [the eight-clip conversion contract](docs/REAL_ANIMATED_MODEL.md).

The data inspector reads 16 selected committed configuration modules through
source-compatible accessors. Numeric hero-rank rules and the hero-level manager's
supported limits/cache behavior are ported to GDScript and compared with reviewed
recovered Lua methods. Research responses are injected simulation inputs, not
live account state, upgrade authorization or a replacement game backend.

## Original client source remains preserved

The original `source-app/` and `unity-project/` payloads are unchanged. File counts
include metadata and do not establish source completeness or behavioral fidelity.

| Tracked path | Files |
|---|---:|
| `source-app/src/` | 17,325 |
| `source-app/lua/` | 18,300 |
| `source-app/data-tables-lua/` | 1,277 |
| `source-app/csharp/` | 3,626 |
| `source-app/unity-assets/` | 7,564 |

This bulk milestone does not newly recover the exact developer-written source
archive. A TextAsset binary export is not automatically readable source code.

## Supplied input identity

- APK bytes: `813035279`
- SHA-256: `ccf34af2f1c1c2b0ca8575de2e86fb21bd9f2b1aef5233d35f15a6f9bece88aa`
- Source: the exact requester-specified Drive file in `docs/inputs/last-war.json`

The verified raw capture accounts for 1,947 ZIP entries, 8,009 Unity units and
985,534 objects. Hash/CRC identity is not authenticated publisher provenance or
proof of source/binary equivalence. No recovered game code runs during asset
intake, indexing or conversion. Reviewed Lua methods run only in bounded test
harnesses without operating-system, filesystem or network capabilities.

## Reproduce full-input recovery

```bash
python -m pip install -r requirements-recovery.txt
python tools/recover.py capture --apk /path/to/original.apk --out recovery/full --max-units 0 --max-gib 18
python tools/recover.py verify recovery/full
python tools/recovery_scan.py build recovery/full --max-seconds 600
```

Start with an empty output directory. Scanner exit 3 means a resumable pause:
repeat the same build command without deleting its checkpoint. Exit 0 means
traversal finished, not that all dependencies resolved or every object decoded.
After traversal, independently verify and write the complete original path index:

```bash
python tools/recovery_scan.py inventory recovery/full --out asset-paths.jsonl
python tools/recovery_bulk.py recovery/full --native-mesh --max-seconds 600
```

Bulk exit 3 is a resumable pause; repeat that command. Exit 1 means every selected
object was attempted with explicit conversion failures; exit 0 means every
selected conversion succeeded. Exit 2 is fatal. Successful exports are retained;
use `--retry-failed` only after addressing the recorded format/dependency problem.
Do not run two writers against the same capture.

Once all selected objects have outcomes, package and independently verify them:

```bash
python tools/recovery_delivery.py pack recovery/full --out delivery
python tools/recovery_delivery.py verify delivery
```

The delivery contains `delivery.json`, `objects.jsonl`, and sequential standalone
ZIP archives no larger than 200 MiB each. Original names are manifest metadata;
validated object IDs form filenames, preventing collisions and unsafe paths.
Keep the two manifest files next to the unextracted ZIPs to run verification.
For use in another application, extract every ZIP into the same destination.
These are not binary split parts: do not concatenate them. Rigged prefabs,
controllers and original encoded bundles are not reconstructed by these ZIPs.

The completed bulk run's GitHub artifacts are named `full-apk-neutral-evidence`
and `full-apk-neutral-part-00000` through `full-apk-neutral-part-00006`.
Their recorded expiration is **October 19, 2026**. Retain required copies before
expiration; source recipes in Git are not a replacement for retained binary data.

## Reproduce the selected animated Farhad model

```bash
python tools/real_model_sample.py --apk /path/to/original.apk --out recovery/farhad
python tools/make_model_viewer.py recovery/farhad build/farhad-viewer
godot --path build/farhad-viewer
```

The eight-clip profile verifies eleven selected source bundles and an explicit
prefab/binding root. Material rendering remains a base-color preview. Two other
captured clips require external hierarchy targets or camera/motion support and
remain explicitly excluded, with their original bytes preserved. The older
`tools/real_asset_sample.py` path retains the two-clip dense-model regression.

## Build the data and rule inspector

```bash
python tools/godot_data.py build --repo . --out godot/recovered_data --lua53
python tools/godot_data.py verify --out godot/recovered_data
python tools/verify_client_semantics.py --repo . --package godot/recovered_data --out reports/r6
python tools/hero_level_oracle.py --repo . --package godot/recovered_data --out reports/hero-levels
godot --path godot
```

Existing output packages are never overwritten. Inspectors have separate package
IDs (`org.apk_recovery.asset_preview`, `org.apk_recovery.model_inspector`,
`org.apk_recovery.data_inspector`), request no Internet permission, and are not
the original game. Ephemeral debug signing keys are not published; replacing an
older inspector may require uninstalling that inspector, never the original game.

## Validation and remaining gates

```bash
python -m unittest discover -s tests -v
```

The `e22cbca` full-repository regression run passed **482 tests with no failures
or skips**. Generated fixture results are separate from actual game-data checks.
Read the acceptance records and retained CI artifacts for exact commits, input
hashes, outcomes and limits; historical milestone documents describe older scope.

Next: reconcile the 800 script-component decode failures and 32 unresolved graph
references, resolve the remaining sprite binding, select one dependency-complete
original gameplay stage, and trace its recovered client rules into an integrated
Godot implementation. Other models, animation controllers/events, custom shaders,
effects, source/binary fidelity, server-dependent systems and physical-phone
performance remain separate gates. Missing behavior must not be replaced with
placeholders and reported as recovered. The current Android deliverable remains
an animated asset viewer, not a playable port of the full game.

Technical contracts: [raw capture](docs/RECOVERY_PIPELINE.md),
[full graph](docs/FULL_INPUT_GRAPH.md),
[graph continuation](docs/FULL_GRAPH_CONTINUATION.md),
[bulk delivery](docs/BULK_ASSET_DELIVERY.md),
[hero-level rules](docs/HERO_LEVEL_RULES.md), and
[historical recovery notes](docs/legacy-recovery-notes.md).
