# R6 — source-compatible data access and numeric hero-rank rules

## The defect fixed

R5 preserved the raw Lua table graphs, but its Godot accessor returned the stored
column value directly. That is not always what gameplay reads. In the recovered
`LocalController.lua`, descriptor slot 3 is a link flag: when flag and stored value
are truthy and `vExt` exists, the returned value is `vExt[stored_value]`.
The same source also applies Lua-specific defaults. Zero and an empty string are
truthy; false and nil are not. A missing declared string returns an empty string,
whereas an unknown column can return nil. The controller-level convenience getter
has different defaults from a LineData getter.

The existing 16-module R5 package contains 5,106 linked cells. Across all 51,248
selected cells, 10,730 runtime results differ from raw storage due to links or
defaults. This is a measurement against the previously delivered data package,
not new extraction from the original APK. R6's CI recomputes these figures. The
old raw hashes remain valid evidence of storage preservation, but were not proof
of gameplay-compatible access.

## APIs and format migration

`tools/client_semantics.py` implements a canonical graph accessor without modifying
input bytes. Godot exposes three separate methods:

- `raw_record_token(key, field)`: the untouched stored scalar or table reference.
- `record_token(key, field, default_token = null)`: the recovered LineData getter.
- `controller_token(key, field, default_token = null)`: the controller's different
  fallback convention, for already-bound typed keys and string column names.

`record_value` now decodes `record_token`, not raw storage. Table results remain
`["t", id]` references into the loaded graph; shared identity, cycles and binary
strings are retained. Default arguments use the same typed token format. These APIs
do not implement XML-ID string coercion, localization, table loading/cache cleanup,
split manifests, or network behavior. A package with split routing is rejected
instead of silently being interpreted as a flat table.

The package format is now `recovered-client-data-v2`, with the explicit accessor
contract `local-controller-line-v1`. Old v1 packages are rejected with a rebuild
requirement rather than being mislabeled as runtime-verified. No migration rewrites
or deletes previous packages. Build into a new destination or preserve/move the old
one before regenerating the inspector's `godot/recovered_data` directory.

Each module retains its original raw cell digest and adds `runtime_access` with a
resolved cell digest and counts of links, changed values, missing targets and absent
pools. A dangling pool target follows the source's nil/default behavior and is also
reported, never relabeled as a missing CDN asset. Source behavior with a missing
pool is preserved and separately reported. Original source-app files are unchanged.

## Source oracle, not a second copy of the implementation

`tools/verify_client_semantics.py` checks every selected cell using actual recovered
Lua code. It requires exactly these reviewed source blobs:

- `source-app/lua/src/Common/LocalController.lua`: `76a1301f9868528333cc45b73cc46988b487f9d1`
- `source-app/lua/src/DataCenter/HeroData/HeroRankTemplate.lua`: `f34dd61e8b6e7c2592bc6662cd73b2cf6bf7e45a`

The controller's byte-for-byte `createLineData` and `getValue` method sections run
in Lua 5.3 with a small adapter supplying already-loaded data and an identity type
binding. No controller/network/update lifecycle is started. Only statically accepted
data-only chunks enter the oracle. Source loading and calls have instruction and
memory limits; source environments have no OS, filesystem, network, require, or
Python capabilities. Changed source hashes require review, not silent reapproval.

All selected source chunks must still match their committed hashes and the package.
The independently assigned Lua graph IDs are compared against the package; then
source getter results must equal Python semantic tokens. Godot separately checks
its raw and resolved all-cell digests and replays source-generated default queries.
A separate labelled boundary package covers false, nil, zero, empty strings, linked
zero/integral-float indices, dangling targets, binary bytes, aliases and cycles.

## Actual numeric rank-rule port

`godot/gameplay/hero_rank_rules.gd` ports the supported numeric behavior of
`GetStarCount`, `GetEffectAdd` (including floor formatting), `GetAddEffect`, and
`GetEffectRatio`. It consumes resolved data rather than treating pool indices as
attribute maps. Required effect/star tables and finite numeric values are checked;
unsupported values are explicit errors. Inputs are copied so changing the
inspector's currently open module does not mutate a configured rule instance.

For every real `lw_hero_rank` record, CI compares native results with the original
recovered `HeroRankTemplate` class. It checks all present effect IDs and a missing
ID. Generated negative/fractional/zero effects exercise rounding without inflating
real record counts. The inspector displays source-derived rank results when a rank
is selected, and distinguishes stored from resolved values for every module.

This is a narrow client-rule port, not upgrade transactions, combat, complete hero
stats, localization, or server-authoritative progression. The level-cap manager was
inspected but not ported in R6: correct data-access semantics were its prerequisite.

## Run and verify

```bash
python -m pip install -r requirements-recovery.txt
python tools/godot_data.py build --repo . --out godot/recovered_data --lua53
python tools/godot_data.py verify --out godot/recovered_data
python tools/verify_client_semantics.py --repo . --package godot/recovered_data --out reports/r6

godot --headless --path godot --script data_inspector/verify_data.gd -- \
  "$PWD/godot/recovered_data" "$PWD/reports/r6/native-data.json"
godot --headless --path godot --script gameplay/verify_runtime_semantics.gd -- \
  "$PWD/godot/recovered_data" "$PWD/reports/r6/semantic-oracle.json" \
  "$PWD/reports/r6/boundary" "$PWD/reports/r6/native-semantics.json"
```

The existing Client data and Android inspector workflow runs these checks before
building the debug-signed ARM64 APK. It retains raw/semantic reports and source
hashes, verifies APK signing and packaged data bytes, and keeps the inspector's
separate package ID/no-Internet-permission configuration. A build and Linux headless
check do not establish Android device/touch/lifecycle correctness.

## Remaining gates

The supplied full game APK is still not captured in this session. The direct
runtime download route failed DNS resolution; the previously established Drive
connector file-size limit remains the input-transfer constraint. No full-APK
workflow trigger, protection, or permission was changed. R6 does not add game art,
audio, or original developer source. Capture actual input, validate real models and
animations, reconcile asset references, and build a tested gameplay slice before
claiming the Godot Android game has been reconstructed.

References: the pinned recovered source files above; Lua 5.3 manual sections 3.4.4
and 6.7 (https://www.lua.org/manual/5.3/manual.html); Godot 4.4 GDScript reference
(https://docs.godotengine.org/en/4.4/tutorials/scripting/gdscript/gdscript_basics.html).
