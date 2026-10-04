extends RefCounted
## Typed access to recovered Lua data. Table references remain ["t", id] tokens.
## Byte strings remain PackedByteArray; they are not silently coerced to UTF-8.
var error: String = ""
var catalog: Dictionary = {}
var tables: Array = []
var module: Dictionary = {}
var package_root: String = ""

func fail(message: String) -> bool:
	error = message
	return false

func whole(value: Variant, maximum: int) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= 0 and value <= maximum and float(value) == floor(float(value))

func hex_string(value: Variant, size: int = -1) -> bool:
	if not value is String or value.length() % 2 != 0 or (size >= 0 and value.length() != size):
		return false
	for character in value:
		if not character in "0123456789abcdef":
			return false
	return true

func read_json(path: String, maximum: int = 33554432) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > maximum:
		fail("Missing or oversized data file: " + path)
		return null
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		fail("Invalid JSON: " + path)
		return null
	return parser.data

func open_package(path: String) -> bool:
	error = ""
	catalog = {}
	tables = []
	module = {}
	var parsed: Variant = read_json(path.path_join("catalog.json"), 1048576)
	if not parsed is Dictionary or parsed.get("format") != "recovered-client-data-v2" or parsed.get("state") != "ready":
		return fail("Data package is not ready")
	if parsed.get("accessor_contract") != "local-controller-line-v1":
		return fail("Unsupported runtime accessor contract; rebuild the package")
	var modules: Variant = parsed.get("modules")
	if not modules is Array or modules.is_empty() or modules.size() != parsed.get("selected_modules"):
		return fail("Invalid module coverage")
	if not hex_string(parsed.get("source_commit"), 40) or not hex_string(parsed.get("source_tree"), 40):
		return fail("Missing source provenance")
	var names := {}
	for item in modules:
		if not item is Dictionary or not item.get("name") is String or names.has(item.name) or not hex_string(item.get("sha256"), 64):
			return fail("Invalid module identity")
		if not whole(item.get("bytes"), 33554432) or not whole(item.get("row_count"), 2000000):
			return fail("Invalid module budget")
		names[item.name] = true
	catalog = parsed
	package_root = path
	return true

func valid_token(token: Variant, key_mode: bool, count: int) -> bool:
	if not token is Array or token.size() != 2 or not token[0] is String:
		return false
	var value: Variant = token[1]
	match token[0]:
		"b": return value is bool
		"i":
			if not value is String or not value.is_valid_int() or str(value.to_int()) != value:
				return false
			return true
		"s": return hex_string(value)
		"f":
			if not hex_string(value, 16): return false
			var number: float = value.hex_decode().decode_double(0)
			if not is_finite(number): return false
			# Canonical Lua keys convert integral floats in int64 range to integers.
			if key_mode and number >= -9223372036854775808.0 and number < 9223372036854775808.0 and number == floor(number):
				return false
			return true
		"t": return not key_mode and whole(value, count - 1)
	return false

func token_key(token: Array) -> String:
	return JSON.stringify(token)

func lookup_token(table_id: int, key_value: Variant) -> Variant:
	if table_id < 0 or table_id >= tables.size(): return null
	var token: Array
	match typeof(key_value):
		TYPE_INT: token = ["i", str(key_value)]
		TYPE_BOOL: token = ["b", key_value]
		TYPE_STRING: token = ["s", key_value.to_utf8_buffer().hex_encode()]
		TYPE_PACKED_BYTE_ARRAY: token = ["s", key_value.hex_encode()]
		TYPE_FLOAT:
			if not is_finite(key_value): return null
			if key_value == floor(key_value) and key_value >= -9223372036854775808.0 and key_value < 9223372036854775808.0:
				token = ["i", str(int(key_value))]
			else:
				var raw := PackedByteArray(); raw.resize(8); raw.encode_double(0, key_value)
				token = ["f", raw.hex_encode()]
		_: return null
	return tables[table_id].get(token_key(token))

func scalar_value(token: Variant) -> Variant:
	if token == null: return null
	match token[0]:
		"i": return String(token[1]).to_int()
		"f": return String(token[1]).hex_decode().decode_double(0)
		"s": return String(token[1]).hex_decode()
		"b": return token[1]
		"t": return ["t", int(token[1])]
	return null

func table_ref(token: Variant) -> int:
	return int(token[1]) if token is Array and token.size() == 2 and token[0] == "t" else -1

