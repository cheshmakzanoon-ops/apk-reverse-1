extends RefCounted
## Numeric subset of the recovered HeroRankTemplate, not a complete hero/combat system.
## Copy input values so changing the inspector's open module cannot change a rule instance.
var error := ""
var effects: Dictionary = {}
var stars: Array = [0, 0]
var ratio: Variant = 0

func valid_number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))

func configure(data, record_key: Variant) -> bool:
	error = ""; effects = {}; stars = [0, 0]; ratio = 0
	if not data.record_keys().has(record_key):
		error = "Unknown rank record"; return false
	var attrs: Variant = data.record_token(record_key, "attr_add")
	var star_data: Variant = data.record_token(record_key, "star_show")
	var ratio_value: Variant = data.record_value(record_key, "attr_ratio")
	if ratio_value != null:
		if not valid_number(ratio_value): error = "Non-numeric rank ratio"; return false
		ratio = ratio_value
	if attrs != null:
		var ref: int = data.table_ref(attrs)
		if ref < 0: error = "Rank effects require a resolved table"; return false
		for encoded_key in data.tables[ref]:
			var effect: Variant = data.scalar_value(JSON.parse_string(encoded_key))
			var token: Variant = data.tables[ref][encoded_key]
			if not data.lua_truth(token): continue
			var value: Variant = data.scalar_value(token)
			if not effect is int or not valid_number(value): error = "Unsupported rank effect"; return false
			if value is float and abs(value) >= 9007199254740992.0: error = "Effect formatting outside supported exact range"; return false
			effects[effect] = value
	if star_data != null:
		var ref: int = data.table_ref(star_data)
		if ref < 0: error = "Rank stars require a resolved table"; return false
		for i in range(2):
			var token: Variant = data.lookup_token(ref, i + 1)
			if data.lua_truth(token):
				var value: Variant = data.scalar_value(token)
				if not valid_number(value): error = "Non-numeric star count"; return false
				stars[i] = value
	return true

func get_star_count() -> Array:
	return stars.duplicate()

func get_effect_add(effect_id: int, formatted: bool = false) -> Variant:
	var add: Variant = effects.get(effect_id, 0)
	if not formatted: return add
	return str(add) if add is int else str(int(floor(add)))

func get_add_effect(effect_id: int) -> Variant:
	return effects.get(effect_id, 0)

func get_effect_ratio() -> Variant:
	return ratio
