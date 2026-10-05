# Android runtime acceptance: the recovered eight-clip model

This increment adds the acceptance gate between a desktop-tested GLB and an
Android build that has actually executed. Execution is established only by a
completed passing runtime report. It is still an asset preview, not the reconstructed
game. The original source-app tree and recovery inputs are unchanged.

## Build and runtime contract

`tools/make_model_viewer.py --runtime-checks MODEL_DIR OUT` builds a testable source
package containing both the imported scene and an exact, non-imported `model.bin`
copy. Its SHA-256 must match the capture receipt, independent numerical report,
and source-pose oracle. The default package remains ARM64-only; the opt-in package
adds x86_64 alongside ARM64 so the same signed APK can run natively in an x86_64
emulator and be installed on an ARM64 phone. Emulator results do not validate the
ARM64 executable, Samsung hardware, device frame rate, or production signing.

The runtime package carries the complete source-pose oracle as data. Android
parses the raw GLB with GLTFDocument, plays the recovered curves, saves a scene in
its own private directory, reloads it, and repeats every expected pose check.
The host checks Android runtime identity, exact model hash, sample counts, clip/
node/property/time identities, original expected values, and unchanged tolerances.
It independently recomputes residuals from the returned actual poses. Neither a
success flag nor a self-reported zero error can substitute for those comparisons.

## Touch and lifecycle behavior

The normal viewer now has touch-accessible Zoom in/out buttons. Android emulated
mouse drag events do not apply a second orbit on top of a touch drag. On an actual
application-paused notification, the viewer saves its clip position and whether
playback was active, then pauses. On application-resumed it restores that position
and resumes only playback that had been active. A user-paused clip stays paused.
This preserves an in-memory activity; process-death recovery is not implemented.

`asset_viewer/android_probe.gd` is an explicit test entry point, not an autoload
or command listener. It loads the real viewer and exposes bounded state snapshots
only when deliberately launched as a script. The ordinary application never runs
it. A fresh nonce prevents stale state from satisfying a new run.

`tools/android_runtime_check.py` only targets `emulator-NNNN`, verifies the emulator
property, and only installs/stops the separate `org.apk_recovery.asset_preview`
package. No original game package or game server is accessed. The script uses the
Godot template's `command_line_params` string-array intent extra, and reads reports
with Android's debug-only `run-as` inside this inspector's sandbox. No root app,
network permission, shared-storage permission, or production signing key is used.

The test stages are distinct:

1. Exact raw-model source poses and scene save/reload inside Android.
2. All eight imported clips, programmatic viewer control checks and rendered PNGs.
3. Actual `adb input tap/swipe` zoom, timeline, orbit, restart and pause actions.
4. Android HOME/foreground cycles with both paused and active playback, requiring
   pause/resume notifications, preserved clip, same process, and preserved position.

Programmatic clip-selection checks are not mislabeled as touch selection. Runtime
reports explicitly distinguish Android emulator execution from physical-device QA.
A development APK includes test scripts and ephemeral debug signing; it is not a
Play release. A changed debug key may require uninstalling the previous preview.

## CI and evidence

`Android runtime acceptance for recovered model` runs only on its implementation
paths on main or manual dispatch. It acquires only the already supplied hash-pinned
public APK, rebuilds the eight-clip derivative, runs all Python/Lua and native Godot
checks, verifies Khronos GLB validation, and produces a dual-ABI signed APK. It checks
that exact raw model, oracle, and provenance bytes are packaged, and that Internet
permission is absent, before installing that very APK on Android 34 x86_64.

The emulator action is pinned to commit `a421e43855164a8197daf9d8d40fe71c6996bb0d`.
Godot stays on 4.4.1 with official release checksums. The opt-in runtime package
sets `rendering/textures/vram_compression/compress_with_gpu=false`, using Godot's
supported CPU texture-compression backend to avoid its Betsy shutdown-thread bug.
The rendered editor importer and all error/pose checks remain enabled. Raw GLB,
oracle and captured input bytes are unchanged; imported GPU-format textures are
derivatives, not byte-identical original textures. The Android image/build tools
and dependency versions remain recorded in workflow output; this does not claim
reproducible bit-identical SDK images or debug signatures.

The validation artifact retains logs, failed gates, all pose results, eight clip
screenshots, actual touch/lifecycle states, command return codes, platform metadata,
and the installed APK hash. The build artifact is retained even when runtime checks
fail; artifact existence is not a passing acceptance result. Read the completed
runtime report before claiming Android success. Timeouts, absent reports, errors,
wrong identities, partial samples and altered tolerances fail the job.

Primary platform references:
- Godot 4.4.1 `GodotActivity.kt` (command_line_params):
  https://github.com/godotengine/godot/blob/4.4.1-stable/platform/android/java/lib/src/org/godotengine/godot/GodotActivity.kt
- Godot 4.4 OS command-line arguments:
  https://docs.godotengine.org/en/4.4/classes/class_os.html
- Android emulator action:
  https://github.com/ReactiveCircus/android-emulator-runner

Remaining game goals: more dependency-complete original assets, controller/event/
shader recovery, source/binary behavioral reconciliation, gameplay and server-side
replacement where needed, and physical Android device validation. Passing this gate
is acceptance of one real animated asset on Android, not all game source or assets.

## Emulator rendering and input corrections

The first executed Android run passed every source pose and scene roundtrip, but
its legacy SwiftShader GLES driver failed both model and canvas shader linking
(GL_MAX_FRAGMENT_UNIFORM_VECTORS). Its PNGs were uniform backgrounds; those were
not accepted as rendered success. The workflow now uses Android's supported
SwANGLE backend, not the deprecated swiftshader_indirect mode. This changes the
emulator driver, not the APK's renderer, model, materials or pose tolerances.
Frames must pass a model-region nonblank/color-variance check excluding controls,
and Godot error lines fail acceptance. This is not full visual similarity testing.

CanvasItem.get_screen_transform() uses popup transforms, which omit stretch when
subwindows are embedded. The probe now composes the root final transform with
get_global_transform_with_canvas(), producing actual render-surface pixel targets.
The host obtains the render surface's absolute bounds from Android UI Automator,
requires its dimensions to match Godot, and adds only that observed origin. No
hard-coded notch/letterbox offset, coordinate trial-and-error, or OCR is used.
The explicit probe runs playback at one-eighth speed to avoid a 2.1-second clip
ending during adb lifecycle handshakes; the ordinary viewer stays at normal speed.
Failure evidence retains the last state, requested physical touch and screenshot.

References: Godot 4.4.1 scene/main/canvas_item.cpp and scene/main/window.cpp;
https://developer.android.com/studio/run/emulator-acceleration;
https://github.com/godotengine/godot/issues/109550.
