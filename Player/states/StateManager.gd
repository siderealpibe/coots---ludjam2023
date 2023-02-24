extends Node

onready var states = {
	BaseState.State.IdleRight: $idle_right,
	BaseState.State.IdleLeft: $idle_left,
	BaseState.State.WalkRight: $walk_right,
	BaseState.State.WalkLeft: $walk_left,
	BaseState.State.SlapLeft: $slap_left,
	BaseState.State.SlapRight: $slap_right,
	BaseState.State.JumpRight: $jump_right,
	BaseState.State.JumpLeft: $jump_left,
	BaseState.State.FallRight: $fall_right,
	BaseState.State.FallLeft: $fall_left,
	BaseState.State.KnockRight: $knock_right,
	BaseState.State.KnockLeft: $knock_left,
	BaseState.State.DeflectRight: $deflect_right,
	BaseState.State.DeflectLeft: $deflect_left,
	BaseState.State.ForcedIdle: $forced_idle,
	#BaseState.State.Fall: $fall,
	#BaseState.State.Jump: $jump,
}

var current_state: BaseState

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()

	current_state = states[new_state]
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

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state != BaseState.State.Null:
		change_state(new_state)
		
func idle_right() -> void:
	change_state(BaseState.State.IdleRight)
	
func idle_left() -> void:
	change_state(BaseState.State.IdleLeft)
	
func knock_right() -> void:
	change_state(BaseState.State.KnockRight)
	
func knock_left() -> void:
	change_state(BaseState.State.KnockLeft)
	
func force_idle() -> void:
	change_state(BaseState.State.ForcedIdle)

