extends SceneTree
const Rules = preload("res://gameplay/hero_level_rules.gd")
const Data = preload("res://data_inspector/recovered_data.gd")
var errors: Array = []
var steps := 0
var templates := 0
var scenarios := 0
var negative_checks := 0

func check(ok: bool, message: String) -> void:
	if not ok and errors.size() < 40: errors.append(message)

func normalize_record(value: Variant) -> Variant:
	if value == null: return null
	var result: Dictionary = value.duplicate(true)
	for key in ["key", "id", "level", "next_exp", "coins"]:
		check(result[key] == floor(result[key]) and abs(result[key]) <= 9007199254740991.0, "Invalid oracle integer")
		result[key] = int(result[key])
	return result

func run_dataset(dataset: Dictionary) -> void:
	var records: Array = []
	for row in dataset.records: records.append(normalize_record(row))
	for scenario in dataset.scenarios:
		scenarios += 1
		var rules = Rules.new()
		check(rules.configure(records), dataset.name + ": " + rules.error)
		for query in scenario.before:
			templates += 1
			check(rules.get_template(int(query.key)) == normalize_record(query.expected), dataset.name + ": lazy template mismatch")
		for step in scenario.steps:
			if step.reset: rules.reset_cache()
			var result: Dictionary = rules.evaluate(step.responses)
			check(not result.is_empty(), dataset.name + ": " + rules.error)
			if result.is_empty(): continue
			var actual := [result.unconditional_max_level, result.reachable_level, result.scanned_through]
			var expected: Array = step.expected.map(func(v): return int(v))
			check(actual == expected, "%s/%s: got %s expected %s" % [dataset.name, scenario.name, str(actual), str(expected)])
			steps += 1
		for query in scenario.after:
			templates += 1
			check(rules.get_template(int(query.key)) == normalize_record(query.expected), dataset.name + ": cached template mismatch")

func invalid_inputs() -> void:
	var row := {"key":1,"id":1,"level":1,"next_exp":12,"coins":0,"city_exp_get":["i","0"],"condition_hex":"41"}
	var rules = Rules.new()
	check(rules.configure([row]), "Valid boundary configure")
	row.level = 900
	check(rules.get_template(1).level == 1, "Input alias escaped")
	var returned: Dictionary = rules.get_template(1); returned.level = 800
	check(rules.get_template(1).level == 1, "Return alias escaped")
	negative_checks += 2
	for response in [{}, {"41":"unknown"}, {"41":true}, {"41":"record", "42":"record"}]:
		check(rules.evaluate(response).is_empty() and rules.scanned_through() == 0, "Invalid dependency snapshot accepted or mutated cache")
		negative_checks += 1
	for change in [{"key":true},{"level":-1},{"next_exp":-2},{"level":1.5},{"condition_hex":"x"},{"condition_hex":"0"},{"condition_hex":"FF"},{"coins":9007199254740992},{"city_exp_get":["f","000000000000f07f"]},{"city_exp_get":["i","-1"]}]:
		var broken := {"key":1,"id":1,"level":1,"next_exp":12,"coins":0,"city_exp_get":["i","0"],"condition_hex":"41"}
		broken.merge(change,true)
		check(not rules.configure([broken]), "Invalid schema accepted: " + str(change))
		check(rules.evaluate({"41":"record"}).is_empty(), "Failed configure retained stale state")
		negative_checks += 1
	check(not rules.configure([row,row]), "Duplicate row key accepted"); negative_checks += 1
	check(rules.configure([row]), "Valid reconfiguration failed")
	check(not rules.configure_from_data(Data.new()), "Wrong module accepted")
	check(rules.records().is_empty() and rules.conditions().is_empty(), "Failed module configuration retained prior data")
	negative_checks += 1

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 3: printerr("usage: PACKAGE ORACLE OUTPUT"); quit(2); return
	var file := FileAccess.open(args[1],FileAccess.READ)
	if file == null: printerr("Missing source oracle"); quit(2); return
	var report: Variant = JSON.parse_string(file.get_as_text())
	if not report is Dictionary or report.get("format") != "hero-level-source-oracle-v1":
		printerr("Invalid source oracle"); quit(2); return
	check(FileAccess.get_sha256(args[0].path_join("catalog.json")) == report.package_catalog_sha256, "Oracle/package hash mismatch")
	var data = Data.new()
	check(data.open_package(args[0]) and data.open_module("lw_hero_level"), "Cannot load actual level module: " + data.error)
	var rules = Rules.new()
	check(rules.configure_from_data(data), "Real package normalization failed: " + rules.error)
	var expected: Array = report.real.records.map(func(v):return normalize_record(v))
	check(rules.records() == expected, "Native real-data normalization differs from source-backed input")
	run_dataset(report.real)
	var real_steps := steps; var real_templates := templates; var real_scenarios := scenarios
	for dataset in report.generated: run_dataset(dataset)
	invalid_inputs()
	var result := {"passed": errors.is_empty(), "errors":errors, "real_records":expected.size(),
		"real_scenarios":real_scenarios,"real_steps":real_steps,"real_template_checks":real_templates,
		"generated_scenarios":scenarios-real_scenarios,"generated_steps":steps-real_steps,
		"generated_template_checks":templates-real_templates,"negative_checks":negative_checks,
		"research_state_is_injected":true,"android_device_tested":false,"source_binary_equivalence_verified":false}
	var output := FileAccess.open(args[2],FileAccess.WRITE)
	if output == null: printerr("Cannot write verification report"); quit(2); return
	output.store_string(JSON.stringify(result,"  "));output.close();print(JSON.stringify(result))
	quit(0 if errors.is_empty() else 2)
