extends CootsState

func physics_process(delta: float) -> int:
	if coots.global_position.x >= coots.RIGHT_BOUND:
		return State.WalkLeft

	return State.Null
