extends RefCounted
## Stage-six opening encounter: a stationary SoloHero turret shoots a stream of ZakuB/ZakuC
## zombies that are respawned where they stood when killed.
##
## Ported from the recovered LWOpeningStageDirtyWorks.ShowInTroubledFellow, the SoloHero and
## ZakuZombie classes with their state scripts, the event dealer's respawn handler and the
## SoloHeroTurret C# component. tools/opening_stage_oracle.py runs those recovered Lua sources
## and tests/test_opening_stage.py compares this port against them.
##
## Everything lives in "source space": Unity's left-handed axes with yaw measured so that
## forward = (sin yaw, 0, cos yaw). Plain 64-bit floats are used rather than Vector3, which is
## 32-bit in standard Godot builds. Converting to a Godot node transform is a presentation
## concern (see level_inspector/stage_six_view.gd).
##
## Not recovered, so supplied by the caller or assumed (see docs/STAGE_SIX_ENCOUNTER.md):
## turret/muzzle placement (from the SoloHero prefab), asset load latency, and the relative
## order of the engine's timer, Lua update and MonoBehaviour update within a frame.

const Fsm = preload("res://gameplay/opening_stage_fsm.gd")
const Maths = preload("res://gameplay/opening_stage_math.gd")

const HERO_SCALE := 1.2
const SPAWN_JITTER_SPAN := 2.0
const ZAKU_BORN_TIME := 2.8
const ZAKU_WALK_SPEED := 0.35
const ZAKU_ATTACK_CD_MIN := 0.5
const ZAKU_ATTACK_CD_SPAN := 3.2
const HERO_FIRE_DELAY := 0.5
const HERO_RECOVER_DELAY := 0.3
const HERO_RELOAD_TIME := 1.5
const TURRET_ROTATE_SPEED := 30.0
const TURRET_ALIGN_DOT := 0.999
const MUZZLE_VFX_SCALE := 2.0
const BLOOD_VFX_SCALE := 1.0

## Positions are source-space [x, y, z]; yaw is degrees about +Y.
const ZAKU_CONFIGS := [
	{"id": 1, "pos": [96.32, 0.28, 110.42], "yaw": -198.97, "kind": "ZakuB", "walk_time": 6.0},
	{"id": 2, "pos": [98.88, 0.28, 110.97], "yaw": -172.1, "kind": "ZakuB", "walk_time": 6.0},
	{"id": 3, "pos": [97.6, 0.28, 110.05], "yaw": -185.5, "kind": "ZakuC", "walk_time": 5.0},
	{"id": 4, "pos": [96.75, 0.28, 108.81], "yaw": -195.6, "kind": "ZakuC", "walk_time": 4.0},
	{"id": 5, "pos": [98.92, 0.28, 109.3], "yaw": -169.6, "kind": "ZakuB", "walk_time": 4.0},
]

var now := 0.0
var trace: Array = []
var rng: Callable = Callable()
var rng_draws := 0
var hero_load_delay := 0.0
var zaku_load_delay := 0.0
var vfx_load_delay := 0.0
var hero: Hero = null
var zakus: Dictionary = {}
var kills := 0
var error := ""

var _timers: Array = []
var _timer_seq := 0
var _zaku_serial := 0
var _listeners: Dictionary = {}

# ---- engine services: timers, events, randomness -----------------------------------------

func schedule(delay: float, callback: Callable) -> void:
	_timer_seq += 1
	_timers.append([now + delay, _timer_seq, callback])

func _run_due_timers() -> void:
	while true:
		var best := -1
		for i in _timers.size():
			var t: Array = _timers[i]
			if t[0] <= now and (best < 0 or t[0] < _timers[best][0] or (t[0] == _timers[best][0] and t[1] < _timers[best][1])):
				best = i
		if best < 0: return
		var entry: Array = _timers[best]
		_timers.remove_at(best)
		entry[2].call()

func listen(event_name: String, callback: Callable) -> void:
	if not _listeners.has(event_name): _listeners[event_name] = []
	_listeners[event_name].append(callback)

func unlisten(event_name: String, callback: Callable) -> void:
	if _listeners.has(event_name): _listeners[event_name].erase(callback)

func broadcast(event_name: String, arg: Variant) -> void:
	for callback in _listeners.get(event_name, []).duplicate():
		callback.call(arg)

func random() -> float:
	rng_draws += 1
	if not rng.is_valid():
		error = "No random source configured"
		return 0.0
	return rng.call()

func rec(event_name: String, fields: Dictionary = {}) -> void:
	var entry := {"t": now, "ev": event_name}
	entry.merge(fields)
	trace.append(entry)

# ---- driver ------------------------------------------------------------------------------

## hero_config: pos, turret_pos, turret_yaw, muzzle_local, [rotate_speed].
func start(hero_config: Dictionary) -> void:
	listen("destroyed", _respawn_on_destroyed)
	hero = Hero.new(self, hero_config)
	for config in ZAKU_CONFIGS:
		var cfg: Dictionary = config
		schedule(random() * SPAWN_JITTER_SPAN, func(): create_zaku(cfg))

