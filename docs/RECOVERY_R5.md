# R5 - real client-data bridge and Android development inspector

## Scope

R5 uses actual committed `source-app/data-tables-lua` files, not generated model
fixtures. The default profile selects 16 modules covering troop data, hero
progression and skills. It does not claim that all 1,275 Lua tables have been
converted, that these values match a freshly verified APK, or that any game logic
has been rebuilt. Original source files, previous model/animation tools and the
manual APK-acquisition trigger remain unchanged.

The supplied 813,035,279-byte APK remains unavailable through the current download
routes. It is not present in the connected Drive mount or local runtime. The full
raw-input capture gate is still open. R5 advances the usable data layer while
that external input is unavailable; it does not waive the model/animation gate.

## Build and inspect

```bash
python -m pip install -r requirements-recovery.txt
python tools/godot_data.py build --repo . --out godot/recovered_data --lua53
python tools/godot_data.py verify --out godot/recovered_data
godot --path godot
```

Use repeatable `--name MODULE` options to select other committed tables. A module
must exist in HEAD and match its Git blob hash; source edits, symlinks, unsafe
names, unsupported statements and non-table return values fail. Conversion is
staged and atomically published only when all selected modules succeed. Existing
outputs are refused. Generated packages are not committed to ordinary Git.

The native inspector offers module selection, record search, 100-record pages,
and original column/value inspection. Localization keys and resource names are
shown as recovered, not translated or replaced with invented art. It loads one
module at a time. The UI is a development tool, explicitly not the game's UI or a
playable port. The record API exposes actual numeric/boolean values and byte
strings for subsequent GDScript gameplay implementation.

## Data semantics

`tools/lua_table_data.py` statically interprets only local declarations, table
constructors, assignment/indexing, literals, unary minus and a final table return.
Calls, functions, control flow, global access, arithmetic and unsupported forms
are rejected. It is deliberately not a general Lua interpreter. Table assignments
preserve aliasing, last writes and nil deletion; parallel assignment evaluates
indices before writes. Boolean keys are distinct from numeric keys. Integral
float keys follow Lua's int64 coercion. Ambiguous duplicate constructor keys are
rejected conservatively. Resource budgets limit bytes, tokens, nesting and tables.

The neutral graph stores int64 values as decimal strings, float64 as little-endian
IEEE-754 hexadecimal bytes, strings as exact byte hex, booleans as booleans and
table references as IDs. JSON numbers are used only for bounded structural IDs.
Reachable aliases and cycles survive without recursive copying. Numeric record
keys larger than 2**53 do not pass through JSON float conversion. Godot retains
Lua strings as PackedByteArray; UTF-8 display is only a view. Table-valued cells
return explicit `["t", table_id]` tokens, not recursively expanded objects.

The catalog records source commit/tree/file hashes, output hashes, counts,
original field descriptors and an all-cell accessor digest per module. Hashes
prove input/output identity relative to this checkout, not original publisher
provenance or semantic equivalence to the binary game.

## Independent validation

With `--lua53`, only already statically accepted data chunks are evaluated by an
independent Lua 5.3 oracle in an empty environment. The chunk has no libraries,
require, operating-system, filesystem or Python capabilities. An instruction hook
and memory limit bound it. This is data-table construction, not execution of
recovered gameplay or SDK modules. Lua independently serializes the entire
reachable table graph; exact equality with Python output is required.

`godot/data_inspector/verify_data.gd` loads each selected real module, validates
all tokens/references and byte hashes, and reads every record/column through the
public native accessor. Its all-cell digest must equal the independently checked
package's digest. Separate generated boundary tests cover int64 endpoints,
integers beyond JSON's exact range, float bits, binary strings, aliases and cycles.
Generated boundary counts are not recovered game data counts.

## Android artifact

The `Client data and Android inspector` workflow builds a debug-signed ARM64 APK
with pinned Godot 4.4.1, its release-hash-checked templates, JDK 17 and Android SDK
build-tools/platform 34. It verifies the APK signature and confirms that every
packaged JSON file exactly matches its validated source package. The package ID
is `org.apk_recovery.data_inspector`, separate from the original game. Internet
permission is not requested. The inspector does not contact game servers.

This is a development build, not a Play release or the reconstructed game.
Signing keys are ephemeral and not published. Updating an earlier inspector APK
may require uninstalling that inspector when the debug key changes; the original
game uses a different package ID. CI packaging and Linux headless startup are not
Android device execution, touch/lifecycle testing or a rendering/performance test.

Evidence artifacts retain the real data catalog, conversion log, Lua comparisons,
Godot per-module cell counts/hashes, SDK/export logs and APK integrity results.
Results must be read from the completed CI run rather than assumed from this doc.

## Remaining priorities

Obtain the exact APK or verified transfer parts, perform full raw capture, and
inspect real models/animations/dependencies. Reconcile those assets with original
configuration references. Port selected gameplay rules against source/binary
oracles; the data inspector implements none of those rules. Then connect verified
assets and rules in a Godot Android gameplay slice and test on device.

Primary references: Lua 5.3 reference manual (`https://www.lua.org/manual/5.3/manual.html`),
Godot 4.4 Android export documentation (`https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_android.html`).
