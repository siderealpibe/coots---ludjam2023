class_name Coots
extends Node2D

signal sat_down

export var LEFT_BOUND : int = -1000
export var RIGHT_BOUND : int = 1000
export var STEP : int = 175
export(float, 0, 10, 1) var LASER_RECHARGE_TIME : float = 5
export(float, 0, 10, 1) var PAW_RECHARGE_TIME : float = 2
export(PackedScene) var LASER_SCENE
export(NodePath) var PLAYER_PATH
export(NodePath) var CONTROLLER
#export(NodePath) var CONTROLLER_PATH

onready var player : Player = get_node(PLAYER_PATH)
onready var controller : ControllerHitBox = get_node(CONTROLLER) if CONTROLLER != "" else null
#onready var controller : ControllerBoss = get_node(CONTROLLER_PATH)
onready var animations : AnimationPlayer = $AnimationPlayer
onready var states = $StateManager
onready var laser_timer = $LaserTimer
onready var paw_timer = $PawTimer

var fight_stage : int = 0
var can_shoot : bool = false
var can_paw : bool = false

func _ready():
	states.init(self)
	animations.play("Idle")
	laser_timer.connect("timeout", self, "_on_laser_timer_timeout")
	paw_timer.connect("timeout", self, "_on_paw_timer_timeout")
	if controller != null:
		$"Body/Head/Control Waves/Control Waves".CONTROLLER = controller
func shoot_laser() -> void:
		#animations.play("Shoot_Laser")
		#yield(animations,"animation_finished")
	var laser = LASER_SCENE.instance()
	get_parent().add_child(laser)
	laser.position = global_position + $Body/Head.offset + Vector2(-200,-100)
	laser.shoot((player.global_position - laser.position).normalized())
		#can_shoot = false
		#LASER_DETECTION.disabled = true
	#laser_timer.start(LASER_RECHARGE_TIME)

func _physics_process(delta):
	states.physics_process(delta)

func _on_laser_timer_timeout():
	if can_shoot:
		shoot_laser()
		laser_timer.start(LASER_RECHARGE_TIME)
	
func _on_paw_timer_timeout():
	if can_paw:
		animations.play("Paw_attack")
		yield(animations, "animation_finished")
		paw_timer.start(PAW_RECHARGE_TIME)

func walk_right() -> void:
	position.x += STEP
	#velocity = move_and_slide_with_snap(velocity, 10*Vector2.DOWN, Vector2.UP)
	
func walk_left() -> void:
	position.x -= STEP
	#velocity = move_and_slide_with_snap(velocity, 10*Vector2.DOWN, Vector2.UP)

func turn_and_shoot() -> void:
	animations.play("Idle_turning")
	yield(animations,"animation_finished")
	shoot_laser()
	animations.play_backwards("Idle_turning")

func walk_left_and_sit() -> void:
	animations.play("Walk_left_no_loop")
	yield(animations,"animation_finished")
	animations.play("Sitting_down")
	yield(animations,"animation_finished")
	animations.play("Paw_attack")
	yield(animations,"animation_finished")
	emit_signal("sat_down")

func start_walking() -> void:
	states.start_walking()

func start_walking_turned() -> void:
	states.start_walking_turned()
