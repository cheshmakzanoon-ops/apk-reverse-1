# Opening-stage dependency package

The full graph finished in CI run `37319598694` at `e22cbca`. The preceding
`9d94be4` acceptance document records local verification separately. This stage
uses the completed CI catalog rather than restarting a million-object traversal.

## Selection and scope

`docs/inputs/opening-stage-scope.json` pins four original container paths, object
IDs and object hashes: the default opening-stage road, SoloHero, ZakuB and ZakuC.
The actor selection follows `ShowInTroubledFellow` in recovered
`LWOpeningStageDirtyWorks.lua`: SoloHero is placed at stage ID 6 and the encounter
spawns five ZakuB/C instances. The initial Enemy_2_1 candidate was replaced after
source review showed it was not this encounter's opponent set.

This is a dependency-complete actor/environment recovery scope, not proof of a
fully assembled playable stage. Runtime-selected road variants, stage-position
configuration, timers, events and gameplay still need separate verification.

`recovery_scope.py plan` follows every recorded non-null serialized reference from
these roots, including components, meshes, skins, materials, controllers, clips,
scripts and shader dependencies. Resource streams are accounted for separately.
It never resolves by display name, imports an entire bundle as if all its objects
belonged to the selection, or ignores a decoder failure. Loops and shared targets
are traversed once. A finished graph may still produce a blocked selection.

The profile binds the supplied APK hash. The workflow separately pins the exact
upstream artifact ID, commit and archive SHA-256. Planning opens a read-only SQLite
snapshot and does not modify its checkpoint. The scope records source units,
serialized members, original object hashes, raw spans, reference locations and
all blockers. Budgets fail explicitly rather than return truncated success.

## Preservation

`extract` reopens the original APK, verifies source entry/unit/member hashes, and
reparses each selected object's exact original bytes and serialized references.
It preserves selected raw object bytes, lossless decoded trees and needed resource
ranges in SHA-256-addressed blobs. It does not deliver mixed original bundles or
font payloads. Binary fields are real verified blobs, never size-only summaries.
An existing destination is refused. Publication follows a full package verification.

The package contains `scope.json`, `receipt.json`, and `blobs/`. It is a recovery
package, not a Unity project, GLB, ready-made Godot scene, or playable APK. Source
unit offsets remain a recipe against the original APK, not evidence that every
original file is included. The existing model conversion and Android checks remain
unchanged. Standalone verification recomputes references, reachability, hashes,
coverage and completeness and rejects missing or unaccounted payloads.

## Code links

`recovery_source_links.py` scans committed recovered C#/Lua text for occurrences of
selected asset stems. It verifies matched files against their Git blob identity
and records exact paths, lines and SHA-256 hashes. These are static review leads,
not an execution trace or an assertion that all dynamic dependencies are known.
No game code or network service is executed by the scan. Gameplay rules must still
be traced and tested before they are labelled ported or behaviorally equivalent.

## Reproduce

```bash
python tools/recovery_scope.py plan --catalog catalog.sqlite --profile docs/inputs/opening-stage-scope.json --out scope.json
python tools/recovery_scope.py extract --apk original.apk --plan scope.json --out opening-stage
python tools/recovery_scope.py verify opening-stage
python tools/recovery_source_links.py --repo . --scope scope.json --out source-links.json
```

The dedicated workflow downloads the retained graph artifact, verifies it, selects
this scope, reacquires only the supplied hash-pinned APK, and independently checks
all selected objects. Its token has only contents/actions read permissions.
Artifacts expire; after expiration regenerate the original full graph or supply its
retained verified catalog locally. It never silently substitutes a newer input.

## Acceptance boundaries

- `serialized_closure_complete`: all known serialized dependencies within these
  selected roots decoded/resolved; it is not complete gameplay or shader support.
- `dynamic_dependencies_audited`, `source_behavior_verified`, and
  `godot_stage_complete` remain false until separately established.
- Unit tests are generated fixtures. Actual counts, errors and export hashes come
  only from the dedicated completed run and its downloaded artifacts.

Next, inspect actual component and source-link results to connect an original map,
player and enemy through their original stage logic. Do not invent missing behavior
and report it as recovered gameplay.

Primary references: https://docs.github.com/en/rest/actions/artifacts and
https://docs.python.org/3/library/sqlite3.html#how-to-work-with-sqlite-uris.

## Actual-source corrections

The first executed run `37350529455` planned a 1,871-object closure but failed
fresh-byte acceptance. Native material maps expose tuple pairs; comparing those
before lossless normalization overlooked their nested texture pointers. The
extractor now compares the same normalized representation as the captured graph,
without removing or modifying expected references.

That correction exposed an additional Cubemap resource stream absent from the raw
capture's three-type stream index. Scope planning now examines hashed packed trees
for all other decoded object types and resolves their stream ranges explicitly.
The selected cubemap contributes one 63,072-byte resource range. Raw object and
resource identities are unchanged. Standalone verification also checks delivered
tree stream declarations against the scope rather than trusting stream counts.

The source tracer now checks every inspected file against its recorded HEAD blob,
including nonmatching files. A local edit that removes a matching resource name
cannot silently turn into a claim that no source link exists. Missing, symlinked
and oversized files are reported separately; matches remain static review leads.
Nine new dependency/stream regressions and fourteen source-trace regressions cover
these corrections. Local corrected extraction passed for 1,871 original objects
and 34 resource ranges. Only the subsequent successful CI artifacts establish
publication acceptance; the earlier failed run is retained as failure evidence.

## Reviewed runtime source leads

`source-app/lua/src/DataCenter/LWOpeningStageManager/LWOpeningStageDirtyWorks.lua`
(Git blob `29d91dd296a51e96feeaed10be9f5b2c604318d2`, lines 495-555) supplies the
encounter actor paths, five spawn positions/rotations and 4/5/6-second walk durations.
SoloHero has scale 1.2; its position comes from the first node of stage ID 6.
Those are source-code observations, not an execution of the shipped binary.

`LWOpeningStageSoloHero.lua` (blob `b481de95b6eebe2d3a7f506e8119198aa210d3c5`)
loads SimpleAnimation/SoloHeroTurret/SoloHeroMuzzle and delegates to separate Idle,
Aim, Fire and Reload states. `LWOpeningStageUtils.lua` (blob
`1e30b6afe515459e489055625775b79ed8e2e910`) obtains the road path through a
civilization-extension hook and uses stage configuration for positions and enemy
variants. Therefore raw prefab closure alone does not identify all runtime content.

The evidence artifact includes an archive of the unchanged recovered stage-manager
Lua directory, SoloHero muzzle/turret C# files, and three stage configuration
variants. This is a focused copy of existing decompiled/recovered source for review,
not a new recovery of the original developer repository and not certified complete
runtime source. Its archive hash and source commit are retained separately.
