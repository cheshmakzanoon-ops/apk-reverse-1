extends Control
## Development tool displaying recovered client values, not game simulation.
const Data = preload("res://data_inspector/recovered_data.gd")
var database = Data.new()
var table_picker := OptionButton.new()
var search := LineEdit.new()
var rows := ItemList.new()
var details := RichTextLabel.new()
var status := Label.new()
var page_label := Label.new()
var keys: Array = []
var filtered: Array = []
var page := 0
const PAGE_SIZE := 100

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	add_child(margin)
	var column := VBoxContainer.new(); column.add_theme_constant_override("separation", 12); margin.add_child(column)
	var title := Label.new(); title.text = "RECOVERED CLIENT DATA"; title.add_theme_font_size_override("font_size", 26); column.add_child(title)
	var warning := Label.new(); warning.text = "Development inspector - not a playable game.\nValues are from committed decompilation; APK equivalence is unverified."
	warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; column.add_child(warning)
	column.add_child(table_picker)
	search.placeholder_text = "Filter record IDs or original name values"; column.add_child(search)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; column.add_child(status)
	rows.size_flags_vertical = Control.SIZE_EXPAND_FILL; rows.custom_minimum_size.y = 180; column.add_child(rows)
	var navigation := HBoxContainer.new(); column.add_child(navigation)
	var previous := Button.new(); previous.text = "Previous 100"; previous.pressed.connect(func(): change_page(-1)); navigation.add_child(previous)
	page_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL; page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; navigation.add_child(page_label)
	var next := Button.new(); next.text = "Next 100"; next.pressed.connect(func(): change_page(1)); navigation.add_child(next)
	details.size_flags_vertical = Control.SIZE_EXPAND_FILL; details.custom_minimum_size.y = 200
	details.selection_enabled = true; details.bbcode_enabled = false; column.add_child(details)
	table_picker.item_selected.connect(select_module); rows.item_selected.connect(select_record); search.text_changed.connect(filter_records)
	if not database.open_package("res://recovered_data"):
		status.text = database.error + "\nRun tools/godot_data.py build first."; table_picker.disabled = true; return
	for item in database.catalog.modules: table_picker.add_item(item.name)
	select_module(0)

func select_module(index: int) -> void:
	if not database.open_module(table_picker.get_item_text(index)):
		status.text = database.error; rows.clear(); details.text = ""; return
	keys = database.record_keys()
	status.text = "%d recovered records | %d columns | source %s" % [keys.size(), database.module.columns.size(), database.catalog.source_commit.left(12)]
	filter_records(search.text)

func filter_records(query: String) -> void:
	filtered = []; page = 0
	var text := query.to_lower()
	for record_key in keys:
		var name: String = database.describe(database.record_token(record_key, "name"))
		if text.is_empty() or str(record_key).to_lower().contains(text) or name.to_lower().contains(text): filtered.append(record_key)
	show_page()

func change_page(delta: int) -> void:
	page = clampi(page + delta, 0, maxi(0, int(ceil(filtered.size() / float(PAGE_SIZE))) - 1)); show_page()

func show_page() -> void:
	rows.clear(); details.text = "Select a record to inspect its original fields."
	for i in range(page * PAGE_SIZE, mini((page + 1) * PAGE_SIZE, filtered.size())):
		var name: String = database.describe(database.record_token(filtered[i], "name"))
		rows.add_item(str(filtered[i]) + (" | " + name.left(80) if name != "nil (absent)" else ""))
	page_label.text = "%d matches | page %d" % [filtered.size(), page + 1]
	if rows.item_count > 0: rows.select(0); select_record(0)

func select_record(index: int) -> void:
	var key: Variant = filtered[page * PAGE_SIZE + index]
	var text := "Record " + str(key) + "\n\n"
	for col in database.module.columns:
		var field: String = String(col.name_hex).hex_decode().get_string_from_utf8()
		text += field + "\n" + database.describe(database.record_token(key, field)) + "\n\n"
	details.text = text
