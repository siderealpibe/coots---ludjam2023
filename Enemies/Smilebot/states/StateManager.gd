extends Node

onready var states = {
}

var current_state: BaseState

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()

	current_state = states[new_state]
	print(current_state)
	current_state.enter()

# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(player: Player) -> void:
	for child in get_children():
		child.player = player

	# Initialize with a default state of idle
	change_state(BaseState.State.IdleRight)
	
# Pass through functions for the Player to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.Null:
		change_state(new_state)
