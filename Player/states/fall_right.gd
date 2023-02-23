extends BaseState

func input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("mouse_left"):
		return State.SlapRight
	elif Input.is_action_just_pressed("mouse_right"):
		return State.DeflectRight
	return .input(event)

func physics_process(delta: float) -> int:
	var move = 0
	if player.is_on_floor():
		if move != 0:
			return State.WalkRight
		else:
			return State.IdleRight
	
	if Input.is_action_pressed("ui_right"):
		move = 1
	
	player.velocity.x = move * player.WALK_SPEED
	player.velocity.y += player.GRAVITY
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_pressed("ui_left"):
		return State.FallLeft
	
	return State.Null

