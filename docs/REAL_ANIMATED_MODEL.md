# Real animated Farhad model — measured conversion milestone

This milestone processes the actual requester-supplied APK, not generated geometry.
It is **one recovered asset preview**, not the playable Godot Android game.
The original client source trees and the hero-level rules now present on live
`d82f7cc` are preserved byte-for-byte. The concurrent `2423c1d` two-dense-clip
implementation is retained,
including its recipe, viewer and workflow. This additive opt-in path recovers six
additional streamed clips. It uses a separate `farhad-streamed-model.json` profile
and `real-streamed-model.yml` workflow; the existing dense exporter remains the
default. Direct callers select the new decoder with `--packed-mecanim`.
Publication and native-engine results are recorded separately.

## Reproduce from the original input

```bash
python -m pip install -r requirements-recovery.txt
python tools/real_model_sample.py --apk Last-War-Survival.apk --out recovery/farhad
python tools/make_model_viewer.py recovery/farhad build/farhad-viewer
godot --path build/farhad-viewer
```

The profile `docs/inputs/farhad-streamed-model.json` requires the 813,035,279-byte APK with
SHA-256 `ccf34af2f1c1c2b0ca8575de2e86fb21bd9f2b1aef5233d35f15a6f9bece88aa`.
This was observed on the supplied input; it is not an authenticated publisher
checksum. A different build is rejected rather than silently using the same
bundle offsets. The recipe verifies eleven selected bundle ranges and hashes,
creates a deterministic **derived subset archive**, captures that archive, then
resolves the model and clips by serialized-member identity, signed path ID and
original object hash. Paths and mesh/clip names are not global lookup keys.

Original bundle bytes, the recipe, captured objects, GLB and receipts remain
linked to the original APK. The subset's hash is explicitly distinct from the
original APK's hash. All ten captured AnimationClip objects are either selected
or explicitly excluded; the latter remain intact in the original bundles.
Existing output directories are refused. Successful publication of the result
directory follows the conversion and independent numerical gates.

## Actual exported asset

The selected prefab contains 39 transform nodes and seven skinned mesh instances,
with 4,397 vertices and 4,692 triangles in total. The shared skeleton has 26 unique
referenced joints. A real 512 × 512 RGBA base-color texture is embedded in the GLB.
The model is the Farhad vehicle asset, not a newly authored replacement.

Eight real clips are included: `Farhad_01_hit`, `Farhad_01_idle`,
`Farhad_01_attack_move`, `Farhad_01_walk`, `Farhad_01_attack_skll`,
`Farhad_01_show_idle`, `Farhad_01_attack`, and `Farhad_01_dead`.
The spelling `attack_skll` is retained from the input.

Together these clips contain 616 exported TRS channels and 9,359 GLB keys.
`Farhad_01_show` has targets outside this selected model hierarchy and is excluded
in full. `Farhad_01_camera` requires unsupported camera/motion behavior and is
also excluded in full. No fabricated curves or partial success labels replace them.

## Generic packed animation support

`tools/recovery_mecanim.py` decodes the bounded, non-legacy **generic Transform**
subset encountered in this input. Scalar ordering is streamed, dense, then
constant, with vector widths determined by the explicit binding attributes.
Streamed frames contain time, count, index and four polynomial coefficients;
finite segments are evaluated in local time. Dummy and terminal frames are
validated but never exported as astronomical animation key times.

Binding paths use CRC32 of the exact case-sensitive UTF-8 path relative to the
caller-selected animation root. Missing paths, duplicated siblings, hash
collisions, extra scalar payload, custom/script/object-reference properties,
humanoid bindings, camera/Euler curves, source events, root motion and unsupported
blend/mirror behavior fail explicitly. An opted-in `--packed-mecanim --clip` selection never silently
falls back to a legacy or guessed animation.

Dense TRS timing is represented at float32 key times. The measured timestamp
quantization is recorded. Individual scalar knot sets are combined before vector
serialization, retaining one-sided derivatives. Discontinuous streamed segments
are rejected rather than smoothed across a jump. Constant channels remain STEP;
translation and scale use component Hermite curves.

Quaternion components are normalized, then sampled to LINEAR/spherical keys at
an initial 120 Hz with adaptive refinement. Quarter/midpoint probe error is
limited to 0.0001 radians and recorded. This is a bounded sampled approximation,
**not a proved continuous-time error bound**. Original packed coefficients remain
preserved in the source bundles and capture. One cycle is exported; source loop
flags are metadata, not recovered controller transitions or retargeting.

