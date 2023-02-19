extends BaseState

func input(event: InputEvent) -> int:
	if Input.is_action_pressed("ui_right"):
		return State.WalkRight
	elif Input.is_action_pressed("ui_select"):
		return State.JumpLeft
	elif event is InputEventMouseButton:
		return State.SlapLeft
	return .input(event)

func physics_process(delta: float) -> int:
	#if !player.is_on_floor():
	#	return State.Fall

	var move = 0
	if Input.is_action_pressed("ui_left"):
		move = -1
	
	player.velocity.y += player.GRAVITY
	player.velocity.x = move * player.WALK_SPEED
	player.velocity = player.move_and_slide_with_snap(player.velocity, 10*Vector2.DOWN, Vector2.UP)
	if move == 0:
		return State.IdleLeft

	return State.Null
