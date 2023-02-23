extends Node

onready var states = {
	EnemyState.State.SmileWalkRight : $smile_walk_right,
	EnemyState.State.SmileWalkLeft : $smile_walk_left,
	EnemyState.State.SmileAttackRight : $smile_attack_right,
	EnemyState.State.SmileAttackLeft : $smile_attack_left,
	EnemyState.State.SmileIdleRight: $smile_idle_right,
	EnemyState.State.SmileIdleLeft: $smile_idle_left,
	EnemyState.State.SmileKnockedDownRight: $smile_knocked_down_right,
	EnemyState.State.SmileKnockedDownLeft: $smile_knocked_down_left,
	EnemyState.State.SmileShutDown: $smile_shut_down
}

var current_state: EnemyState
var is_idle: bool

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()
	current_state = states[new_state]
	current_state.enter()

# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(enemy: Enemy) -> void:
	is_idle = enemy.IS_IDLE
	for child in get_children():
		child.enemy = enemy

	# Initialize with a default state of idle
	if enemy.IS_IDLE:
		change_state(EnemyState.State.SmileIdleRight)
	else:
		change_state(EnemyState.State.SmileWalkRight)
	
# Pass through functions for the Player to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.Null:
		change_state(new_state)

func walk_left() -> void:
	if is_idle:
		change_state(EnemyState.State.SmileIdleLeft)
	else:
		change_state(EnemyState.State.SmileWalkLeft)
	
func walk_right() -> void:
	if is_idle:
		change_state(EnemyState.State.SmileIdleRight)
	else:
		change_state(EnemyState.State.SmileWalkRight)

func left_punch() -> void:
	change_state(EnemyState.State.SmileAttackLeft)
	
func right_punch() -> void:
	change_state(EnemyState.State.SmileAttackRight)

func knock_down_right() -> void:
	change_state(EnemyState.State.SmileKnockedDownRight)
	
func knock_down_left() -> void:
	change_state(EnemyState.State.SmileKnockedDownLeft)
	
func shutdown() -> void:
	change_state(EnemyState.State.SmileShutDown)
