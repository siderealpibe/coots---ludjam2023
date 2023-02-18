extends KinematicBody2D

signal grounded_updated(touching_ground)

const UP = Vector2(0,-1)
const SLOPE_STOP = 100;

var velocity = Vector2()
var speed = 1000
var gravity = 1200
var jump_velocity = -1200
var touching_ground
var facingForward = true

onready var raycasts = $Raycasts

func _ready():
	pass

func _process(delta):
	_get_input()
	velocity.y += gravity * delta;
	velocity = move_and_slide(velocity, UP,SLOPE_STOP)
	
	var was_grounded = touching_ground
	touching_ground = _touching_ground()
	if was_grounded == null || touching_ground != was_grounded:
		emit_signal("grounded_updated",touching_ground)
	if Input.is_action_pressed("normal_slap"):
		$AnimationPlayer.play("Normal_slap")
	elif Input.is_action_pressed("ui_left"):
		facingForward = false
		$AnimationPlayer.play("Running_backwards")
	elif Input.is_action_pressed("ui_right"):
		facingForward = true
		$AnimationPlayer.play("Running_forward")
	elif !($AnimationPlayer.current_animation == "normal_slap" && $AnimationPlayer.is_playing()):
		if facingForward:
			$AnimationPlayer.play("Idle_forward")
		else: 
			$AnimationPlayer.play("Idle_backward")
		
	_handle_animations()
	
func _input(event):
	if event.is_action_pressed("ui_up") && touching_ground:
		velocity.y = jump_velocity
	if event.is_action_released("ui_up") && velocity.y < -500: 
		velocity.y = -500

func _get_input():
	var direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	velocity.x = lerp(velocity.x, (speed if touching_ground else speed * 1.2) * direction, 0.2)
	if direction == 0:
		if (velocity.x < 0 && velocity.x > -1) || (velocity.x > 0 && velocity.x < 1):
			velocity.x = 0

#	if direction != 0:
#		$Body.scale.x = direction

func _get_h_weight():
	return 0.2 if touching_ground else 0.1

func _touching_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	return false

func _handle_animations():
	var anim = "idle"
	
	if touching_ground:
		anim = "jump"
	elif velocity.x != 0:
		anim = "run"
	
