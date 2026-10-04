extends Node3D
## Development asset viewer. No original game code, server access or controller logic.
const MODEL_PATH := "res://recovered_models/farhad/model.glb"
const META_PATH := "res://recovered_models/farhad/report.json"
var player: AnimationPlayer
var camera: Camera3D
var status: Label
var timeline: HSlider
var choices: OptionButton
var names: Array[StringName] = []
var focus := Vector3.ZERO
var radius := 5.0
var yaw := 0.65
var pitch := 0.3
var updating_slider := false
var pause_button: Button
var restart_button: Button
var zoom_in_button: Button
var zoom_out_button: Button
var lifecycle := {"paused": 0, "resumed": 0, "suspend_time": 0.0, "resume_time": 0.0, "was_playing": false}
var _suspended := false

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED and not _suspended and player != null:
		_suspended = true
		lifecycle.paused += 1
		lifecycle.was_playing = player.is_playing()
		lifecycle.suspend_time = player.current_animation_position
		player.pause()
	elif what == NOTIFICATION_APPLICATION_RESUMED and _suspended and player != null:
		_suspended = false
		lifecycle.resumed += 1
		if lifecycle.was_playing:
			player.play()
		player.seek(float(lifecycle.suspend_time), true)
		lifecycle.resume_time = player.current_animation_position

func _ready() -> void:
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.12, 0.13, 0.15)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.75, 0.8, 0.85)
	environment.ambient_light_energy = 0.8
	var world := WorldEnvironment.new()
	world.environment = environment
	add_child(world)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, -35, 0)
	light.light_energy = 1.5
	add_child(light)
	camera = Camera3D.new()
	camera.current = true
	camera.fov = 45.0
	add_child(camera)
	_make_controls()
	if not ResourceLoader.exists(MODEL_PATH):
		status.text = "Model absent. Run tools/real_model_sample.py and copy export/ to recovered_models/farhad/."
		return
	var packed := load(MODEL_PATH) as PackedScene
	if packed == null:
		status.text = "The recovered GLB could not be imported."
		return
	var model: Node = packed.instantiate()
	add_child(model)
	var pending: Array[Node] = [model]
	var bounds := AABB()
	var have_bounds := false
	var players: Array[AnimationPlayer] = []
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		if node is AnimationPlayer:
			players.append(node as AnimationPlayer)
		if node is MeshInstance3D:
			var mesh := node as MeshInstance3D
			var box: AABB = mesh.global_transform * mesh.get_aabb()
			bounds = bounds.merge(box) if have_bounds else box
			have_bounds = true
		for child in node.get_children():
			pending.append(child)
	if have_bounds:
		focus = bounds.get_center()
		radius = maxf(bounds.size.length() * 1.9, 1.0)
	_update_camera()
	if players.size() != 1:
		status.text = "Expected one imported animation player; found %d." % players.size()
		return
	player = players[0]
	var metadata: Variant = JSON.parse_string(FileAccess.get_file_as_string(META_PATH))
	var labels: Dictionary = {}
	if metadata is Dictionary:
		for entry in metadata.get("animation_clips", []):
			labels[entry.name] = entry.original_name
	for animation_name in player.get_animation_list():
		if animation_name == &"RESET":
			continue
		names.append(animation_name)
		choices.add_item(str(labels.get(str(animation_name), str(animation_name))))
	if names.is_empty():
		status.text = "No recovered animation clips were imported."
		return
	status.text = "Recovered Farhad asset • base-color material preview • not the game"
	_play(0)

func _make_controls() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := VBoxContainer.new()
	panel.position = Vector2(18, 18)
	panel.custom_minimum_size = Vector2(475, 0)
	layer.add_child(panel)
	status = Label.new()
	status.text = "Loading recovered asset…"
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(status)
	choices = OptionButton.new()
	choices.custom_minimum_size.y = 48
	choices.item_selected.connect(_play)
	panel.add_child(choices)
	var row := HBoxContainer.new()
	panel.add_child(row)
	var pause := Button.new()
	pause_button = pause
	pause.text = "Play / pause"
	pause.custom_minimum_size = Vector2(170, 48)
	pause.pressed.connect(func() -> void:
		if player != null:
			if player.is_playing(): player.pause()
			else: player.play())
	row.add_child(pause)
	var restart := Button.new()
	restart_button = restart
	restart.text = "Restart clip"
	restart.custom_minimum_size = Vector2(170, 48)
	restart.pressed.connect(func() -> void: _play(choices.selected))
	row.add_child(restart)
	timeline = HSlider.new()
	timeline.custom_minimum_size.y = 48
	timeline.step = 0.001
	timeline.value_changed.connect(func(value: float) -> void:
		if player != null and not updating_slider:
			player.pause()
			player.seek(value, true))
	panel.add_child(timeline)
	var zoom_row := HBoxContainer.new()
	panel.add_child(zoom_row)
	zoom_in_button = Button.new()
	zoom_in_button.text = "Zoom in"
	zoom_in_button.custom_minimum_size = Vector2(170, 48)
	zoom_in_button.pressed.connect(func() -> void: _zoom(1.0 / 1.2))
	zoom_row.add_child(zoom_in_button)
	zoom_out_button = Button.new()
	zoom_out_button.text = "Zoom out"
	zoom_out_button.custom_minimum_size = Vector2(170, 48)
	zoom_out_button.pressed.connect(func() -> void: _zoom(1.2))
	zoom_row.add_child(zoom_out_button)
	var help := Label.new()
	help.text = "Drag below the controls to orbit; use Zoom buttons or the mouse wheel. Clips play one cycle."
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(help)

func _play(index: int) -> void:
	if player == null or index < 0 or index >= names.size(): return
	var animation: Animation = player.get_animation(names[index])
	animation.loop_mode = Animation.LOOP_NONE
	# Reset under the guard: changing the range can emit value_changed, and
	# an unchanged slider value must not leave a restarted clip at the old pose.
	updating_slider = true
	timeline.max_value = animation.length
	timeline.value = 0.0
	updating_slider = false
	player.play(names[index])
	player.seek(0.0, true)

func _process(_delta: float) -> void:
	if player != null and player.is_playing():
		updating_slider = true
		timeline.value = player.current_animation_position
		updating_slider = false

func _update_camera() -> void:
	camera.position = focus + Vector3(sin(yaw)*cos(pitch), sin(pitch), cos(yaw)*cos(pitch))*radius
	camera.look_at(focus)

func _zoom(factor: float) -> void:
	radius = clampf(radius * factor, 0.2, 10000.0)
	_update_camera()

func _unhandled_input(event: InputEvent) -> void:
	# Android emits emulated mouse events as well as touch drags. Do not orbit twice.
	if OS.has_feature("android") and event is InputEventMouse and event.device == -1:
		return
	var movement := Vector2.ZERO
	if event is InputEventScreenDrag:
		movement = event.relative
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		movement = event.relative
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: _zoom(1.0 / 1.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: _zoom(1.1)
	yaw -= movement.x * 0.008
	pitch = clampf(pitch + movement.y * 0.008, -1.4, 1.4)
	_update_camera()
