extends Node
	
export(PackedScene) var next_scene : PackedScene

func _on_scene_change(scene) -> void:
	next_scene = scene
	$TransitionScreen.transition()
	
func _on_scene_reload() -> void:
	$TransitionScreen.transition()
	
func _on_TransitionScreen_transitioned():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(next_scene.instance())
