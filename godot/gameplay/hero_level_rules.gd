extends RefCounted
## Port of hash-pinned HeroLevelTemplateManager, with explicit dependency responses.
## Research replies are injected test/simulation inputs, NOT actual account state.
const Data = preload("res://data_inspector/recovered_data.gd")
const FIELDS := ["id", "level", "next_exp", "coins"]
const REPLIES := ["no_record", "record", "missing_template", "no_manager"]
const MAX_LEVEL := 10000
const MAX_COST := 9007199254740991
var error := ""
var _records: Dictionary = {}
var _cache: Dictionary = {}
var _initialized := false
var _configured := false
var _maximum := 0
var _scanned_through := 0

func _integer(value: Variant, minimum: int, maximum: int) -> bool:
	return value is int and value >= minimum and value <= maximum

func _valid_hex(value: Variant) -> bool:
	if not value is String or value.length() > 512 or value.length() % 2 != 0: return false
	for character in value:
		if not "0123456789abcdef".contains(character): return false
	return true

func configure(records: Array) -> bool:
	error = ""
	# Invalid reconfiguration invalidates the object, never leaves old ready state.
	_configured = false; _records = {}; reset_cache()
	if records.size() > MAX_LEVEL: error = "Too many level records"; return false
	var staged: Dictionary = {}
	for row in records:
		if not row is Dictionary or row.size() != 7:
			error = "Invalid level record fields"; return false
		if not _integer(row.get("key"), 1, MAX_LEVEL) or staged.has(row.key):
			error = "Invalid or duplicate record key"; return false
		for field in FIELDS:
			var maximum: int = MAX_LEVEL if field in ["id", "level"] else MAX_COST
			if not _integer(row.get(field), 0, maximum):
				error = "Unsupported level numeric value: " + field; return false
		var city: Variant = row.get("city_exp_get")
		var scalar = Data.new()
		if not scalar.valid_token(city, false, 0) or not city[0] in ["i", "f"]:
			error = "Invalid city experience token"; return false
		var city_value: Variant = scalar.scalar_value(city)
		if city_value < 0 or city_value > MAX_COST:
			error = "Invalid city experience range"; return false
		if not _valid_hex(row.get("condition_hex")):
			error = "Invalid condition bytes"; return false
		staged[row.key] = row.duplicate(true)
	_records = staged; _configured = true; return true

func configure_from_data(data) -> bool:
	error = ""; _configured = false; _records = {}; reset_cache()
	if data == null:
		error = "Missing data module"; return false
	if data.module.get("name", "") != "lw_hero_level":
		_configured = false; error = "Expected lw_hero_level module"; return false
	var records: Array = []
	for key in data.record_keys():
		var row: Dictionary = {"key": key}
		for field in FIELDS:
			var token: Variant = data.record_token(key, field)
			row[field] = data.scalar_value(token) if data.lua_truth(token) else 0
		var city: Variant = data.record_token(key, "city_exp_get")
		row.city_exp_get = city.duplicate() if data.lua_truth(city) else ["i", "0"]
		var condition: Variant = data.record_token(key, "tech_condition")
		if not data.lua_truth(condition): condition = ["s", ""]
		if condition[0] != "s":
			_configured = false; error = "Nonstring research condition"; return false
		row.condition_hex = condition[1]
		records.append(row)
	return configure(records)

func reset_cache() -> void:
	_cache = {}; _initialized = false; _maximum = 0; _scanned_through = 0

func records() -> Array:
	var result: Array = _records.values().duplicate(true)
	result.sort_custom(func(a, b): return a.key < b.key)
	return result

func conditions() -> Array:
	var unique: Dictionary = {}
	for row in _records.values():
		if not row.condition_hex.is_empty(): unique[row.condition_hex] = true
	var result: Array = unique.keys(); result.sort(); return result

func get_template(level: int) -> Variant:
	if not _configured: error = "Level rules are not configured"; return null
	if not _cache.has(level):
		if not _records.has(level): return null
		_cache[level] = _records[level].duplicate(true)
	return _cache[level].duplicate(true)

func get_unconditional_max_level() -> int:
	if not _configured: error = "Level rules are not configured"; return -1
	if not _initialized:
		for key in _records:
			_cache[key] = _records[key].duplicate(true)
			_maximum = maxi(_maximum, _records[key].level)
		_initialized = true
	return 100 if _maximum == 0 else _maximum + 1

func scanned_through() -> int:
	return _scanned_through

func evaluate(replies: Dictionary) -> Dictionary:
	error = ""
	if not _configured: error = "Level rules are not configured"; return {}
	var required: Array = conditions()
	if replies.size() != required.size():
		error = "Every condition needs an explicit dependency response"; return {}
	for condition in required:
		if not replies.has(condition) or not replies[condition] in REPLIES:
			error = "Unknown research dependency response"; return {}
	var maximum := get_unconditional_max_level()
	var skipped: Array = []
	var blocker: Dictionary = {}
	if _scanned_through != maximum - 1:
		for level in range(_scanned_through + 1, maximum):
			var row: Variant = get_template(level)
			if row == null: continue
			var condition: String = row.condition_hex
			if condition.is_empty():
				_scanned_through = level
			elif replies[condition] == "missing_template":
				# The recovered source does not break here. Preserve and disclose it.
				skipped.append(level)
			elif replies[condition] == "record":
				_scanned_through = level
			else:
				blocker = {"level": level, "condition_hex": condition, "response": replies[condition]}
				break
	return {"unconditional_max_level": maximum, "reachable_level": _scanned_through + 1,
		"scanned_through": _scanned_through, "missing_template_levels": skipped, "blocker": blocker,
		"research_state_is_injected": true, "gameplay_port_complete": false}
