# R4 — explicit legacy animation curves and native Godot playback

## Scope

R4 extends the R3 model exporter with selected captured AnimationClip objects.
The supplied 813,035,279-byte APK is still unavailable in this session: the
Drive connector refuses files above 268,435,456 bytes and the local runtime
cannot resolve the download hosts. No full-APK workflow trigger was changed.
Fixture results must not be reported as animations newly extracted from the game.
Existing raw captures and recovered client source trees are not modified.

## Export

After a verified R1 capture and R2 graph, select a model root and clip identities:

```bash
python tools/recovery_model.py recovery/snapshot \
  --root-object MODEL_ROOT_OBJECT_ID \
  --clip ANIMATION_CLIP_OBJECT_ID \
  --out recovered-assets/animated-model
```

Repeat `--clip` to include additional clips (up to 128). The default animation
binding root is the selected model's Transform. Set `--animation-root` to an
explicit Transform identity inside that exported subtree when the authored clip
paths are relative to a different root. This association is supplied by the caller;
it is not automatically inferred from an Animator controller or clip name.

The original clip is reparsed and its raw bytes/hash checked. Its graph typetree
must be available. Position, quaternion rotation and scale paths resolve by exact,
case-sensitive relative Transform path, not global basenames. Duplicate siblings
making a targeted path ambiguous are rejected. Original names are metadata; the
GLB animation name is `Recovered_` followed by the full clip identity to avoid
collisions or special-character ambiguity in the native importer.

Output remains `model.glb` and `report.json`. Each animation records the original
clip name/hash, selected binding root, wrap-mode/sample-rate metadata, and explicit
runtime-fidelity limits. Existing output directories are refused; any conversion
failure before output creation leaves no apparently successful partial export.

## Supported curve contract

Only explicit, uncompressed **legacy** TRS curves are accepted. Each curve must
have nonnegative strictly increasing finite float32 key times, finite values and
in/out slopes, unweighted tangents, and constant/clamped infinity modes. Keys
collapsing to the same timestamp after float32 conversion fail. The supported
single-cycle interval is from zero to the latest key; individual shorter channels
clamp to their endpoints. Source loop/ping-pong/controller behavior is metadata,
not reproduced playback logic. Sample rate is preserved but the GLB is not baked.

Unweighted Hermite segments become glTF CUBICSPLINE tracks, retaining the actual
incoming/value/outgoing triplet for every key. Single-key constant channels use
STEP. Time values remain seconds; slopes are derivatives per second and are not
incorrectly multiplied by duration during serialization. The spline evaluator
applies the segment duration as required by the Hermite equation.

The R3 X reflection is applied consistently to values **and tangents**. Quaternion
components map to `(x, -y, -z, w)`. Tangents are never normalized. Quaternion keys
must be unit length; interpolated quaternion values are normalized. A positive
separating direction for each segment's Bezier control hull proves the polynomial
cannot pass through zero. Conservative rejection is used when that proof fails.
Scale control hulls must stay away from zero. These are supported-subset guards,
not claims that all rejected curves are malformed.

The serialized component-Hermite convention and basis conversion are tested
mathematically. Behavior of the specific game's Unity runtime, quaternion
postprocessing and controller blending remains unverified without original-input
and runtime comparisons. Reports retain `animation_runtime_equivalence_verified:
false`, `shader_equivalence_verified: false` and `gameplay_port_complete: false`.

## Godot 4.4.1 compatibility derivative

The first numerical playback run caught a native quaternion CUBICSPLINE mismatch:
the generated static fixture differed by about 0.103 radians at an off-key time.
Translation/scale samples were within tolerance. The exact source-curve GLB is
retained unchanged, not rewritten to match the importer error.

Create a separate compatibility file before native import:

```bash
python tools/godot_animation.py recovered-assets/animated-model/model.glb \
  recovered-assets/animated-model/model.native.glb
```

Only cubic quaternion tracks are resampled into LINEAR (spherical interpolation)
keys, initially at 120 samples/second and subdivided further when quarter/midpoint
probe errors exceed 0.0001 radians. Original key times are included. Source and
output hashes, per-track key counts and maximum accepted probe errors are recorded
in `model.native.compatibility.json`. Float32 timestamp precision failures,
subdivision limits and key budgets fail explicitly. This is an approximation with
measured interior probes, **not a proof of a continuous-time maximum error bound**.
Keep `model.glb` as the authoritative spline representation.

The native verification workflow checks both files with Khronos, imports the
compatibility derivative, and compares poses to the independent expectations from
the original Unity curves. Expected pose values are not regenerated from the bake.

## Explicit blockers

Mecanim/humanoid/hashed bindings, compressed rotation, muscle/streamed payloads,
Euler curves, animated arbitrary properties, PPtr curves, weighted tangents,
infinite/stepped slopes, unsupported infinity modes, events and zero-crossing
rotation/scale segments are rejected. No event function or recovered game script
is executed. Missing curve data is never replaced with an invented idle clip.
Animation controllers, root-motion extraction, GPU skinning, source shader parity,
full game logic, Android packaging and Android device tests remain separate work.

## Validation

The local tests include an independent de Casteljau implementation rather than
reusing the exporter to produce expected poses. They cover timing, nonzero tangent
preservation, quaternion normalization, root/path identity, duplicate targets,
float32 collisions, corrupt accessors, unsupported formats, and unchanged geometry.

The Model bridge workflow additionally generates static/skinned animated fixtures
and actual Unity 2019 serialized AnimationClip fixtures using the real type writer.
The latter go through APK capture, graph reconstruction and the real model/clip
adapter. The pinned Khronos validator checks all generated original and compatibility GLBs.

`godot/scripts/verify_animation.gd` imports at 120 bake frames per second without
trimming or removing immutable tracks, maps glTF node identities to native scene
nodes/bones, and uses AnimationPlayer seek to sample seven authored/off-key times.
It compares native TRS values against independent source-curve expectations, then
saves and reloads a PackedScene and repeats the checks. Vector tolerance is 0.0005;
angular tolerance is 0.002 radians. Both actual errors and tolerances are recorded.
This is a headless numerical playback check, not rendered visual parity or an
Android device test. The original R3 native geometry/skin checks remain active.

Godot 4.4.1 replaces ImporterMesh nodes during post-import. Target lookup therefore
uses the exact GLTFNode-generated scene path (including bone subnames), not stale
GLTFState scene-node pointers. Missing paths remain a verification failure.

## Primary references

- https://docs.unity.com/en-us/engine/6000.5/script-reference/unityengine/keyframe
- https://github.com/Perfare/AssetStudio/blob/master/AssetStudio/Classes/AnimationClip.cs
- https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#animations
- https://docs.godotengine.org/en/4.4/classes/class_gltfdocument.html
- https://docs.godotengine.org/en/4.4/classes/class_gltfnode.html
- https://docs.godotengine.org/en/4.4/classes/class_animationplayer.html

These establish format/API behavior, not recovery coverage of the absent game APK.
