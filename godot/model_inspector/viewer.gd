extends Node3D
# An inspection tool for one captured asset, not the reconstructed game.
const MODEL := "res://recovered_models/farhad/model.tscn"
var player: AnimationPlayer
var camera: Camera3D
var pivot: Node3D
var choices: OptionButton
var scrub: HSlider
var status: Label
var playing := true
var distance := 4.0
var center := Vector3.ZERO
var yaw := 0.6
var pitch := -0.2
var titles: Dictionary = {}
var clip_names: Array[String] = []

func _ready() -> void:
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 16)
	canvas.add_child(margin)
	var column := VBoxContainer.new()
	margin.add_child(column)
	var title := Label.new()
	title.text = "Farhad · recovered model"
	title.add_theme_font_size_override("font_size", 25)
	column.add_child(title)
	var note := Label.new()
	note.text = "Real APK asset · two recovered clips\nMaterial preview, not original shader. This is not the game."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(note)
	var row := HBoxContainer.new()
	column.add_child(row)
	choices = OptionButton.new()
	choices.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(choices)
	choices.item_selected.connect(select_clip)
	var pause := Button.new()
	pause.text = "Pause / play"
	row.add_child(pause)
	pause.pressed.connect(func(): playing = not playing)
	var reset := Button.new()
	reset.text = "Reset view"
	row.add_child(reset)
	reset.pressed.connect(func(): yaw = 0.6; pitch = -0.2; update_camera())
	scrub = HSlider.new()
	scrub.step = 0.001
	column.add_child(scrub)
	scrub.value_changed.connect(func(value: float):
		if player != null and not player.current_animation.is_empty():
			player.seek(value, true))
	status = Label.new()
	status.text = "Drag to orbit · mouse wheel / +/- to zoom"
	column.add_child(status)
	var zoom := HBoxContainer.new()
	column.add_child(zoom)
	for factor: float in [0.8, 1.25]:
		var button := Button.new()
		button.text = "+" if factor < 1.0 else "−"
		button.custom_minimum_size = Vector2(64, 40)
		button.pressed.connect(func(): distance = clampf(distance * factor, 0.01, 10000); update_camera())
		zoom.add_child(button)
	if not ResourceLoader.exists(MODEL):
		status.text = "Missing verified asset package. Run the real-model workflow first."
		return
	var packed := load(MODEL) as PackedScene
	if packed == null:
		push_error("Cannot load verified model scene")
		return
	var asset: Node3D = packed.instantiate()
	add_child(asset)
	player = find_player(asset)
	if player == null:
		push_error("Recovered asset has no AnimationPlayer")
		return
	player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	var names_path := "res://recovered_models/farhad/display-clips.json"
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(names_path))
	if parsed is Dictionary: titles = parsed
	for name: StringName in player.get_animation_list():
		if titles.has(String(name)):
			clip_names.append(String(name))
			choices.add_item(titles[String(name)])
	if clip_names.size() != 2:
		push_error("Expected the two verified source clips")
		return
	var meshes: Array[MeshInstance3D] = []
	find_meshes(asset, meshes)
	if meshes.size() != 7:
		push_error("Expected seven captured skinned meshes")
		return
	var bounds: AABB = meshes[0].global_transform * meshes[0].get_aabb()
	for mesh: MeshInstance3D in meshes:
		bounds = bounds.merge(mesh.global_transform * mesh.get_aabb())
	center = bounds.get_center()
	distance = maxf(bounds.size.length() * 1.2, 0.1)
	pivot = Node3D.new()
	pivot.position = center
	add_child(pivot)
	camera = Camera3D.new()
	camera.near = maxf(distance / 1000.0, 0.0001)
	camera.far = maxf(distance * 100.0, 100.0)
	camera.fov = 45
	pivot.add_child(camera)
	camera.current = true
	update_camera()
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.055, 0.075, 0.11)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color.WHITE
	env.environment.ambient_light_energy = 0.8
	add_child(env)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-40, -30, 0)
	light.light_energy = 1.1
	add_child(light)
	select_clip(0)
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--capture="):
			capture_view(arg.trim_prefix("--capture="))

func find_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer: return node as AnimationPlayer
	for child: Node in node.get_children():
		var found := find_player(child)
		if found != null: return found
	return null

func find_meshes(node: Node, result: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D: result.append(node as MeshInstance3D)
	for child: Node in node.get_children(): find_meshes(child, result)

func select_clip(index: int) -> void:
	if player == null or index < 0 or index >= clip_names.size(): return
	player.play(clip_names[index])
	player.seek(0.0, true)
	scrub.max_value = player.get_animation(clip_names[index]).length
	status.text = titles[clip_names[index]] + " · inspection loop; original controller not ported"

func _process(delta: float) -> void:
	if player == null or player.current_animation.is_empty(): return
	if playing:
		player.seek(fmod(player.current_animation_position + delta, scrub.max_value), true)
	scrub.set_value_no_signal(player.current_animation_position)

func update_camera() -> void:
	if camera == null: return
	pivot.rotation = Vector3(pitch, yaw, 0)
	camera.position = Vector3(0, 0, distance)

func _unhandled_input(event: InputEvent) -> void:
	var motion := Vector2.ZERO
	if event is InputEventScreenDrag: motion = event.relative
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT: motion = event.relative
	if motion != Vector2.ZERO:
		yaw -= motion.x * 0.008
		pitch = clampf(pitch - motion.y * 0.008, -1.4, 1.4)
		update_camera()
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: distance *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN: distance *= 1.1
		update_camera()

func capture_view(path: String) -> void:
	playing = false
	select_clip(1)
	player.seek(0.4, true)
	for i in range(30): await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var error := image.save_png(path)
	print(JSON.stringify({"viewer_rendered": error == OK, "clip": titles[clip_names[1]],
		"gameplay_port_complete": false, "android_device_tested": false}))
	get_tree().quit(0 if error == OK else 1)
