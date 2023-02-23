class_name SmileBot
extends Enemy

#onready var animations : AnimationPlayer = $AnimationPlayer

export var WALK_SPEED : int = 100
export var RIGHT_BOUND : int = 200
export var LEFT_BOUND : int = 200
export var IS_IDLE : bool = false
export var CAN_PUNCH : bool = true
export var CAN_SHOOT : bool = true
export(float, .9, 5, 0.1) var HALF_TIME_DOWN : float = 3
export(float, 0, 10, 1) var LASER_RECHARGE_TIME : float = 5
export(NodePath) var CONTROLLER
export(NodePath) var LASER_DETECTION
export(PackedScene) var LASER_SCENE


onready var controller : ControllerHitBox = get_node(CONTROLLER)
onready var states = $StateManager
onready var animations = $AnimationPlayer
onready var velocity : Vector2 = Vector2.ZERO
onready var shake_timer : Timer = $shake_timer
onready var up_timer : Timer = $up_timer

var ORIGIN_X : int
var laser_detection : PlayerDetectionBox
onready var laser_timer : Timer = $laser_timer

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	$LeftDetection.connect("area_entered", self, "left_punch")
	$RightDetection.connect("area_entered", self, "right_punch")
	ORIGIN_X = global_position.x
	laser_detection = get_node(LASER_DETECTION) if LASER_DETECTION != "" else $LaserDetection
	laser_detection.connect("area_entered",self,"shoot_laser")
	if controller != null:
		controller.connect("destroyed", self, "destruct")
	shake_timer.one_shot = true
	shake_timer.connect("timeout", self, "shake")
	up_timer.one_shot = true
	up_timer.connect("timeout", self, "reanimate")
	laser_timer.one_shot = true
	laser_timer.connect("timeout", self, "recharge")

#func _unhandled_input(event: InputEvent) -> void:
#	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

func take_damage(hitbox) -> void:
	print("hello")
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
	if CAN_PUNCH:
		states.left_punch()

func right_punch(player) -> void:
	if CAN_PUNCH:
		states.right_punch()

func shoot_laser(player) -> void:
	if CAN_SHOOT:
		animations.play("Shoot_Laser")
		yield(animations,"animation_finished")
		var laser = LASER_SCENE.instance()
		add_child(laser)
		laser.position = Vector2(0,-175)
		laser.shoot((player.global_position - global_position - Vector2(0,-175)).normalized())
		CAN_SHOOT = false
		#LASER_DETECTION.disabled = true
		laser_timer.start(LASER_RECHARGE_TIME)
		if $Sprite.flip_h:
			states.walk_right()
		else:
			states.walk_left()
			
func recharge() -> void:
	CAN_SHOOT = true
	#LASER_DETECTION.disabled = false

func enable_laser() -> void:
	laser_detection.get_node("CollisionShape2D").disabled = false

func disable_laser() -> void:
	laser_detection.get_node("CollisionShape2D").disabled = true

func start_shake() -> void:
	shake_timer.start(HALF_TIME_DOWN)

func start_up() -> void:
	print("hello")
	up_timer.start(HALF_TIME_DOWN)

func shake() -> void:
	animations.play("shake")
	
func reanimate() -> void:
	var animation = "Reanimate_forward" if $Sprite.flip_h else "Reanimate_backwards"
	print(animation)
	animations.play(animation)

func destruct() -> void:
	states.shutdown()
	yield(animations, "animation_finished")
	queue_free()
	
