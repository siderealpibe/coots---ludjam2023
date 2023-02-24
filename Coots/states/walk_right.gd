extends CootsState

func physics_process(delta: float) -> int:
	if coots.position.x >= coots.RIGHT_BOUND:
		return State.WalkLeft

	return State.Null
