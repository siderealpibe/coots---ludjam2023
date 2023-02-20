class_name Player
extends KinematicBody2D

export var GRAVITY : int = 40
export var JUMP_GRAVITY : int = 40
export var SLAP_GRAVITY : int = 10
export var JUMP_FORCE : int= 1500
export var MIN_JUMP : int = 500
export var WALK_SPEED : int = 100
export var MAX_HEALTH : int = 100
export var SLAP_MOVEMENT : int = 700
export var SLAP_FRICTION : int = 50
var velocity : Vector2 = Vector2.ZERO

onready var animations = $AnimationPlayer
onready var states = $StateManager
onready var current_health : int = 100

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
