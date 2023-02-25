extends Control

signal scene_over

onready var animation_plaer = $AnimationPlayer
export(String) var exit_scene_path

func _ready():
	#get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_KEEP, Vector2(1024,600),1)
	$BlackScreen.show()
	$SkipMessage.show()

func _on_AnimationPlayer_animation_finished(anim_name):
	_exit()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.stop()
		_exit()

func _on_StartDelay_timeout():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Animation")

func _exit():
	$BlackScreen.show()
	#get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1024,600),1)
	emit_signal("scene_over")
	queue_free()


func _on_LabelDisplay_timeout():
	$SkipMessage.hide()
