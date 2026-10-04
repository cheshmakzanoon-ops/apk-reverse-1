extends SceneTree
## Render and exercise the desktop inspection controls; not Android touch testing.
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2 or not args[1].is_valid_int():
		push_error("Usage: -- OUT_DIRECTORY EXPECTED_CLIP_COUNT")
		quit(2)
		return
	var out := args[0]
	if DirAccess.dir_exists_absolute(out):
		push_error("Output directory exists")
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(out)
	var packed := load("res://asset_viewer/main.tscn") as PackedScene
	var viewer: Node = packed.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	var player := viewer.get("player") as AnimationPlayer
	var names: Array = viewer.get("names")
	check(player != null, "No animation player in viewer")
	check(names.size() == int(args[1]), "Unexpected imported clip count")
	var records: Array = []
	if player != null:
		var controls: Array[Node] = [viewer]
		var pause_button: Button
		var restart_button: Button
		while not controls.is_empty():
			var node: Node = controls.pop_back()
			if node is Button:
				if node.text == "Play / pause": pause_button = node
				if node.text == "Restart clip": restart_button = node
			for child in node.get_children(): controls.append(child)
		check(pause_button != null and restart_button != null, "Playback controls are absent")
		for i in range(names.size()):
			var choices := viewer.get("choices") as OptionButton
			choices.select(i)
			choices.item_selected.emit(i)
			check(player.current_animation == names[i], "Selection did not select the requested clip")
			check(player.is_playing(), "Selected clip did not start")
			if pause_button != null: pause_button.pressed.emit()
			check(not player.is_playing(), "Pause button did not pause")
			var length: float = player.get_animation(names[i]).length
			var timeline := viewer.get("timeline") as HSlider
			timeline.value = length * 0.5
			check(absf(player.current_animation_position - timeline.value) < 0.002, "Scrubber did not update pose")
			await process_frame
			await RenderingServer.frame_post_draw
			var image := root.get_texture().get_image()
			check(image != null and image.get_width() > 0 and image.get_height() > 0, "Viewport readback failed")
			var path := out.path_join("clip-%02d.png" % i)
			if image != null: check(image.save_png(path) == OK, "Screenshot save failed")
			records.append({"name": str(names[i]), "label": choices.get_item_text(i),
				"time": player.current_animation_position, "length": length, "screenshot": path})
			if restart_button != null: restart_button.pressed.emit()
			check(player.is_playing() and absf(player.current_animation_position) < 0.002, "Restart button failed")
			player.pause()
	var report := {"passed": failures.is_empty(), "errors": failures,
		"clips": records, "desktop_control_checks": true, "android_device_tested": false,
		"gameplay_port_complete": false, "godot_version": Engine.get_version_info().string}
	var file := FileAccess.open(out.path_join("viewer.json"), FileAccess.WRITE)
	if file != null: file.store_string(JSON.stringify(report, "\t"))
	else: failures.append("Cannot write viewer report")
	print(JSON.stringify({"passed": failures.is_empty(), "clips": records.size(), "errors": failures}))
	viewer.queue_free()
	await process_frame
	quit(0 if failures.is_empty() else 1)
