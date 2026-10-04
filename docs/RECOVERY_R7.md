# R7 — original APK intake and full-input capture

The prerequisite for real model conversion is the original input, not another
synthetic fixture. R7 adds a narrowly triggered capture workflow for the exact
Drive file supplied by the requester. The existing `Recovery` manual job, source
payload, Godot inspector and model/animation exporters are unchanged.

## Trigger and scope

`Supplied APK intake and capture` runs on a change to
`docs/inputs/last-war.json` on main, or a manual workflow dispatch. Unrelated code
pushes and pull requests do not acquire the APK. This is an explicit request file,
not an instruction taken from the downloaded APK. The job has read-only repository
permissions and does not persist checkout credentials. It downloads the supplied
public Drive ID with pinned gdown 5.2.0, without reading stored cookies, exporting
credentials, disabling TLS verification or accessing game servers. A public
access failure stops the job; no private-authentication fallback is attempted.

The request records the previously observed size of 813,035,279 bytes. A publisher
checksum was not provided, so `expected_sha256` initially is null. An observed
SHA-256 binds the captured bytes and derivatives, but does not authenticate the
publisher or prove equality to some unseen original source archive. A known,
independently verified SHA-256 may be supplied as an additional constraint.

## Input integrity

`tools/apk_intake.py` accepts only a small, strict request with a Drive file ID,
byte count and optional digest. It streams to a private temporary file through a
bounded writer, rejects oversized/short downloads, checks all ZIP entry CRCs and
computes per-entry SHA-256 values. The Android manifest and primary DEX must exist.
ZIP expansion and entry counts are bounded. ZIP names are metadata, never output
paths. Symlink inputs and existing output destinations are refused. No game code,
DEX, Lua, native libraries or entry scripts are executed by the intake.

Only a fully checked intake is published as `app.apk` plus `intake.json`. An HTML
login/error response, partial download, hash mismatch or corrupt ZIP cannot be
reported as a successful empty extraction. The receipt explicitly separates byte
integrity from APK-signature checks, publisher authentication and asset completion.

## Retention and capture

Before indexing, the original APK is split with the existing integrity-checked
transfer tool into four parts of at most 200 MiB. Each is retained as its own
Actions artifact for three days, allowing an available connector to transfer it
without the original per-file size problem. `transfer.json` accompanies part 0.
Extract the four artifacts into one directory and reassemble with:

```bash
python tools/input_transfer.py assemble parts/transfer.json input/app.apk
```

The job runs unbounded-unit R1 capture with a 12-GiB storage budget, independently
verifies coverage, builds the full R2 graph, and attempts at most 200 real neutral
previews. These previews are not complete rigged model exports or a game port.
A failed capture/graph gate remains a failed workflow; reports and a consistent
SQLite backup survive so decoder failures can be fixed from evidence. Capture
reports and successful previews are retained for seven days. The full duplicated
blob snapshot is not uploaded; its original input is retained in the four parts.
Download artifacts before expiry or rerun the explicit request.

## Validation and status

Unit tests use clearly generated ZIP fixtures solely to verify integrity and
failure handling. Actual game input counts, object counts and recovered asset
counts must come from the completed intake/capture artifacts, not these tests.
The Android inspector is unchanged by R7. Successful intake does not establish
original developer source recovery, complete game content, gameplay equivalence,
shader fidelity or an Android port. Read the final run evidence for which of the
intake, capture, graph and preview stages actually completed.
