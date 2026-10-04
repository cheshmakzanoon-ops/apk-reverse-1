extends SceneTree
## Generated-fixture playback verification, never game scripts or event execution.

var errors: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func check(value: bool, message: String) -> void:
	if not value:
		errors.append(message)

func player_for(model: Node) -> AnimationPlayer:
	var found: Array[AnimationPlayer] = []
	var pending: Array[Node] = [model]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		if node is AnimationPlayer:
			found.append(node as AnimationPlayer)
		for child in node.get_children():
			pending.append(child)
	check(found.size() == 1, "Expected exactly one imported AnimationPlayer")
	return found[0] if found.size() == 1 else null

func target_map(model: Node, state: GLTFState, expected: Dictionary) -> Dictionary:
	var mapped: Dictionary = {}
	for clip in expected.clips:
		for channel in clip.channels:
			var idx: int = int(channel.node_index)
			if mapped.has(str(idx)):
				continue
			if idx < 0 or idx >= state.get_nodes().size():
				check(false, "Expected glTF node index out of range")
				continue
			var source: GLTFNode = state.get_nodes()[idx]
			# ImporterMesh conversion replaces nodes after GLTFState recorded them.
			# Resolve the exact generated path instead of retaining a freed pointer.
			var path: NodePath = source.get_scene_node_path(state, true)
			var target: Node = model.get_node_or_null(NodePath(path.get_concatenated_names()))
			if source.skeleton >= 0:
				var skeleton := target as Skeleton3D
				check(skeleton != null and path.get_subname_count() == 1, "Skeleton target mapping unavailable")
				if skeleton == null or path.get_subname_count() != 1:
					continue
				var bone: String = str(path.get_subname(0))
				check(skeleton.find_bone(bone) >= 0, "Mapped bone is absent")
				mapped[str(idx)] = {"path": str(model.get_path_to(skeleton)), "bone": bone}
			else:
				var node: Node = target
				check(node is Node3D, "Mapped glTF target is not a Node3D")
				if node is Node3D:
					mapped[str(idx)] = {"path": str(model.get_path_to(node)), "bone": ""}
	return mapped

func value_at(model: Node, mapping: Dictionary, property: String) -> Variant:
	var target: Node = model.get_node_or_null(NodePath(mapping.path))
	check(target != null, "Animation target lost during scene roundtrip")
	if target == null:
		return null
	if not str(mapping.bone).is_empty():
		var skeleton := target as Skeleton3D
		check(skeleton != null, "Bone owner lost Skeleton3D type")
		if skeleton == null:
			return null
		var bone: int = skeleton.find_bone(mapping.bone)
		check(bone >= 0, "Bone name missing after scene roundtrip")
		if bone < 0:
			return null
		if property == "translation":
			return skeleton.get_bone_pose_position(bone)
		if property == "rotation":
			return skeleton.get_bone_pose_rotation(bone)
		return skeleton.get_bone_pose_scale(bone)
	var node := target as Node3D
	check(node != null, "Animation target lost Node3D type")
	if node == null:
		return null
	if property == "translation":
		return node.position
	if property == "rotation":
		return node.quaternion
	return node.scale

