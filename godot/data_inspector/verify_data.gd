extends SceneTree
const Data = preload("res://data_inspector/recovered_data.gd")
var failures: Array = []
var cells := 0

func check(condition: bool, message: String) -> void:
	if not condition: failures.append(message)

func canonical(token: Variant) -> String:
	if token == null: return "null"
	if token[0] == "t": return '["t",%d]' % int(token[1])
	return JSON.stringify(token)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2:
		push_error("Usage: verify_data.gd -- PACKAGE REPORT"); quit(2); return
	var data = Data.new()
	var results := []
	check(data.open_package(args[0]), data.error)
	if failures.is_empty():
		for item in data.catalog.modules:
			check(data.open_module(item.name), item.name + ": " + data.error)
			if not failures.is_empty(): break
			var hash := HashingContext.new(); hash.start(HashingContext.HASH_SHA256)
			var raw_hash := HashingContext.new(); raw_hash.start(HashingContext.HASH_SHA256)
			var data_id: int = data.table_ref(data.lookup_token(0, "data"))
			var module_cells := 0
			for encoded_key in data.tables[data_id]:
				var actual_key: Variant = data.scalar_value(JSON.parse_string(encoded_key))
				for col in item.columns:
					var field_bytes: PackedByteArray = String(col.name_hex).hex_decode()
					var field_name := field_bytes.get_string_from_utf8()
					check(field_name.to_utf8_buffer() == field_bytes, "Non-UTF8 column identifier unsupported by record API")
					var raw_token: Variant = data.raw_record_token(actual_key, field_name)
					raw_hash.update((encoded_key + "\n" + String(col.name_hex) + "\n" + canonical(raw_token) + "\n").to_utf8_buffer())
					var token: Variant = data.record_token(actual_key, field_name)
					var cell: Variant = data.record_value(actual_key, field_name)
					if token != null:
						if token[0] == "i": check(cell is int and str(cell) == token[1], "Integer precision changed")
						if token[0] == "s": check(cell is PackedByteArray and cell.hex_encode() == token[1], "Byte string changed")
						if token[0] == "b": check(cell is bool and cell == token[1], "Boolean changed")
						if token[0] == "f":
							var bits := PackedByteArray(); bits.resize(8); bits.encode_double(0, cell)
							check(cell is float and bits.hex_encode() == token[1], "Float64 bits changed")
					hash.update((encoded_key + "\n" + String(col.name_hex) + "\n" + canonical(token) + "\n").to_utf8_buffer())
					module_cells += 1
			var digest := hash.finish().hex_encode()
			check(raw_hash.finish().hex_encode() == item.cell_sha256, "Raw storage digest mismatch: " + item.name)
			check(digest == item.runtime_access.resolved_cell_sha256, "Runtime accessor digest mismatch: " + item.name)
			cells += module_cells
			results.append({"name": item.name, "rows": item.row_count, "cells": module_cells, "resolved_cell_sha256": digest})
	# Reject malformed scalar/ref encodings without silently clamping/coercing.
	for invalid in [["i", "9223372036854775808"], ["i", "-0"], ["f", "000000000000f07f"], ["s", "zz"], ["t", -1], ["t", 0.5], ["b", 1]]:
		check(not data.valid_token(invalid, false, 2), "Malformed token accepted")
	check(data.valid_token(["i", "9223372036854775807"], false, 2), "int64 max rejected")
	check(data.valid_token(["i", "-9223372036854775808"], false, 2), "int64 min rejected")
	var report := {"passed": failures.is_empty(), "errors": failures, "modules": results, "cells": cells, "godot": Engine.get_version_info().string, "android_device_tested": false}
	var output := FileAccess.open(args[1], FileAccess.WRITE)
	if output == null: push_error("Cannot write report"); quit(2); return
	output.store_string(JSON.stringify(report, "  "))
	print(JSON.stringify({"passed": report.passed, "modules": results.size(), "cells": cells, "errors": failures}))
	quit(0 if failures.is_empty() else 1)
