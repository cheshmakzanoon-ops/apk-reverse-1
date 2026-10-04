extends SceneTree
const Data = preload("res://data_inspector/recovered_data.gd")
const Rank = preload("res://gameplay/hero_rank_rules.gd")
var failures: Array = []
var queries := 0
var rank_cases := 0
var module_results: Array = []

func check(ok: bool, message: String) -> void:
	if not ok and failures.size() < 30: failures.append(message)

func token(value: Variant) -> Variant:
	if value == null: return null
	if value is int: return ["i", str(value)]
	if value is bool: return ["b", value]
	if value is String: return ["s", value.to_utf8_buffer().hex_encode()]
	if value is float:
		var bytes := PackedByteArray(); bytes.resize(8); bytes.encode_double(0, value)
		return ["f", bytes.hex_encode()]
	return ["unsupported", str(value)]

func verify_module(data, expected: Dictionary) -> void:
	check(data.open_module(expected.name), expected.name + ": " + data.error)
	if not failures.is_empty(): return
	check(data.module.runtime_access.resolved_cell_sha256 == expected.line_cell_sha256, "Package/source oracle digest mismatch")
	var controller_hash := HashingContext.new(); controller_hash.start(HashingContext.HASH_SHA256)
	var data_id: int = data.table_ref(data.lookup_token(0, "data"))
	for encoded_key in data.tables[data_id]:
		var key: Variant = data.scalar_value(JSON.parse_string(encoded_key))
		for col in data.module.columns:
			var field: String = String(col.name_hex).hex_decode().get_string_from_utf8()
			var value: Variant = data.controller_token(key, field)
			controller_hash.update((encoded_key + "\n" + String(col.name_hex) + "\n" + JSON.stringify(value) + "\n").to_utf8_buffer())
	check(controller_hash.finish().hex_encode() == expected.controller_cell_sha256, "Controller source digest mismatch: " + expected.name)
	for query in expected.queries:
		var key: Variant = data.scalar_value(query.key)
		var field: String = String(query.field_hex).hex_decode().get_string_from_utf8()
		var got: Variant = data.controller_token(key, field, query.default) if query.controller else data.record_token(key, field, query.default)
		check(JSON.stringify(got) == JSON.stringify(query.expected), "Source default mismatch: " + expected.name + ":" + field)
		queries += 1
	for test in expected.rank_cases:
		var rank = Rank.new()
		check(rank.configure(data, data.scalar_value(test.key)), rank.error)
		if not failures.is_empty(): break
		var effect: int = data.scalar_value(test.effect)
		var stars: Array = rank.get_star_count()
		var got: Array = [token(stars[0]), token(stars[1]), token(rank.get_effect_add(effect)), token(rank.get_effect_add(effect, true)), token(rank.get_add_effect(effect)), token(rank.get_effect_ratio())]
		check(JSON.stringify(got) == JSON.stringify(test.expected), "Source rank-rule mismatch: " + expected.name + ":" + str(test.key))
		rank_cases += 1
	module_results.append({"name":expected.name,"source_cells":expected.cells,"default_queries":expected.queries.size(),"rank_cases":expected.rank_cases.size()})

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 4: push_error("Usage: -- PACKAGE ORACLE_JSON FIXTURE_PACKAGE REPORT"); quit(2); return
	var data = Data.new()
	var expected: Variant = data.read_json(args[1], 16777216)
	if not expected is Dictionary or expected.get("format") != "client-runtime-oracle-v1": push_error("Invalid oracle report"); quit(2); return
	check(FileAccess.get_sha256(args[0].path_join("catalog.json")) == expected.package_catalog_sha256, "Oracle belongs to another package")
	check(data.open_package(args[0]), data.error)
	if failures.is_empty():
		for item in expected.modules: verify_module(data, item)
	check(data.open_package(args[2]), data.error)
	if failures.is_empty(): verify_module(data, expected.generated_fixture)
	# Public rule instances must reject bad rows, not quietly synthesize real heroes.
	var rank = Rank.new(); check(not rank.configure(data, -999), "Unknown rank accepted")
	var report := {"passed":failures.is_empty(),"errors":failures,"default_queries":queries,"rank_cases":rank_cases,"modules":module_results,"godot":Engine.get_version_info().string,"binary_runtime_parity_verified":false,"device_tested":false}
	var out := FileAccess.open(args[3], FileAccess.WRITE)
	if out == null: push_error("Cannot write native semantics report"); quit(2); return
	out.store_string(JSON.stringify(report, "  ")); print(JSON.stringify(report))
	quit(0 if failures.is_empty() else 1)
