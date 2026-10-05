# Android render-surface acceptance follow-up

Baseline: `492b6779c23753408c91dc29a2066a92869d5908`.
Failed Android run: `37247167064`, job `111567213259`.
Evidence artifact: `11319129172` (`android-runtime-validation`), SHA-256
`17d94bb4b513e4f4da3b43f89d53d54e3bb79a9826dca1b36270c4a6bd06656d`.

## Reproduced failure

The SwANGLE Android 34 run rendered all eight clips and completed the native pose
checks, but stopped before physical touch tests. UI Automator exposed the focused
Godot render child as `android.view.View`, not `SurfaceView` or `RenderView`.
The old locator therefore rejected the hierarchy. This was a test-target detection
failure, not permission to mark the remaining touch/lifecycle tests as passed.

The exact observed XML is retained in
`tests/fixtures/godot-android-generic-view.xml`. Its Godot fragment and focused view
both have bounds `[0,128][1080,2337]`; Godot independently reported surface size
`1080 x 2209`. The locator now accepts this generic accessibility representation
only when those independent observations agree. It requires the known Godot
fragment ID, correct package, enabled/focusable/focused View, identical view and
container bounds, and a unique candidate. It does not choose an arbitrary frame,
keyboard, status bar, or largest matching rectangle. Explicitly named surfaces
remain supported; ambiguity or dimension mismatches fail rather than falling back.

The existing viewport-to-surface transformation and physical coordinate checks are
unchanged. Twenty new regressions reproduce the observed hierarchy and reject
mutated negative cases. Completed touch/lifecycle records now survive subsequent
failures. Original game bytes, pose tolerances, image acceptance thresholds,
rendering backend, and normal viewer playback have not changed.

## Acceptance status

Local fixture replay is not Android device execution. A new completed
`Android runtime acceptance for recovered model` run is required to establish
that all seven adb touch/background-resume operations pass. Its reports bind the
model and delivered APK hashes and retain screenshots and logcat on failure.
Even a passing emulator run is not physical ARM64 device testing or a playable
game reconstruction. The target remains the separate offline asset preview.

## Native startup race recorded during the rerun

Run `37249799452` recreated the Android activity during Godot initialization;
logcat records native cleanup before `_start_success`, repeated singleton setup,
and a SIGILL. No pose report was produced and this run remains a failure. The host
now observes completed boot, stopped boot animation, and an unchanged `am get-config`
current configuration for 20 seconds (120-second budget) before installing or
launching the preview. This is emulator test setup, not a fix or claim of support
for arbitrary in-process activity recreation. No configuration notifications are
suppressed and failed launches are not retried into apparent success. Godot error
logs abort report polling immediately rather than waiting for an absent report.
Readiness observations and both failed-run artifacts are retained with acceptance
evidence. Twelve generated regressions cover readiness transitions and early error
reporting; only a subsequent completed Android run can certify runtime acceptance.
