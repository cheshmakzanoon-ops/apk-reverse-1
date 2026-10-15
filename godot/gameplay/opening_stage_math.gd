extends RefCounted
## Double-precision yaw helpers shared by the stage-six encounter classes.
## Source space is Unity's left-handed frame: yaw 0 faces +Z and positive yaw turns toward +X.

static func forward_of(yaw_deg: float) -> Array:
	var r := deg_to_rad(yaw_deg)
	return [sin(r), 0.0, cos(r)]

static func rotate_yaw(v: Array, yaw_deg: float) -> Array:
	var r := deg_to_rad(yaw_deg)
	var c := cos(r)
	var s := sin(r)
	return [v[0] * c + v[2] * s, v[1], -v[0] * s + v[2] * c]
