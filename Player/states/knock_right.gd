extends BaseState

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	player.hurtcapsule.disabled = true
	player.velocity.y = -player.KNOCK_FORCE_Y
	player.velocity.x = player.KNOCK_FORCE_X

func exit() -> void:
	player.hurtcapsule.disabled = false
	.exit()

func physics_process(delta: float) -> int:
	player.velocity.y += player.GRAVITY
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if player.is_on_floor():
		return State.IdleRight
		
	return State.Null
