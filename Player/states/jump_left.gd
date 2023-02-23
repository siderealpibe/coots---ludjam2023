extends BaseState

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	player.velocity.y = -player.JUMP_FORCE

func input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("mouse_left"):
		return State.SlapLeft      
	elif Input.is_action_just_pressed("mouse_right"):
		return State.DeflectLeft
	if event.is_action_released("ui_select") && player.velocity.y < -player.MIN_JUMP: 
		player.velocity.y = -player.MIN_JUMP
	return .input(event)

func physics_process(delta: float) -> int:
	var move = 0
	
	if Input.is_action_pressed("ui_left"):
		move = -1
	elif Input.is_action_pressed("ui_right"):
		move = 1

	player.velocity.x = move * player.WALK_SPEED
	player.velocity.y += player.JUMP_GRAVITY
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.velocity.y > 0:
		return State.FallLeft

	if player.is_on_floor():
		if move != 0:
			return State.WalkLeft
		else:
			return State.IdleLeft
		
	return State.Null
