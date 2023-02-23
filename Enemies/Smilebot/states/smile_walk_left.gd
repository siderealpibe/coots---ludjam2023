extends EnemyState

func physics_process(delta: float) -> int:
	if enemy.position.x - enemy.ORIGIN_X <= -enemy.LEFT_BOUND:
		return State.SmileWalkRight
	
	#enemy.velocity.x = -enemy.WALK_SPEED
	#enemy.velocity = enemy.move_and_slide_with_snap(enemy.velocity, 10*Vector2.DOWN, Vector2.UP)

	return State.Null
