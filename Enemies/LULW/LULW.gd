extends KinematicBody2D

export var FACING_RIGHT = false
export var LASER_COOLDOWN : float = 3
export(PackedScene) var LASER_SCENE
export(NodePath) var CONTROLLER

export var  CAN_SHOOT : bool = true
onready var laser_timer : Timer = $LaserTimer
onready var controller : ControllerHitBox = get_node(CONTROLLER) if CONTROLLER != "" else null

func _ready():
	$Sprite.flip_h = FACING_RIGHT
	laser_timer.one_shot = true
	laser_timer.connect("timeout", self, "_on_laser_timer_timeout")
	if controller != null:
		controller.connect("destroyed", self, "destruct")

func _process(delta):
	if CAN_SHOOT:
		$AnimationPlayer.play("Shoot")
		CAN_SHOOT = false
	
func _on_laser_timer_timeout():
	CAN_SHOOT = true
	
func shoot():
	var laser = LASER_SCENE.instance()
	add_child(laser)
	laser.position = Vector2(250,75) if FACING_RIGHT else Vector2(-250,75)
	var direction : Vector2 = Vector2.RIGHT if FACING_RIGHT else Vector2.LEFT
	laser.shoot(direction)
	laser_timer.start(LASER_COOLDOWN)
	
func destruct() -> void:
	laser_timer.disconnect("timeout",self,"_on_laser_timer_timeout")
	CAN_SHOOT = false
	$AnimationPlayer.play("Falling")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