## One frame: timers, then the hero and zombies' Lua-side update, then the turret component.
func step(dt: float) -> void:
	now += dt
	_run_due_timers()
	if hero != null: hero.update(dt)
	var ids: Array = zakus.keys()
	ids.sort()
	for id in ids:
		var zaku: Zaku = zakus[id]
		zaku.update(dt)
	if hero != null and hero.turret != null: hero.turret.update(dt)

func create_zaku(config: Dictionary) -> void:
	var zaku := Zaku.new(self, config)
	zakus[config.id] = zaku

func _respawn_on_destroyed(zaku: Zaku) -> void:
	create_zaku(zaku.config)

## Breaks the reference cycles between the encounter, its actors, state machines and
## callbacks so the whole object graph is freed. The encounter is unusable afterwards.
func dispose() -> void:
	var actors: Array = zakus.values()
	if hero != null: actors.append(hero)
	for actor in actors:
		if actor.fsm != null:
			actor.fsm.dispose()
			actor.fsm.owner = null
			actor.fsm.on_changed = Callable()
			actor.fsm = null
		actor.enc = null
	if hero != null:
		if hero.turret != null:
			hero.turret.target = null
			hero.turret.on_complete = Callable()
		hero.targets = []
	hero = null
	zakus = {}
	_timers = []
	_listeners = {}
	rng = Callable()

func snapshot() -> Dictionary:
	var zombies := {}
	for id in zakus:
		var zaku: Zaku = zakus[id]
		zombies[str(zaku.serial)] = {"id": zaku.config.id, "pos": zaku.position.duplicate(), "state": zaku.fsm.current_name if zaku.fsm != null else ""}
	var targets := []
	if hero != null:
		for target in hero.targets: targets.append(target.serial)
	return {
		"t": now, "kills": kills, "rng_draws": rng_draws,
		"hero_state": hero.fsm.current_name if hero != null and hero.fsm != null else "",
		"turret_yaw": hero.turret.yaw if hero != null else 0.0,
		"targets": targets, "zombies": zombies,
	}

# ---- SoloHero -----------------------------------------------------------------------------

class Turret extends RefCounted:
	var pos: Array
	var yaw: float
	var rotate_speed: float
	var target: Variant = null
	var on_complete: Callable = Callable()

	func _init(position_: Array, yaw_deg: float, speed: float) -> void:
		pos = position_
		yaw = yaw_deg
		rotate_speed = speed

	func update(dt: float) -> void:
		if target == null: return
		var tp: Array = target.position
		var vx: float = tp[0] - pos[0]
		var vz: float = tp[2] - pos[2]
		var length := sqrt(vx * vx + vz * vz)
		if length > 1e-5:
			vx /= length
			vz /= length
		else:
			vx = 0.0
			vz = 0.0
		var fwd := Maths.forward_of(yaw)
		if vx * fwd[0] + vz * fwd[2] > TURRET_ALIGN_DOT:
			if on_complete.is_valid(): on_complete.call()
			target = null
		else:
			var turn_toward_positive: bool = fwd[2] * vx - fwd[0] * vz > 0.0
			yaw += rotate_speed * dt * (1.0 if turn_toward_positive else -1.0)

	func muzzle_position(local_offset: Array) -> Array:
		var rotated := Maths.rotate_yaw(local_offset, yaw)
		return [pos[0] + rotated[0], pos[1] + rotated[1], pos[2] + rotated[2]]

class HeroIdle extends Fsm.State:
	func on_enter(_arg: Variant = null) -> void:
		owner.play("idle")
	func on_update(_dt: float) -> void:
		if owner.targets.size() > 0:
			owner.fsm.switch_to("Aim", owner.targets[0])

class HeroAim extends Fsm.State:
	func on_enter(arg: Variant = null) -> void:
		var target: Variant = arg
		var hero = owner
		hero.turret.target = target
		hero.turret.on_complete = func(): hero.fsm.switch_to("Fire", target)
	func on_exit() -> void:
		owner.turret.target = null
		owner.turret.on_complete = Callable()

class HeroFire extends Fsm.State:
	func on_enter(arg: Variant = null) -> void:
		var target: Variant = arg
		var hero = owner
		hero.enc.schedule(HERO_FIRE_DELAY, func(): hero.fire(target))

class HeroReload extends Fsm.State:
	var timer := 0.0
	func on_enter(_arg: Variant = null) -> void:
		owner.play("idle")
		timer = 0.0
	func on_update(dt: float) -> void:
		timer += dt
		if timer > HERO_RELOAD_TIME:
			owner.fsm.switch_to("Idle")

