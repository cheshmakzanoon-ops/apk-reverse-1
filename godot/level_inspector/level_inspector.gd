extends Control
## Development inspection of source-derived rules; no account or upgrade writes.
const Rules = preload("res://gameplay/hero_level_rules.gd")
const Data = preload("res://data_inspector/recovered_data.gd")
var data = Data.new()
var rules = Rules.new()
var replies: Dictionary = {}
var result := RichTextLabel.new()
var details := RichTextLabel.new()
var picker := OptionButton.new()
var rows: Array = []

func _ready() -> void:
	var scroll := ScrollContainer.new(); scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(scroll)
	var margin := MarginContainer.new();margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL;scroll.add_child(margin)
	for side in ["left","right","top","bottom"]:margin.add_theme_constant_override("margin_"+side,16)
	var column := VBoxContainer.new();column.add_theme_constant_override("separation",12);margin.add_child(column)
	var back := Button.new();back.text = "Back to recovered data";back.pressed.connect(func():get_tree().change_scene_to_file("res://data_inspector/main.tscn"));column.add_child(back)
	var title := Label.new();title.text = "HERO LEVEL RULES";title.add_theme_font_size_override("font_size",26);column.add_child(title)
	var warning := Label.new();warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	warning.text = "Source-derived development simulator, not gameplay. Research replies below are injected inputs, not your account state. No upgrade, spending, save change, or server request is performed."
	column.add_child(warning)
	if not data.open_package("res://recovered_data") or not data.open_module("lw_hero_level") or not rules.configure_from_data(data):
		warning.text = "Level inspector blocked: " + data.error + " " + rules.error;return
	rows = rules.records()
	for condition in rules.conditions():
		replies[condition] = "no_record"
		var label := Label.new();label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.text = "Condition bytes (hex): " + condition;column.add_child(label)
		var choice := OptionButton.new()
		for text in ["Template found; research object absent", "Template found; research object present", "Research template missing", "Science data manager absent"]:choice.add_item(text)
		choice.item_selected.connect(func(index):replies[condition] = Rules.REPLIES[index];evaluate_rules())
		column.add_child(choice)
	var reset := Button.new();reset.text = "Reset source manager cache";reset.pressed.connect(func():rules.reset_cache();evaluate_rules());column.add_child(reset)
	result.custom_minimum_size.y = 230;result.fit_content = true;result.selection_enabled = true;column.add_child(result)
	var record_title := Label.new();record_title.text = "Original level template values";column.add_child(record_title)
	for row in rows:picker.add_item("Record %d | authored level %d" % [row.key,row.level])
	picker.item_selected.connect(show_record);column.add_child(picker)
	details.custom_minimum_size.y = 230;details.fit_content = true;details.selection_enabled = true;column.add_child(details)
	evaluate_rules()
	if not rows.is_empty():show_record(0)

func evaluate_rules() -> void:
	var live: Dictionary = rules.evaluate(replies)
	var fresh = Rules.new();fresh.configure(rows)
	var cold: Dictionary = fresh.evaluate(replies)
	if live.is_empty() or cold.is_empty():result.text = "Blocked: " + rules.error + " " + fresh.error;return
	result.text = "Source table upper bound: %d\nCached manager reachable level: %d\nFresh manager with the same replies: %d\nCache scanned through: %d\n" % [live.unconditional_max_level,live.reachable_level,cold.reachable_level,live.scanned_through]
	if live.reachable_level != cold.reachable_level:result.text += "The recovered source keeps its advancing cache after replies change. Reset to evaluate from the beginning.\n"
	if not live.missing_template_levels.is_empty() or not cold.missing_template_levels.is_empty():
		result.text += "Warning: missing research templates are skipped by this recovered method; this is NOT proof the research is unlocked.\n"
	if not cold.blocker.is_empty():result.text += "Fresh scan stops at record %d: %s\n" % [cold.blocker.level,cold.blocker.response]
	result.text += "These numbers reproduce selected recovered methods, not verified server authorization."

func show_record(index: int) -> void:
	if index < 0 or index >= rows.size():return
	var row: Dictionary = rows[index]
	details.text = "Record %d\n" % row.key
	for field in ["id","level","next_exp","coins"]:details.text += field + ": " + str(row[field]) + "\n"
	for field in ["city_exp_get","tech_condition","resource","unlock_function"]:
		details.text += field + ": " + data.describe(data.record_token(row.key,field)) + "\n"
	details.text += "Values are displayed without inventing upgrade costs or transactions."