func open_module(name: String) -> bool:
	error = ""; tables = []; module = {}
	for item in catalog.get("modules", []):
		if item.name == name: module = item; break
	if module.is_empty(): return fail("Unknown module")
	var path: String = package_root.path_join("modules").path_join(module.sha256 + ".json")
	if FileAccess.get_sha256(path) != module.sha256:
		return fail("Module hash mismatch")
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() != int(module.bytes): return fail("Module size mismatch")
	var document: Variant = read_json(path)
	if not document is Dictionary or document.get("format") != "lua-table-graph-v1" or document.get("root") != 0:
		return fail("Invalid table graph")
	var raw_tables: Variant = document.get("tables")
	if not raw_tables is Array or raw_tables.is_empty() or raw_tables.size() > 300000 or raw_tables.size() != module.get("table_count"):
		return fail("Invalid table count")
	var entry_count := 0
	for entries in raw_tables:
		if not entries is Array: return fail("Invalid table entries")
		var indexed := {}
		var previous := ""
		for entry in entries:
			if not entry is Array or entry.size() != 2 or not valid_token(entry[0], true, raw_tables.size()) or not valid_token(entry[1], false, raw_tables.size()):
				return fail("Malformed scalar or table reference")
			var identifier := token_key(entry[0])
			if indexed.has(identifier) or (not previous.is_empty() and identifier <= previous):
				return fail("Duplicate or noncanonical key")
			indexed[identifier] = entry[1]; previous = identifier; entry_count += 1
		tables.append(indexed)
	if entry_count != module.get("entry_count"): return fail("Entry coverage mismatch")
	var reached := {0: true}; var queue := [0]; var at := 0
	while at < queue.size():
		for token in tables[queue[at]].values():
			if token[0] == "t" and not reached.has(int(token[1])):
				reached[int(token[1])] = true; queue.append(int(token[1]))
		at += 1
	if reached.size() != tables.size(): return fail("Unreachable table data")
	var data_id := table_ref(lookup_token(0, "data"))
	var index_id := table_ref(lookup_token(0, "index"))
	if data_id < 0 or index_id < 0 or tables[data_id].size() != int(module.row_count):
		return fail("Invalid index/data record schema")
	if lookup_token(0, "link") != null: return fail("Split-table routing is not implemented")
	var pool: Variant = lookup_token(0, "vExt")
	if lua_truth(pool) and table_ref(pool) < 0: return fail("Invalid vExt table")
	var columns: Variant = module.get("columns")
	if not columns is Array or columns.size() != tables[index_id].size(): return fail("Column coverage mismatch")
	var slots := {}; var fields := {}
	for col in columns:
		if not col is Dictionary or not hex_string(col.get("name_hex")) or not hex_string(col.get("declared_type_hex")):
			return fail("Invalid column metadata")
		if not whole(col.get("slot"), 2000000) or col.slot == 0 or slots.has(int(col.slot)) or fields.has(col.name_hex):
			return fail("Invalid or duplicate column slot/name")
		var desc := table_ref(lookup_token(index_id, String(col.name_hex).hex_decode()))
		if desc < 0 or scalar_value(lookup_token(desc, 1)) != int(col.slot) or lookup_token(desc, 2) != ["s", col.declared_type_hex]:
			return fail("Column metadata differs from source graph")
		slots[int(col.slot)] = true; fields[col.name_hex] = true
	if not module.get("runtime_access") is Dictionary or not hex_string(module.runtime_access.get("resolved_cell_sha256"), 64):
		return fail("Missing runtime accessor evidence")
	for row in tables[data_id].values():
		if table_ref(row) < 0: return fail("Record is not a table")
	return true

func record_keys() -> Array:
	var result := []
	var data_id := table_ref(lookup_token(0, "data"))
	if data_id < 0: return result
	for encoded_key in tables[data_id]:
		result.append(scalar_value(JSON.parse_string(encoded_key)))
	return result

func raw_record_token(record_key: Variant, field: String) -> Variant:
	var index_id := table_ref(lookup_token(0, "index"))
	var data_id := table_ref(lookup_token(0, "data"))
	var descriptor := table_ref(lookup_token(index_id, field))
	var row := table_ref(lookup_token(data_id, record_key))
	if descriptor < 0 or row < 0: return null
	var slot: Variant = scalar_value(lookup_token(descriptor, 1))
	return lookup_token(row, slot)

func lua_truth(token: Variant) -> bool:
	return token != null and not (token[0] == "b" and token[1] == false)

func record_token(record_key: Variant, field: String, default_token: Variant = null) -> Variant:
	# Source: LocalController.createLineData's getValue closure (not controller getValue).
	var index_id := table_ref(lookup_token(0, "index"))
	var data_id := table_ref(lookup_token(0, "data"))
	var descriptor := table_ref(lookup_token(index_id, field))
	var row := table_ref(lookup_token(data_id, record_key))
	if descriptor < 0 or row < 0: return default_token
	var value: Variant = resolved_record_token(record_key, field)
	if lua_truth(value): return value
	var declared: Variant = lookup_token(descriptor, 2)
	if declared == ["s", "string".to_utf8_buffer().hex_encode()]:
		return default_token if lua_truth(default_token) else ["s", ""]
	return default_token

func resolved_record_token(record_key: Variant, field: String) -> Variant:
	var descriptor := table_ref(lookup_token(table_ref(lookup_token(0, "index")), field))
	var value: Variant = raw_record_token(record_key, field)
	var pool := table_ref(lookup_token(0, "vExt"))
	if lua_truth(lookup_token(descriptor, 3)) and lua_truth(value) and pool >= 0:
		# Preserve exact tokens/alias IDs. A dangling reference returns nil as in Lua.
		if value[0] == "t": return null
		return lookup_token(pool, scalar_value(value))
	return value

func controller_token(record_key: Variant, field: String, default_token: Variant = null) -> Variant:
	var value: Variant = resolved_record_token(record_key, field)
	return value if lua_truth(value) else (default_token if lua_truth(default_token) else ["s", ""])

func record_value(record_key: Variant, field: String) -> Variant:
	return scalar_value(record_token(record_key, field))

func describe(token: Variant, depth: int = 0) -> String:
	if token == null: return "nil (absent)"
	if token[0] == "s":
		var raw: PackedByteArray = scalar_value(token)
		var text := raw.get_string_from_utf8()
		return text if text.to_utf8_buffer() == raw else "bytes:0x" + token[1]
	if token[0] != "t": return str(scalar_value(token))
	var id := int(token[1])
	if depth >= 2: return "table #%d (%d entries)" % [id, tables[id].size()]
	var parts := PackedStringArray()
	for k in tables[id]:
		if parts.size() >= 8:
			parts.append("..."); break
		parts.append(describe(JSON.parse_string(k), depth + 1) + ": " + describe(tables[id][k], depth + 1))
	return "{" + ", ".join(parts) + "}"
