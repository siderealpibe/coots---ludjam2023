class_name SmileBot
extends Enemy

#onready var animations : AnimationPlayer = $AnimationPlayer
export var ORIGIN_X : int
export var WALK_SPEED : int = 100
export var RIGHT_BOUND : int = 200
export var LEFT_BOUND : int = 200
export var IS_IDLE : bool = false
onready var states = $StateManager
onready var animations = $AnimationPlayer
var velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	$LeftDetection.connect("area_entered", self, "left_punch")
	$RightDetection.connect("area_entered", self, "right_punch")

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
