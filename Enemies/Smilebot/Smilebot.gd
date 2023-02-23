class_name SmileBot
extends Enemy

#onready var animations : AnimationPlayer = $AnimationPlayer
export var ORIGIN_X : int
export var WALK_SPEED : int = 100
export var RIGHT_BOUND : int = 200
export var LEFT_BOUND : int = 200
export var IS_IDLE : bool = false
export(float, .9, 5, 0.1) var HALF_TIME_DOWN : float = 3
export(NodePath) var CONTROLLER_PATH

onready var controller : ControllerHitBox = get_node(CONTROLLER_PATH)
onready var states = $StateManager
onready var animations = $AnimationPlayer
onready var velocity : Vector2 = Vector2.ZERO
onready var shake_timer : Timer = $shake_timer
onready var up_timer : Timer = $up_timer

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	$LeftDetection.connect("area_entered", self, "left_punch")
	$RightDetection.connect("area_entered", self, "right_punch")
	controller.connect("destroyed", self, "destruct")
	shake_timer.one_shot = true
	shake_timer.connect("timeout", self, "shake")
	up_timer.one_shot = true
	up_timer.connect("timeout", self, "reanimate")

#func _unhandled_input(event: InputEvent) -> void:
#	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

func take_damage(hitbox) -> void:
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
	states.left_punch()

func right_punch(player) -> void:
	states.right_punch()

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