## Real-data adapter corrections

* Unity's one-influence storage omits weights: explicit unit weights are restored
  only when there is exactly one joint index per vertex. Two-influence storage is
  zero-padded to four lanes. Missing multi-influence weights still fail.
* UnityPy ResourceReader invokes `get_cab`/`load_file`, not only `find_file`.
  Both routes now use the captured catalog, with byte hashes and scoped identity.
  The actual texture resource was local; it was not missing CDN content.
* `_BaseMap`/`_BaseColor` previews are supported alongside `_MainTex`/`_Color`.
  HDR preview RGB is divided by its maximum when above one, with original values
  and the divisor recorded. This is neither shader equivalence nor inferred
  emissive lighting. Normal, metal/gloss, custom shader and rendering behavior
  remain in original bytes but are not reconstructed by this preview.
* The observed Unity rootBone can be a pivot that is not an ancestor of every
  referenced joint. glTF requires a common ancestor. The adapter derives the
  nearest existing common ancestor while preserving the original pivot as
  metadata; joint order, hierarchy, transforms and inverse binds are unchanged.

The full eleven-bundle graph still has unresolved references outside this subset,
including shader dependencies. Successful model preview does not mean that the
whole dependency graph or original material appearance is complete. Serialized
headers report Unity `0.0.0`; the pinned UnityPy `2019.4.41f1` fallback is recorded.

## Validation levels

`tools/verify_mecanim.py` independently reads the original streamed words and
uses NumPy polynomial evaluation and ideal dense-frame timing, not the exporter's
parser/baker. It reads serialized GLB accessors, compares source-derived TRS poses,
and computes linear-blend skin deformation in both coordinate systems. The
reference checks every vertex of all seven mesh parts at 21 times per clip,
including off-grid times not used as the baker's standard probes.

Local measured totals are 12,936 channel samples and 738,696 deformed-vertex
comparisons. The largest observed angular error is approximately 0.0000988 radians;
the largest world-coordinate vertex error is approximately 0.0002334 units.
The tolerances are 0.0005 for vector components, 0.002 radians for rotation, and
0.001 world units for deformed vertices. Read `numerical.json` for exact values.
An independent trimesh load additionally confirms seven meshes/4,397 vertices/
4,692 triangles; this does not test animation playback.

These are checks against decoded serialized data, **not an execution of the
original Unity game**. The source interpretation and original engine behavior
have not been compared on a running device.

The manual `Real streamed model conversion and Android preview` workflow performs the
original-input download, real recipe, Khronos validation, native Godot 4.4.1
playback/save/reload checks, then an ARM64 debug APK build. Native failures block
Android export. The APK has a separate `org.apk_recovery.asset_preview` package ID
and no Internet permission. It is an asset viewer, not a gameplay port. The
workflow is provided but has not run for this unpublished increment. Independently,
the retained official Godot 4.4.1 Linux binary was release-checksum-verified and
used locally: geometry/bindings and save/reload passed; all 12,936 source-derived
pose samples passed both before and after native scene serialization. Native Godot
adds two helper bones (28 native bones versus 26 referenced source joints).

Eight desktop rendered/control checks passed: exact clip selection, pause,
scrubbing, restart and viewport readback. The first UI test caught a real slider
state bug on clip changes; `_play` now resets the range/value under a callback
guard. Logs preserve that failed iteration and the passing rerun. Rendering uses
an explicit Dummy audio driver on this audio-less environment, not relaxed error
checks. These are Linux software-renderer checks, not original-game visual parity,
Android packaging or Android device tests. No new Android APK is claimed.

## Remaining work

Recover the remaining display/camera targets and controller associations, validate
additional rendered skin/material behavior against the original game, then generalize the
verified recipe across further real assets. Full original source reconstruction,
complete content recovery, shaders/effects, gameplay and server-dependent systems,
and Android device/lifecycle/performance testing remain separate open gates.

Primary format references:
- AssetStudio AnimationClip reader: https://github.com/Perfare/AssetStudio/blob/master/AssetStudio/Classes/AnimationClip.cs
- AssetStudio generic binding conversion: https://github.com/Perfare/AssetStudio/blob/master/AssetStudioUtility/ModelConverter.cs
- glTF skins and animation: https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html
- Unity SkinWeights storage: https://docs.unity.cn/2023.2/Documentation/ScriptReference/SkinWeights.html
