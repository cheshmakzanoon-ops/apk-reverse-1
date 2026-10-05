extends SceneTree
## Explicit test entry point. The normal viewer never reads commands or writes probes.
var viewer: Node
var ticks := 0
var last_write := 0
var nonce := ""

func _initialize() -> void:
	call_deferred("start")

func start() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_valid_identifier():
		quit(2)
		return
	nonce = args[0]
	var scene := load("res://asset_viewer/main.tscn") as PackedScene
	viewer = scene.instantiate()
	root.add_child(viewer)
	await process_frame
	if viewer.player == null or viewer.names.size() != 8:
		printerr("Runtime probe requires the eight-clip recovered asset")
		quit(2)
		return
	# Start the longest real clip, paused mid-cycle, for deterministic touch checks.
	var longest := 0
	for i in range(viewer.names.size()):
		if viewer.player.get_animation(viewer.names[i]).length > viewer.player.get_animation(viewer.names[longest]).length:
			longest = i
	viewer.choices.select(longest)
	viewer._play(longest)
	viewer.player.speed_scale = 0.125
	viewer.player.pause()
	viewer.timeline.value = viewer.player.current_animation_length * 0.4
	process_frame.connect(snapshot)

func center(control: Control) -> Array:
	var pos: Vector2 = root.get_final_transform() * control.get_global_transform_with_canvas() * (control.size * 0.5)
	return [pos.x, pos.y]

func snapshot() -> void:
	ticks += 1
	if Time.get_ticks_msec() - last_write < 150:
		return
	last_write = Time.get_ticks_msec()
	var timeline := viewer.timeline as HSlider
	var a: Vector2 = root.get_final_transform() * timeline.get_global_transform_with_canvas() * Vector2(timeline.size.x * 0.65, timeline.size.y * 0.5)
	var area := root.get_visible_rect().size
	var state := {"nonce": nonce, "runtime_os": OS.get_name(), "ticks": ticks,
		"pid": OS.get_process_id(), "clips": viewer.names.size(),
		"playing": viewer.player.is_playing(), "clip": str(viewer.player.assigned_animation),
		"position": viewer.player.current_animation_position, "length": viewer.player.current_animation_length,
		"yaw": viewer.yaw, "pitch": viewer.pitch, "radius": viewer.radius,
		"lifecycle": viewer.lifecycle, "paused_button": center(viewer.pause_button),
		"restart_button": center(viewer.restart_button), "zoom_in": center(viewer.zoom_in_button),
		"zoom_out": center(viewer.zoom_out_button), "scrub": [a.x, a.y],
		"viewport": [area.x, area.y], "surface_size": [root.size.x, root.size.y],
		"speed_scale": viewer.player.speed_scale, "coordinate_space": "android_surface_pixels",
		"user_dir": OS.get_user_data_dir()}
	var file := FileAccess.open("user://runtime-state.tmp", FileAccess.WRITE)
	if file == null:
		quit(2)
		return
	file.store_string(JSON.stringify(state)); file.close()
	DirAccess.rename_absolute("user://runtime-state.tmp", "user://runtime-state.json")
