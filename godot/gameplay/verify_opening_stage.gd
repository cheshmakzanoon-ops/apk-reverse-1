extends SceneTree
## Replays the oracle's scenarios through the GDScript port and compares the complete event
## trace and final state. Usage: -- ORACLE_JSON OUTPUT_JSON
const Encounter = preload("res://gameplay/opening_stage_encounter.gd")
const TOLERANCE := 1e-9
const RNG_SCALE := 1073741824.0

var errors: Array = []
var scenarios_run := 0
var events_compared := 0

func _initialize() -> void:
	call_deferred("run")

func is_number(v: Variant) -> bool:
	return v is int or v is float

## Returns "" when equal, otherwise a description of the first difference.
## Empty arrays and empty dictionaries compare equal (a Lua table has no such distinction).
func diff(actual: Variant, expected: Variant, path: String) -> String:
	if is_number(actual) and is_number(expected):
		var a := float(actual)
		var e := float(expected)
		if absf(a - e) <= TOLERANCE * (1.0 + maxf(absf(a), absf(e))): return ""
		return "%s: got %s expected %s" % [path, str(actual), str(expected)]
	var a_empty: bool = (actual is Array or actual is Dictionary) and actual.is_empty()
	var e_empty: bool = (expected is Array or expected is Dictionary) and expected.is_empty()
	if a_empty and e_empty: return ""
	if actual is Dictionary and expected is Dictionary:
		for key in expected:
			if not actual.has(key): return "%s: missing key %s" % [path, str(key)]
			var inner := diff(actual[key], expected[key], path + "." + str(key))
			if inner != "": return inner
		for key in actual:
			if not expected.has(key): return "%s: unexpected key %s" % [path, str(key)]
		return ""
	if actual is Array and expected is Array:
		if actual.size() != expected.size():
			return "%s: length %d expected %d" % [path, actual.size(), expected.size()]
		for i in actual.size():
			var inner := diff(actual[i], expected[i], "%s[%d]" % [path, i])
			if inner != "": return inner
		return ""
	if typeof(actual) == typeof(expected) and actual == expected: return ""
	return "%s: got %s expected %s" % [path, str(actual), str(expected)]

func first_trace_difference(actual: Array, expected: Array) -> String:
	var shared := mini(actual.size(), expected.size())
	for i in shared:
		var inner := diff(actual[i], expected[i], "trace[%d]" % i)
		if inner != "":
			return "%s (actual %s | expected %s)" % [inner, JSON.stringify(actual[i]), JSON.stringify(expected[i])]
	if actual.size() != expected.size():
		return "trace length %d expected %d" % [actual.size(), expected.size()]
	return ""

func run_scenario(run: Dictionary) -> Dictionary:
	var spec: Dictionary = run.scenario
	var ints: Array = spec.rng
	var cursor := {"i": 0}
	var enc = Encounter.new()
	enc.rng = func():
		if cursor.i >= ints.size():
			enc.error = "scripted random sequence exhausted"
			return 0.0
		var value := float(ints[cursor.i]) / RNG_SCALE
		cursor.i += 1
		return value
	enc.hero_load_delay = float(spec.hero_load_delay)
	enc.zaku_load_delay = float(spec.zaku_load_delay)
	enc.vfx_load_delay = float(spec.vfx_load_delay)
	enc.start(spec.hero)
	var dt := 1.0 / float(spec.fps)
	for _i in int(spec.steps): enc.step(dt)
	var name: String = spec.name
	var message := first_trace_difference(enc.trace, run.trace)
	if message == "":
		message = diff(enc.snapshot(), run.final, "final")
	if message == "" and enc.error != "": message = enc.error
	events_compared += enc.trace.size()
	scenarios_run += 1
	if message != "" and errors.size() < 40: errors.append("%s: %s" % [name, message])
	var summary := {"name": name, "events": enc.trace.size(), "kills": enc.kills, "rng_draws": enc.rng_draws,
		"matches_oracle": message == "", "first_difference": message,
		"oracle_ambiguous_update_order_frames": run.ambiguous_frames.size()}
	enc.dispose()
	return summary

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2: printerr("usage: ORACLE OUTPUT"); quit(2); return
	var file := FileAccess.open(args[0], FileAccess.READ)
	if file == null: printerr("Missing oracle"); quit(2); return
	var oracle: Variant = JSON.parse_string(file.get_as_text())
	if not oracle is Dictionary or oracle.get("schema") != 1 or not oracle.get("scenarios") is Array:
		printerr("Invalid oracle"); quit(2); return
	var results: Array = []
	for run_data in oracle.scenarios: results.append(run_scenario(run_data))
	var report := {"passed": errors.is_empty(), "errors": errors, "scenarios": results,
		"scenarios_run": scenarios_run, "events_compared": events_compared,
		"oracle_harness_sha256": oracle.harness_sha256,
		"turret_and_muzzle_placement_are_fixtures": true,
		"android_device_tested": false, "source_binary_equivalence_verified": false}
	var output := FileAccess.open(args[1], FileAccess.WRITE)
	if output == null: printerr("Cannot write verification report"); quit(2); return
	output.store_string(JSON.stringify(report, "  ")); output.close()
	print(JSON.stringify(report))
	quit(0 if errors.is_empty() else 2)
