extends BaseState

func input(event: InputEvent) -> int:
	player.progress()
	return .input(event)

func physics_process(delta: float) -> int:
	player.velocity.y += player.GRAVITY
	player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	return State.Null
