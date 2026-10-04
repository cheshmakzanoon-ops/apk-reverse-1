# Real Farhad model bridge

This increment processes the previously captured original APK, not a generated
fixture. The reviewed profile in `docs/inputs/farhad-model.json` pins its observed
SHA-256 and size, selects eleven original contiguous UnityFS bundles, and names
one exact prefab, animation binding root and two clips. The APK's observed digest
is input identity, not publisher authentication. Existing source-app bytes remain
unchanged. The previously unpublished hero-level-rule implementation is restored alongside this change.

## Reproduce

```
python tools/real_asset_sample.py --apk /path/to/original.apk --out real-model
```

Use a fresh output directory. The tool checks input size/hash before selection
and again afterward, CRC-checks the fragment while spooling it, validates all
fragment extents, and records selected byte offsets/sizes/hashes. The deterministic
small ZIP is explicitly a derivative capture, not a full-APK recovery. Original
selected bundles are retained so object and conversion results are reproducible.

## Actual asset

Selected prefab: `A_Hero_Farhad_01_PBR` under the original art container path.
The conversion produces 39 nodes, seven skinned mesh instances, 4,397 vertices and
4,692 triangles across those meshes, one embedded 512x512 diffuse texture, and two
selected real clips: `Farhad_01_hit` and `Farhad_01_attack_move`. Counts are recomputed
by the tool and must not be used as claims about the rest of the game.

Unity OneBone channels contain an index and implicit unit weight; TwoBones contain
two weights/indices. The adapter pads these into glTF's four influence slots and
retains their original layout metadata. It does not invent weights for missing
multi-index data. Unity culling root bones are preserved as provenance; glTF's
`skeleton` uses the actual lowest common ancestor of the exported joints, which
need not be the Unity culling root. Existing inverse binds and hierarchy remain.

Texture lookup uses the bound `_BaseMap` or `_MainTex` property with explicit
identity UV transforms. Scoped resource lookup now handles UnityPy's string
`load_file` dependency calls and verifies dependency bytes before decoding.
The material is a base-color preview, not an equivalent original PBR shader.
Unresolved shader/controller/other references remain in the graph report. The
selected graph is not globally dependency-complete; exporter-required references
must resolve. A successful sample does not conceal the other missing references.

## Non-legacy animation subset

The new decoder resolves generic Transform CRC32 path bindings inside the explicit
binding root. Missing targets, duplicate paths/hash collisions, mismatched scalar
counts, unsupported attributes, events, root motion and streamed curves fail.
Dense samples are interpreted frame-major with their original sample rate and
constants follow the dense scalar range. Each binding consumes its exact 3/4/3
TRS scalar width. The original AnimationClip bytes/hash remain captured evidence.

The conversion retains normalized stored quaternion poses and uses an explicit
component-linear-between-samples contract. This is not proven Unity controller,
root-motion, quaternion or inter-sample runtime equivalence. Original spline GLB
and a separate Godot-compatible quaternion derivative are both retained. The
compatibility derivative is a measured approximation, not the authoritative bytes.

All ten discovered clip identities are recorded. Seven include streamed curves;
one additional camera clip carries generic root-transform data. Those eight are
not exported, replaced with synthetic clips, or claimed as recovered playback.

## Native and Android verification

The real-model workflow validates both GLBs with Khronos, checks native geometry,
bone bindings and scene save/reload, and compares native animation poses at five
stored source frames per clip. Expectations read the source frame arrays directly,
not the decoder's output or compatibility bake. There are 77 TRS channels per
clip. This is stored-pose fidelity, not proof of behavior between sampled times.
The existing legacy fixture checks remain active and are labelled separately.

The headless renderer selects dummy audio explicitly; other script/render errors
remain fatal. Portrait framing uses the narrower camera field of view.
A Godot viewer loads the verified PackedScene and offers clip selection, pause,
scrubbing, orbit and zoom. Its repeat behavior is an inspection convenience, not
recovered controller logic. The separate debug ARM64 Android package is
`org.apk_recovery.model_inspector`; it requests no Internet permission. Its signature
and packaged provenance are checked. Linux rendering and Android packaging do not
establish Android device, touch, lifecycle, frame-rate or original-game parity.
Signing keys are ephemeral and are never published.

The generated GLBs, selected original bundles, native scenes, screenshot, Android
viewer and logs are workflow artifacts, not large blobs added to ordinary Git.
Read the actual completed run before reporting native/build stages as passed.

## Remaining work

Decode the real streamed scalar curves and remaining clip types with independent
pose checks, recover the other dependency-complete models/materials, reconcile
code/data identities against this APK, and connect verified gameplay rules into
an Android gameplay slice. This viewer is one recovered animated asset, not the
full source project, every game asset, or a playable reconstruction.

Primary format references: Unity SkinWeights scripting documentation; AssetStudio
AnimationClip.cs and ModelConverter.cs for serialized binding/layout inspection;
Khronos glTF 2.0 animation/skin specification. Their implementation is not used as
an expected-value generator for the native stored-frame tests.
