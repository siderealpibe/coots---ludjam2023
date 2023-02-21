extends BaseState

func input(event: InputEvent) -> int:
	if Input.is_action_pressed("ui_left"):
		return State.WalkLeft
	elif Input.is_action_pressed("ui_select"):
		if Input.is_action_pressed("ui_down"):
			player.position.y += 10
			return State.FallRight
		else:
			return State.JumpRight
	elif event is InputEventMouseButton:
		return State.SlapRight
	return .input(event)

func physics_process(delta: float) -> int:
	#if !player.is_on_floor():
	#	return State.Fall

	var move = 0
	if Input.is_action_pressed("ui_right"):
		move = 1
	
	player.velocity.y += player.GRAVITY
	player.velocity.x = move * player.WALK_SPEED
	player.velocity = player.move_and_slide_with_snap(player.velocity, 10*Vector2.DOWN, Vector2.UP)
	if move == 0:
		return State.IdleRight

	return State.Null
