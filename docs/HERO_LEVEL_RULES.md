# Hero-level rules — source-derived hero-level limits and a stateful native inspector

## Deliverable and limits

This implementation was originally delivered as an unpublished patch and is now
integrated with the real-model bridge. Its Python/Lua tests and native checks run
in CI before Android inspector export. Results must be read from the completed
run rather than inferred from this specification. Android device execution is
not performed by these workflows.

This increment ports the supported integer/scalar projection of `HeroLevelTemplate` and the
level-cap behavior of `HeroLevelTemplateManager` to native GDScript. It uses the
actual `lw_hero_level` module already present in the R6 data package. It adds no
new art, sound, raw APK capture, original developer source, or playable combat.
During implementation another writer added the R7 APK intake workflow. Its
artifacts made the exact 813,035,279-byte supplied APK available. See
`REAL_MODEL_BRIDGE.md` for the current real-model conversion. The level rules
still consume the separately validated R6 configuration package, not a fresh
comparison of those tables with this APK. Concurrent intake files are preserved.

The native inspector is a development simulator. Research-method responses are
explicit injected inputs; they are not the user's account state, a reconstructed
ScienceTemplateManager, a claim about science IDs, or server authorization.
Changing a dropdown cannot unlock anything in the original game. No external
calls, spending, upgrade transactions, or persistent account changes occur.

## Source contract

The oracle requires these exact reviewed Git blobs:

- `source-app/lua/src/DataCenter/HeroData/HeroLevel/HeroLevelTemplate.lua`:
  `bdb7ad6a1314362cbbdc842c799b45b57a2d388d`
- `source-app/lua/src/DataCenter/HeroData/HeroLevel/HeroLevelTemplateManager.lua`:
  `bbe818a0536b6108eb9ff0ca04554652d83d0906`

The GDScript implementation preserves the important distinctions in that source:

- Record lookup uses the record key, not the row's authored `level` value.
- The unconditional limit is the maximum authored level plus one. An empty or
  zero-maximum table returns 100 for that method, but the reachable method can
  still return 1 when there are no traversable templates.
- Scanning starts after the cached `maxReachableLevel` and advances that cache;
  repeated calls do not automatically reevaluate earlier research requirements.
- A missing record is skipped. A missing research template is also skipped, not
  treated as a blocking condition. Later unconditional rows may advance the cap.
- When a research template exists, an absent science manager or absent science
  object stops scanning. The method checks object presence, not its level.
- Reinitialization clears the cache. The inspector shows both the retained cache
  result and a newly constructed manager for the same dependency replies.

Missing dependency *knowledge* is not the same as a source nil result. Every
condition must have an explicit reply. Incomplete/invalid snapshots fail before
changing cache state. Duplicate/invalid keys, noninteger fields, unbounded levels,
unsafe-size numeric values, and invalid byte encodings are unsupported inputs,
not silently coerced data. Configuration is copied; returned records are copies.
A failed reconfiguration invalidates the rule instance instead of retaining a
ready instance with an earlier dataset.

## Native API

`godot/gameplay/hero_level_rules.gd` provides `configure_from_data`, `get_template`,
`get_unconditional_max_level`, `evaluate`, and `reset_cache`. Alternatively,
`configure(records)` accepts normalized records with `key`, `id`, `level`,
`next_exp`, `coins`, `city_exp_get`, and exact `condition_hex` bytes. The city
experience field uses the existing typed `["i", decimal]` or `["f", IEEE754-hex]`
representation: the real configuration includes fractional values, which must
not be cast to integers or rounded through a JSON numeric representation.

The normalization uses R6's source-compatible getters, including linked values
and Lua's false/nil default behavior. It supports nonnegative integer ID/level/experience-cost/coin values
and exact nonnegative integer or float64 city-experience tokens, with levels and record keys at most 10,000. Cost fields are limited to
integers at most 2**53-1 for exact cross-runtime JSON trace comparisons. This is a
bounded supported subset, not the full range of values Lua itself can represent.
Resource/unlock tables remain accessible through the existing R6 data module and
are displayed unchanged; their interpretation and spending semantics are not
implemented by this level-cap module.

`evaluate` accepts a dictionary keyed by exact condition hex. Values are
`no_record`, `record`, `missing_template`, or `no_manager`. Those names describe
*dependency responses*. In particular, `record` means the source receives a
truthy science object; it does not claim that a research purchase was completed.
Reports explicitly flag `research_state_is_injected` and retain
`gameplay_port_complete: false`.

## Independent verification

`tools/hero_level_oracle.py` does not contain a second copy of the cap algorithm.
It loads both complete hash-pinned Lua files into Lua 5.3. A small trusted adapter
supplies BaseClass construction, the one allowed template require, already
normalized source-backed rows, and injected research replies. The adapter-local
science ID is only a request token, not an inferred game science ID. The source
environment has no filesystem, network, operating-system, debug, arbitrary require,
or Python bridge. Source loading and method calls have instruction and memory
budgets. Source hashes and input package hashes are checked before publishing.

All supported fields of every real record are checked through lazy and cached
GetTemplate calls. Stateful scenarios include absent/present research, missing
manager/template, unlock then withdrawal, and explicit reset. Separately labelled
boundary datasets cover an empty table, holes, differing keys/authored levels,
multiple gates, a zero authored maximum, and binary condition bytes. Their results
must never inflate recovered game-record totals.

`godot/gameplay/verify_hero_levels.gd` independently reads the real package and
compares its normalized records and native execution against the original Lua
traces. It also checks input/return isolation, duplicate records, invalid numeric
values, invalid hex, incomplete dependency snapshots, and cache invalidation.
CI starts the new inspection scene headlessly and treats GDScript/runtime errors
as failures before building the Android development APK. Existing R1–R6 tests
remain enabled. Results must be obtained from the completed run, not assumed from
this specification.

## Run

Build the existing R6 package into a new/empty destination first, then:

```bash
python tools/hero_level_oracle.py --repo . --package godot/recovered_data --out reports/hero-levels
godot --headless --path godot --script gameplay/verify_hero_levels.gd -- \
  "$PWD/godot/recovered_data" "$PWD/reports/hero-levels/hero-level-oracle.json" \
  "$PWD/reports/hero-levels/native-hero-levels.json"
godot --path godot res://level_inspector/main.tscn
```

The regular data inspector has an entry button for the new view. It displays
original template fields, explicit dependency replies, cached/fresh limits, and
warnings for source behavior around missing templates. It does not impersonate
the original game's UI. The Android inspector retains its separate package ID,
ARM64 debug build, ephemeral debug signing, and no Internet permission.

## Remaining work

The original APK is now assembled and hash-verified. The separate real-model bridge
exports one textured, skinned Farhad prefab and two dense non-legacy clips.
Streamed curves, other models/materials and original runtime equivalence remain
separate work. This level port still needs actual science-template lookup and
authoritative research-state adapters, broader hero progression and combat, real
art/animation integration, and Android device/emulator execution. An Android
build and Linux headless tests alone do not demonstrate touch, lifecycle,
rendering, performance, server, or complete-game equivalence.
