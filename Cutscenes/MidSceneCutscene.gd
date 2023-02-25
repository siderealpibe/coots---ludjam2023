extends Cutscene

signal scene_over

func _exit():
	#$BlackScreen.show()
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1024,600),1)
	emit_signal("scene_over")
	queue_free()
