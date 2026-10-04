# apk-reverse-1 — authorized client recovery

This repository preserves recovered client code and builds a verifiable route
from the supplied Android game's data into Godot. **It is not yet a reconstructed
playable game, a complete asset collection, or the exact original development
source project.** Decompiled code, shipped binary bytes and newly ported GDScript
are kept distinct.

## Current usable deliverables

The real-model pipeline converts one actual Farhad vehicle prefab from the
supplied APK, including seven skinned mesh instances, an embedded base-color
texture and two non-legacy clips: `Farhad_01_hit` and `Farhad_01_attack_move`.
It preserves original selected bundles, source hashes and explicit limitations.
The separate Godot model inspector supports orbit, zoom, clip selection, pause
and scrubbing. Its Android package is a development viewer, not the game.

The data inspector reads 16 selected committed configuration modules through
source-compatible accessors. Numeric hero-rank rules and the hero-level manager's
supported limits/cache behavior are ported to GDScript and compared with reviewed
recovered Lua methods. Research responses in the level inspector are injected
simulation inputs, not real account state or authorization.

The original `source-app/` and `unity-project/` payloads are preserved unchanged.
Their file counts do not establish behavioral equivalence or completeness.

## Supplied input identity

- APK bytes: `813035279`
- Observed SHA-256: `ccf34af2f1c1c2b0ca8575de2e86fb21bd9f2b1aef5233d35f15a6f9bece88aa`
- Source: the exact Drive file specified in `docs/inputs/last-war.json`

The observed digest proves identity to the captured input, not publisher
provenance. APK-signature verification and source/binary equivalence must not be
inferred from CRC/hash checks. No recovered game code is executed during asset
intake, indexing or conversion. Reviewed Lua methods run only in bounded test
harnesses without operating-system, filesystem or network capabilities.

## Reproduce the actual Farhad conversion

```bash
python -m pip install -r requirements-recovery.txt
python tools/real_asset_sample.py --apk /path/to/original.apk --out real-model
```

Use a fresh output directory. The reviewed profile selects eleven original
bundles, one exact prefab and an explicit animation binding root. The result
includes `export/model.glb`, a separate Godot quaternion-compatibility derivative,
source-frame expectations and a provenance report. The derivative ZIP is a
selected capture, not a full-APK recovery.

The `Real Farhad asset and Android viewer` workflow additionally validates both
GLBs with Khronos, imports geometry/skins in Godot, compares stored animation poses,
saves/reloads native scenes, renders the viewer, and builds a debug ARM64 APK.
Read the completed workflow and artifacts for actual outcomes. Android packaging
and Linux rendering do not establish execution on an Android device.

See [real model contract and remaining clip formats](docs/REAL_MODEL_BRIDGE.md).

## Build the data and rule inspector

```bash
python tools/godot_data.py build --repo . --out godot/recovered_data --lua53
python tools/godot_data.py verify --out godot/recovered_data
python tools/verify_client_semantics.py --repo . --package godot/recovered_data --out reports/r6
python tools/hero_level_oracle.py --repo . --package godot/recovered_data --out reports/hero-levels
godot --path godot
```

Existing output packages are never overwritten. Preserve or move an earlier
package before rebuilding. Open the level-rule inspector through the data UI.
The `Client data and Android inspector` workflow checks the source oracles and
native access/rule behavior before Android export.

The model inspector uses `org.apk_recovery.model_inspector`; the data/rule
inspector uses `org.apk_recovery.data_inspector`. Both are development packages
separate from the original game. No Internet permission is requested. Debug keys
are ephemeral and are not published; replacing an earlier development build may
require uninstalling that inspector first. Do not uninstall the original game.

## Recovery stages and documentation

- [Raw preservation, indexing and export](docs/RECOVERY_PIPELINE.md)
- [Object references, hierarchy and transfer parts](docs/RECOVERY_R2.md)
- [Geometry, skins and native scene checks](docs/RECOVERY_R3.md)
- [Legacy animation subset and quaternion compatibility](docs/RECOVERY_R4.md)
- [Committed client-data conversion](docs/RECOVERY_R5.md)
- [Source-compatible access and numeric rank rules](docs/RECOVERY_R6.md)
- [Original APK intake and retention](docs/RECOVERY_R7.md)
- [Hero-level rules and source-oracle contract](docs/HERO_LEVEL_RULES.md)

Earlier milestone documents describe their then-current scope. Historical notes
about missing APK access or a legacy-only exporter do not describe the current
real-model bridge. The original [legacy notes](docs/legacy-recovery-notes.md) are
retained as history, not as proof of complete recovery.

## Validation and storage

```bash
python -m unittest discover -s tests -v
```

Install the pinned parsers first; a dependency-specific skip is not a pass. CI
retains machine-readable reports, source/output hashes, native scenes and build
logs. Generated fixtures are labelled separately from actual captured assets.
Actions artifacts expire; download required outputs before their retention ends.
Large APKs, generated assets, export templates and signing keys are not added to
ordinary Git.

## Remaining gates

Recover the sampled streamed curves and other clip formats; convert additional
models, materials, textures and audio; resolve missing dependencies against the
matched content snapshot; reconcile decompiled source and configuration with the
captured APK; implement and validate broader gameplay; and test the Godot Android
game on device. Local bone-pose fidelity is not a proof of shader, root-motion,
controller, gameplay or server equivalence. Missing content must stay visible,
not be replaced by placeholders and reported as recovered.
