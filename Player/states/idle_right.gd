extends BaseState

func input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("mouse_left"):
		return State.SlapRight
	elif Input.is_action_just_pressed("mouse_right"):
		return State.DeflectRight
	return .input(event)

func physics_process(delta: float) -> int:
	player.velocity.y += player.GRAVITY
	player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if !player.is_on_floor():
		return State.FallRight
	elif Input.is_action_just_pressed("ui_select"):
		#if Input.is_action_pressed("ui_down"):
		#	player.position.y += 10
		#	return State.FallRight
		#else:
		return State.JumpRight
	elif Input.is_action_pressed("ui_left"):
		return State.WalkLeft
	elif Input.is_action_pressed("ui_right"):
		return State.WalkRight
	return State.Null
