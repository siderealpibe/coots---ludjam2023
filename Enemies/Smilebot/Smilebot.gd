class_name SmileBot
extends Enemy

#onready var animations : AnimationPlayer = $AnimationPlayer

export var WALK_SPEED : int = 100
export var RIGHT_BOUND : int = 200
export var LEFT_BOUND : int = 200
export var IS_IDLE : bool = false
export var IS_FLIPPED : bool = false
export var CAN_PUNCH : bool = true
export var CAN_SHOOT : bool = true
export(float, .9, 5, 0.1) var HALF_TIME_DOWN : float = 3
export(float, 0, 10, 1) var LASER_RECHARGE_TIME : float = 5
export(NodePath) var CONTROLLER
export(NodePath) var LASER_DETECTION
export(PackedScene) var LASER_SCENE
export var SHOW_CONTROL_WAVES : bool = false


onready var controller : ControllerHitBox = get_node(CONTROLLER) if CONTROLLER != "" else null
onready var states = $StateManager
onready var animations = $AnimationPlayer
onready var velocity : Vector2 = Vector2.ZERO
onready var shake_timer : Timer = $shake_timer
onready var up_timer : Timer = $up_timer
onready var pause_timer : Timer = $pause_timer
onready var pause_action : bool = false
onready var pause_time : int = 1
onready var is_down : bool = false

var ORIGIN_X : int
var laser_detection : PlayerDetectionBox
onready var laser_timer : Timer = $laser_timer

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	if SHOW_CONTROL_WAVES:
		$"Sprite/Control Waves".show()
	else:
		$"Sprite/Control Waves".hide()
	$LeftDetection.connect("area_entered", self, "left_punch")
	$RightDetection.connect("area_entered", self, "right_punch")
	ORIGIN_X = global_position.x
	laser_detection = get_node(LASER_DETECTION) if LASER_DETECTION != "" else $LaserDetection
	laser_detection.connect("area_entered",self,"shoot_laser")
	if controller != null:
		controller.connect("destroyed", self, "destruct")
		$"Sprite/Control Waves".CONTROLLER = controller;
	shake_timer.one_shot = true
	shake_timer.connect("timeout", self, "shake")
	up_timer.one_shot = true
	up_timer.connect("timeout", self, "reanimate")
	laser_timer.one_shot = true
	laser_timer.connect("timeout", self, "recharge")
	pause_timer.one_shot = true
	pause_timer.connect("timeout", self, "unpause")

#func _unhandled_input(event: InputEvent) -> void:
#	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

func take_damage(hitbox) -> void:
	is_down = true
	var direction = global_position.x - hitbox.global_position.x
	if direction > 0:
		states.knock_down_left()
	else:
		states.knock_down_right()
	
func walk_forward() -> void:
	position.x += WALK_SPEED
	#velocity = move_and_slide_with_snap(velocity, 10*Vector2.DOWN, Vector2.UP)
	
func walk_backwards() -> void:
	position.x -= WALK_SPEED
	#velocity = move_and_slide_with_snap(velocity, 10*Vector2.DOWN, Vector2.UP)
	
func left_punch(player) -> void:
	if CAN_PUNCH and not pause_action:
		states.left_punch()
		pause_action = true
		yield(animations,"animation_finished")
		pause_timer.start(pause_time)

func right_punch(player) -> void:
	if CAN_PUNCH and not pause_action:
		states.right_punch()
		pause_action = true
		yield(animations,"animation_finished")
		pause_timer.start(pause_time)

func start_walking() -> void:
	IS_IDLE = false
	states.is_idle = false
	states.walk_right()

func unpause() -> void:
	pause_action = false

func shoot_laser(player) -> void:
	if CAN_SHOOT and not is_down and not pause_action:
		animations.play("Shoot_Laser")
		yield(animations,"animation_finished")
		if is_down or pause_action:
			$EyeLaser.set_deferred("visible", false)
			return
		var laser = LASER_SCENE.instance()
		get_parent().add_child(laser)
		laser.position = global_position + Vector2(0,-175)
		laser.shoot((player.global_position - laser.position).normalized())
		CAN_SHOOT = false
		pause_action = true
		pause_timer.start(pause_time)
		#LASER_DETECTION.disabled = true
		laser_timer.start(LASER_RECHARGE_TIME)
		if $Sprite.flip_h:
			states.walk_right()
		else:
			states.walk_left()
			
func recharge() -> void:
	CAN_SHOOT = true
	if not laser_detection.get_node("CollisionShape2D").disabled:
		disable_laser()
		enable_laser()

func enable_laser() -> void:
	laser_detection.get_node("CollisionShape2D").set_deferred("disabled",false)
	if laser_detection.get_node("CollisionShape2D3") != null:
		laser_detection.get_node("CollisionShape2D3").set_deferred("disabled",false) 

func disable_laser() -> void:
	laser_detection.get_node("CollisionShape2D").set_deferred("disabled",true) 
	if laser_detection.get_node("CollisionShape2D3") != null:
		laser_detection.get_node("CollisionShape2D3").set_deferred("disabled",true) 

func start_shake() -> void:
	shake_timer.start(HALF_TIME_DOWN)

func start_up() -> void:
	up_timer.start(HALF_TIME_DOWN)

func shake() -> void:
	animations.play("shake")
	
func reanimate() -> void:
	var animation = "Reanimate_forward" if $Sprite.flip_h else "Reanimate_backwards"
	animations.play(animation)
	is_down = false

func destruct() -> void:
	states.shutdown()
	yield(animations, "animation_finished")
	queue_free()
	
