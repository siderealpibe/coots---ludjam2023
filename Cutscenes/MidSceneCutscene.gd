extends 

func _exit():
	$BlackScreen.show()
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1024,600),1)
	get_tree().change_scene(exit_scene_path)
