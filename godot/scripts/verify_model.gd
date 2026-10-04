extends SceneTree
## Independent native GLB -> Godot PackedScene verification. No game code runs.

var errors: Array[String] = []

func _initialize() -> void:
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	if not ok:
		errors.append(message)

func inspect_model(model: Node) -> Dictionary:
	var result := {"mesh_instances": 0, "triangles": 0, "bones": 0, "skinned_instances": 0}
	var pending: Array[Node] = [model]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		for child in node.get_children():
			pending.append(child)
		if node is Skeleton3D:
			result.bones += node.get_bone_count()
		if not node is MeshInstance3D:
			continue
		var instance := node as MeshInstance3D
		check(instance.mesh != null, "MeshInstance3D without a mesh: " + str(node.name))
		if instance.mesh == null:
			continue
		result.mesh_instances += 1
		var skin: Skin = instance.get_skin()
		if skin != null:
			result.skinned_instances += 1
			var skeleton: Node = instance.get_node_or_null(instance.get_skeleton_path())
			check(skeleton is Skeleton3D, "Skinned instance does not resolve its Skeleton3D")
			check(skin.get_bind_count() > 0, "Empty native Skin")
			for bind in range(skin.get_bind_count()):
				check(skin.get_bind_pose(bind).is_finite(), "Nonfinite native inverse bind")
				if skeleton is Skeleton3D:
					var bone_index: int = skin.get_bind_bone(bind)
					var bone_name: StringName = skin.get_bind_name(bind)
					check((bone_name != &"" and skeleton.find_bone(bone_name) >= 0) or
						(bone_index >= 0 and bone_index < skeleton.get_bone_count()), "Invalid native bone binding")
		for surface in range(instance.mesh.get_surface_count()):
			check(instance.mesh.surface_get_primitive_type(surface) == Mesh.PRIMITIVE_TRIANGLES, "Nontriangle surface")
			var arrays: Array = instance.mesh.surface_get_arrays(surface)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
			var index_count: int = indices.size() if not indices.is_empty() else vertices.size()
			check(index_count > 0 and index_count % 3 == 0, "Empty/nontriangular native geometry")
			result.triangles += int(index_count / 3)
			for vertex in vertices:
				check(vertex.is_finite(), "Nonfinite native vertex")
			for index in indices:
				check(index >= 0 and index < vertices.size(), "Native index outside vertex array")
			check(instance.mesh.surface_get_material(surface) != null, "Native material slot missing")
			if skin != null:
				var weights: PackedFloat32Array = arrays[Mesh.ARRAY_WEIGHTS]
				var bones: PackedInt32Array = arrays[Mesh.ARRAY_BONES]
				check(weights.size() == vertices.size() * 4 and bones.size() == weights.size(), "Native skin arrays changed shape")
				for vertex in range(vertices.size()):
					if weights.size() < (vertex + 1) * 4 or bones.size() < (vertex + 1) * 4:
						break
					var total: float = 0.0
					for slot in range(4):
						var index: int = vertex * 4 + slot
						total += weights[index]
						check(is_finite(weights[index]) and weights[index] >= 0.0, "Invalid native weight")
						check(bones[index] >= 0 and bones[index] < skin.get_bind_count(), "Native joint index outside skin")
					check(absf(total - 1.0) < 0.002, "Native weights no longer sum to one")
	return result

func compare_counts(actual: Dictionary, expected: Dictionary) -> void:
	for key in ["mesh_instances", "triangles", "skinned_instances"]:
		check(int(actual[key]) == int(expected[key]), "Count mismatch for " + key)
	check(int(actual.bones) >= int(expected.min_bones), "Native skeleton lost required bones")

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
		printerr("Usage: verify_model.gd -- model.glb expected.json report.json")
		quit(2)
		return
	var expected_value: Variant = JSON.parse_string(FileAccess.get_file_as_string(args[1]))
	if not expected_value is Dictionary:
		printerr("Missing/invalid expected-count manifest")
		quit(2)
		return
	var expected: Dictionary = expected_value
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	var status: Error = document.append_from_file(args[0], state)
	check(status == OK, "GLTFDocument.append_from_file failed: " + str(status))
	var counts: Dictionary = {}
	var roundtrip: Dictionary = {}
	var native_path: String = args[2].get_basename() + ".tscn"
	if errors.is_empty():
		var model: Node = document.generate_scene(state)
		check(model != null, "GLTFDocument.generate_scene returned null")
		if model != null:
			root.add_child(model)
			await process_frame
			counts = inspect_model(model)
			compare_counts(counts, expected)
			assign_owners(model)
			var packed := PackedScene.new()
			check(packed.pack(model) == OK, "Packing native scene failed")
			if errors.is_empty():
				check(ResourceSaver.save(packed, native_path) == OK, "Saving native scene failed")
			model.free()
			if errors.is_empty():
				var saved := ResourceLoader.load(native_path, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE) as PackedScene
				check(saved != null, "Native scene could not be reloaded")
				if saved != null:
					var restored: Node = saved.instantiate()
					root.add_child(restored)
					await process_frame
					roundtrip = inspect_model(restored)
					compare_counts(roundtrip, expected)
					check(roundtrip == counts, "Native scene roundtrip changed model counts")
					restored.free()
	var report := {"godot_version": Engine.get_version_info().string,
		"input": args[0], "input_sha256": FileAccess.get_sha256(args[0]),
		"native_scene": native_path, "counts": counts, "roundtrip_counts": roundtrip,
		"errors": errors, "passed": errors.is_empty(), "gameplay_port_complete": false}
	var output := FileAccess.open(args[2], FileAccess.WRITE)
	if output == null:
		printerr("Cannot write native-import evidence")
		quit(2)
		return
	output.store_string(JSON.stringify(report, "\t"))
	output.close()
	print(JSON.stringify(report))
	quit(0 if errors.is_empty() else 1)
