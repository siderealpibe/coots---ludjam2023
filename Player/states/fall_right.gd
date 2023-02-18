extends BaseState

func physics_process(delta: float) -> int:
	var move = 0
	if Input.is_action_pressed("ui_left"):
		move = -1
	elif Input.is_action_pressed("ui_right"):
		move = 1
	
	player.velocity.x = move * player.WALK_SPEED
	player.velocity.y += player.GRAVITY
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if player.is_on_floor():
		if move != 0:
			return State.WalkRight
		else:
			return State.IdleRight
	
	return State.Null