func inspect_playback(model: Node, expected: Dictionary, mapped: Dictionary) -> Array:
	var records: Array = []
	var player: AnimationPlayer = player_for(model)
	if player == null:
		return records
	player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	for clip in expected.clips:
		var name: StringName = StringName(clip.name)
		check(player.has_animation(name), "Missing imported animation " + str(name))
		if not player.has_animation(name):
			continue
		var anim: Animation = player.get_animation(name)
		check(anim.get_track_count() >= clip.channels.size(), "Animation tracks were dropped")
		# Prevent source loop metadata or the importer from affecting single-cycle sampling.
		anim.loop_mode = Animation.LOOP_NONE
		player.play(name)
		player.advance(0.0)
		for channel in clip.channels:
			var key: String = str(int(channel.node_index))
			check(mapped.has(key), "Missing expected target identity")
			if not mapped.has(key):
				continue
			for sample in channel.samples:
				player.seek(float(sample.time), true, true)
				var actual: Variant = value_at(model, mapped[key], str(channel.path))
				if actual == null:
					continue
				var wanted: Array = sample.value
				var delta: float = 0.0
				var tolerance: float = float(expected.vector_tolerance)
				var values: Array = []
				if str(channel.path) == "rotation":
					var q: Quaternion = actual
					var q_expected := Quaternion(wanted[0], wanted[1], wanted[2], wanted[3]).normalized()
					delta = 2.0 * acos(clampf(absf(q.normalized().dot(q_expected)), 0.0, 1.0))
					tolerance = float(expected.angle_tolerance)
					values = [q.x, q.y, q.z, q.w]
				else:
					var v: Vector3 = actual
					var v_expected := Vector3(wanted[0], wanted[1], wanted[2])
					var residual: Vector3 = (v - v_expected).abs()
					delta = maxf(residual.x, maxf(residual.y, residual.z))
					values = [v.x, v.y, v.z]
				check(is_finite(delta) and delta <= tolerance,
					"Playback mismatch: " + str(channel.path) + " at " + str(sample.time) + ", error=" + str(delta))
				records.append({"animation": str(name), "node_index": int(channel.node_index),
					"property": channel.path, "time": sample.time, "actual": values,
					"expected": wanted, "error": delta, "tolerance": tolerance})
		player.stop()
	return records

func assign_owners(model: Node) -> void:
	var pending: Array[Node] = [model]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		for child in node.get_children():
			child.owner = model
			pending.append(child)

func _run() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if args.size() != 3:
		printerr("Usage: verify_animation.gd -- model.glb expected.json report.json")
		quit(2)
		return
	var value: Variant = JSON.parse_string(FileAccess.get_file_as_string(args[1]))
	if not value is Dictionary:
		printerr("Missing expected animation manifest")
		quit(2)
		return
	var expected: Dictionary = value
	check(expected.input_sha256 == FileAccess.get_sha256(args[0]), "Expectation/model hash mismatch")
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	check(document.append_from_file(args[0], state) == OK, "Native GLB parse failed")
	var records: Array = []
	var reloaded: Array = []
	var mapping: Dictionary = {}
	var native_path: String = args[2].get_basename() + ".tscn"
	if errors.is_empty():
		var model: Node = document.generate_scene(state, float(expected.bake_fps), false, false)
		check(model != null, "Animation scene generation failed")
		if model != null:
			root.add_child(model)
			await process_frame
			mapping = target_map(model, state, expected)
			records = inspect_playback(model, expected, mapping)
			assign_owners(model)
			var packed := PackedScene.new()
			check(packed.pack(model) == OK, "Animation scene packing failed")
			if errors.is_empty():
				check(ResourceSaver.save(packed, native_path) == OK, "Animation scene save failed")
			model.free()
			if errors.is_empty():
				var saved := ResourceLoader.load(native_path, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE) as PackedScene
				check(saved != null, "Animation scene reload failed")
				if saved != null:
					var restored: Node = saved.instantiate()
					root.add_child(restored)
					await process_frame
					reloaded = inspect_playback(restored, expected, mapping)
					check(reloaded.size() == records.size(), "Reloaded playback sample count changed")
					restored.free()
	check(not records.is_empty() and not reloaded.is_empty(), "Playback verification produced no samples")
	var report := {"godot_version": Engine.get_version_info().string,
		"input_sha256": FileAccess.get_sha256(args[0]), "native_scene": native_path,
		"source_spline_sha256": expected.get("source_spline_sha256", ""),
		"target_mapping": mapping, "samples": records, "reloaded_samples": reloaded,
		"errors": errors, "passed": errors.is_empty(), "fixture_only": true,
		"gameplay_port_complete": false, "android_device_tested": false}
	var output := FileAccess.open(args[2], FileAccess.WRITE)
	if output == null:
		printerr("Cannot write playback evidence")
		quit(2)
		return
	output.store_string(JSON.stringify(report, "\t"))
	output.close()
	print(JSON.stringify({"passed": errors.is_empty(), "samples": records.size(), "errors": errors}))
	quit(0 if errors.is_empty() else 1)