class Hero extends RefCounted:
	var enc
	var config: Dictionary
	var targets: Array = []
	var turret: Turret = null
	var fsm: Fsm = null
	var loaded := false

	func _init(encounter, hero_config: Dictionary) -> void:
		enc = encounter
		config = hero_config
		enc.listen("inited", _on_inited)
		enc.listen("destroyed", _on_destroyed)
		enc.schedule(enc.hero_load_delay, _on_loaded)

	func _on_loaded() -> void:
		loaded = true
		turret = Turret.new(config.turret_pos.duplicate(), float(config.turret_yaw), float(config.get("rotate_speed", TURRET_ROTATE_SPEED)))
		fsm = Fsm.new(self)
		fsm.on_changed = func(state_name): enc.rec("fsm", {"who": "hero", "state": state_name})
		fsm.add("Idle", HeroIdle.new())
		fsm.add("Aim", HeroAim.new())
		fsm.add("Fire", HeroFire.new())
		fsm.add("Reload", HeroReload.new())
		fsm.switch_to("Idle")

	func _on_inited(zaku) -> void:
		targets.append(zaku)

	func _on_destroyed(zaku) -> void:
		var index := targets.find(zaku)
		if index >= 0: targets.remove_at(index)

	func play(clip: String) -> void:
		enc.rec("anim", {"who": "hero", "call": "Play", "arg": clip})

	func update(dt: float) -> void:
		if fsm != null: fsm.update(dt)

	## Fire-state payload: muzzle flash, hit effect and the kill, then the recovery timer.
	func fire(target) -> void:
		if turret == null: return
		enc.schedule(enc.vfx_load_delay, func(): _spawn_muzzle_flash())
		enc.schedule(enc.vfx_load_delay, func(): _spawn_hit(target))
		play("attack")
		enc.schedule(HERO_RECOVER_DELAY, func():
			if fsm == null: return
			fsm.switch_to("Reload"))

	func _spawn_muzzle_flash() -> void:
		enc.rec("vfx", {"kind": "muzzle", "pos": turret.muzzle_position(config.muzzle_local), "scale": MUZZLE_VFX_SCALE})

	func _spawn_hit(target) -> void:
		if not target.alive: return
		enc.rec("vfx", {"kind": "blood", "pos": target.position.duplicate(), "scale": BLOOD_VFX_SCALE})
		target.destroy_self()

# ---- ZakuZombie ----------------------------------------------------------------------------

class ZakuBorn extends Fsm.State:
	var timer := 0.0
	func on_enter(_arg: Variant = null) -> void: timer = 0.0
	func on_update(dt: float) -> void:
		timer += dt
		if timer > ZAKU_BORN_TIME: owner.fsm.switch_to("Walk")

class ZakuWalk extends Fsm.State:
	var timer := 0.0
	func on_enter(_arg: Variant = null) -> void:
		timer = 0.0
		owner.set_bool("walking", true)
	func on_update(dt: float) -> void:
		timer += dt
		if timer > owner.config.walk_time: owner.fsm.switch_to("Attack")
		# The step is applied even on the frame that switches to Attack.
		var fwd: Array = Maths.forward_of(owner.yaw)
		for i in 3: owner.position[i] += fwd[i] * dt * ZAKU_WALK_SPEED
	func on_exit() -> void:
		owner.set_bool("walking", false)

class ZakuAttack extends Fsm.State:
	var cooldown := 0.0
	func on_enter(_arg: Variant = null) -> void: cooldown = 0.0
	func on_update(dt: float) -> void:
		cooldown -= dt
		if cooldown <= 0.0:
			owner.set_trigger("attack")
			cooldown = owner.enc.random() * ZAKU_ATTACK_CD_SPAN + ZAKU_ATTACK_CD_MIN

class Zaku extends RefCounted:
	var enc
	var config: Dictionary
	var serial := 0
	var position: Array = []
	var yaw := 0.0
	var fsm: Fsm = null
	var alive := true

	func _init(encounter, zaku_config: Dictionary) -> void:
		enc = encounter
		config = zaku_config
		enc._zaku_serial += 1
		serial = enc._zaku_serial
		enc.rec("spawn", {"z": serial, "id": config.id, "kind": config.kind})
		enc.schedule(enc.zaku_load_delay, _on_loaded)

	func _on_loaded() -> void:
		if not alive: return
		position = config.pos.duplicate()
		yaw = float(config.yaw)
		fsm = Fsm.new(self)
		fsm.on_changed = func(state_name): enc.rec("fsm", {"who": "z%d" % serial, "state": state_name})
		fsm.add("Born", ZakuBorn.new())
		fsm.add("Walk", ZakuWalk.new())
		fsm.add("Attack", ZakuAttack.new())
		fsm.switch_to("Born")
		enc.rec("inited", {"z": serial, "id": config.id})
		enc.broadcast("inited", self)

	func update(dt: float) -> void:
		if fsm == null: return
		fsm.update(dt)

	func set_bool(key: String, value: bool) -> void:
		enc.rec("anim", {"who": "z%d" % serial, "call": "SetBool", "arg": key, "val": value})

	func set_trigger(key: String) -> void:
		enc.rec("anim", {"who": "z%d" % serial, "call": "SetTrigger", "arg": key})

	func destroy_self() -> void:
		enc.rec("destroyed", {"z": serial, "id": config.id})
		enc.kills += 1
		enc.broadcast("destroyed", self)
		delete()

	func delete() -> void:
		if fsm != null:
			fsm.dispose()
			fsm = null
		alive = false
