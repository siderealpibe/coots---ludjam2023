extends Node

onready var states = {
	#BaseState.State.IdleRight: $idle_right,
	#BaseState.State.IdleLeft: $idle_left,
	CootsState.State.WalkRight: $walk_right,
	CootsState.State.WalkLeft: $walk_left,
	CootsState.State.IdleLeft: $idle_left
}

var current_state: CootsState

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()

	current_state = states[new_state]
	current_state.enter()

# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(coots: Coots) -> void:
	for child in get_children():
		child.coots = coots

	# Initialize with a default state of idle
	change_state(CootsState.State.IdleLeft)
	
# Pass through functions for the Player to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state != CootsState.State.Null:
		change_state(new_state)
