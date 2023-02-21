class_name SmileBot
extends Enemy

#onready var animations : AnimationPlayer = $AnimationPlayer
export var ORIGIN_X : int
export var WALK_SPEED : int = 100
export var RIGHT_BOUND : int = 200
export var LEFT_BOUND : int = 200
onready var states = $StateManager
var velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)

#func _unhandled_input(event: InputEvent) -> void:
#	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

func take_damage(hitbox) -> void:
	queue_free()
