extends RefCounted
## Small state machine with the switching contract of the recovered Common.FSMachine:
## switching to the active state is a no-op, the old state exits before the new one
## enters, and a state may switch again from inside its own enter/update callback.

class State extends RefCounted:
	var owner: Variant = null
	func on_enter(_arg: Variant = null) -> void: pass
	func on_update(_dt: float) -> void: pass
	func on_exit() -> void: pass

var owner: Variant = null
var states: Dictionary = {}
var current: State = null
var current_name := ""
## Called with the new state's name after its enter hook has run.
var on_changed: Callable = Callable()

func _init(owner_ref: Variant) -> void:
	owner = owner_ref

func add(state_name: String, state: State) -> void:
	assert(not states.has(state_name), "state already exists: " + state_name)
	states[state_name] = state
	state.owner = owner

func switch_to(state_name: String, arg: Variant = null) -> void:
	var next: State = states.get(state_name)
	assert(next != null, "unknown state: " + state_name)
	if current == next: return
	if current != null: current.on_exit()
	current = next
	current_name = state_name
	current.on_enter(arg)
	if on_changed.is_valid(): on_changed.call(state_name)

func update(dt: float) -> void:
	if current != null: current.on_update(dt)

## Leaves the active state (running its exit hook) and drops every state.
func dispose() -> void:
	if current != null: current.on_exit()
	current = null
	current_name = ""
	states = {}
