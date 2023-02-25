extends CanvasLayer

func change_scene_to(scene: PackedScene) -> void:
	$ColorRect.set_deferred("visible", true)
	$AnimationPlayer.play("fade_to_black")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(scene)
	$AnimationPlayer.play("fade_to_normal")
	$ColorRect.set_deferred("visible", false)

func reload_current_scene() -> void:
	$ColorRect.set_deferred("visible", true)
	$AnimationPlayer.play("fade_to_black")
	yield($AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()
	$AnimationPlayer.play("fade_to_normal")
	$ColorRect.set_deferred("visible", false)
		
