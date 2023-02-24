class_name Player
extends KinematicBody2D

signal life_changed(health)
signal progress
signal hit
signal death

export var GRAVITY : int = 40
export var JUMP_GRAVITY : int = 40
export var SLAP_GRAVITY : int = 10
export var JUMP_FORCE : int= 2000
export var MIN_JUMP : int = 500
export var WALK_SPEED : int = 100
export var MAX_HEALTH : int = 5
export var SLAP_MOVEMENT : int = 700
export var SLAP_FRICTION : int = 50
export var KNOCK_FORCE_Y : int = 700
export var KNOCK_FORCE_X : int = 500
export(Vector2) var SPAWN
export(NodePath) var UI_PATH
var velocity : Vector2 = Vector2.ZERO

onready var animations : AnimationPlayer = $AnimationPlayer
onready var damage_animation : AnimationPlayer = $DamagePlayer
onready var states = $StateManager
onready var hurtbox : HurtBox = $HurtBox
onready var hurtcapsule : CollisionShape2D = $HurtBox/HurtCapsule
onready var UI = get_node(UI_PATH)
onready var current_health : int = MAX_HEALTH

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	connect("life_changed", UI.get_node("Life"), "on_player_life_changed")
	emit_signal("life_changed", MAX_HEALTH)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	
func take_damage(hitbox) -> void:
	current_health -= 1
	emit_signal("life_changed", current_health)
	if current_health <= 0:
		global_position = SPAWN
		current_health = MAX_HEALTH
		emit_signal("life_changed", current_health)
		emit_signal("death")
		return
	var direction = global_position.x - hitbox.global_position.x
	if direction > 0:
		states.knock_right()
	else:
		states.knock_left()
	damage_animation.play("Hurt")
	yield(damage_animation, "animation_finished")
	emit_signal("hit")

func progress() -> void:
	emit_signal("progress")

func get_camera() -> Node:
	return $Camera2D
