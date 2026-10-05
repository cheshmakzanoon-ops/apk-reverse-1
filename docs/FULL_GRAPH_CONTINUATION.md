# Full graph completion and bulk delivery continuation

Baseline: `760fa6e0caae0b44d7b4df2f6c2091d43bc97b16`.

## Completed bulk run

GitHub run `37314788762` completed raw capture, every selected neutral conversion
attempt, packaging, and standalone delivery verification. Its evidence artifact
`11347464204` has SHA-256
`bbbad451108dd998b5a620da02efaad9fd418ecfb851f3496762bf0c146ce383`.
The downloaded manifest records 25,235 selected objects: 25,183 exports and 52
explicit failures. All 2,665 meshes and 613 AudioClips exported; images comprise
9,354 PNG textures, 86 exact half/float payloads, and 11,751 PNG sprites. There are
714 binary TextAssets. The unresolved items are 51 textures and one sprite.
These counts refer to five selected object types, not complete prefab, gameplay,
original authoring project, font-file, or shader recovery.

Seven identity-addressed ZIP parts, their byte hashes and every individual object
outcome are in `delivery.json` and `objects.jsonl`. GitHub retains the parts under
`full-apk-neutral-part-00000` through `full-apk-neutral-part-00006`. Their recorded
expiration is October 19, 2026. Independent checks of a downloaded delivery use
`python tools/recovery_delivery.py verify <delivery-directory>`.

## Why the graph workflow failed

Run `37309287296` successfully checkpointed 955,397 decoded objects and 790 decoding
failures, leaving 29,347 objects pending. Its fixed three 600-second invocations
ended before the last objects could be attempted. The completion assertion
correctly rejected this partial traversal. It was not a raw-input capture failure.
The interrupted run is preserved; it is not relabelled a success.

## Changes

Reference lookups now have an explicit bounded cache scoped to the current
scanner/verifier invocation. Keys include serialized-member identity, file slot,
and signed path ID. Only source-reference lookups are reused; decoded object trees,
derivative results and previous success flags are not cached. Invalid fields
retain the old error outcomes. The cache is cleared on exit, including failure.
The scanner already excludes other capture writers. The verifier additionally
pins a SQLite read snapshot using a savepoint; it respects an existing caller
transaction and starts with a fresh cache each time. Verification visits objects
in member/path-ID order for locality, but still checks every tree and edge.

Fifteen new tests cover exact uncached equivalence, ambiguity, invalid references,
capacity/eviction, nested scopes, exception cleanup, edits between verification
calls and an actual second SQLite connection committing during verification.
A generated repeated-reference case reduces 100 identical SQL reads to one;
this is not a measured whole-game speedup claim.

The workflow permits a fourth bounded scan invocation, retains its strict final
completion check, and allows 75 minutes for capture, traversal, verification and
diagnostics. `inventory` already verifies original bytes and every graph edge, so
it is called once rather than duplicating the complete verification immediately
before it. Small reports/path inventories are uploaded separately from the large
SQLite backup, allowing failures and results to be inspected without downloading
the multi-gigabyte catalog. No check is skipped to make incomplete recovery pass.

## Evidence boundaries

A finished traversal can still have decode failures or unresolved pointers.
`scan_finished` is not `graph_complete`, and neither is a playable Android game.
The previous Farhad Android acceptance and recovered source trees are unchanged.
Fresh full-input outcomes must be recorded from the completed run, not inferred
from a passing generated test suite. Original APK and raw content-addressed blobs
remain necessary for a restorable source/asset package; a catalog backup alone
contains neither a full capture nor exported assets.

References: SQLite isolation and savepoints (`https://www.sqlite.org/isolation.html`,
`https://www.sqlite.org/lang_savepoint.html`); GitHub workflow job timeout semantics
(`https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax`).
