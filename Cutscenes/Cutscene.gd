extends Control

onready var animation_plaer = $AnimationPlayer
export(String) var exit_scene_path

func _ready():
	OS.set_window_maximized(true)
	$BlackScreen.show()
#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1280,720),2)
#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280,720),1)

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(exit_scene_path)


func _on_StartDelay_timeout():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Animation")
