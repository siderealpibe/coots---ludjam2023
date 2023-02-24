extends Control

func _ready():
	OS.set_window_maximized(true)
	
func _process(delta):
	if Input.is_action_pressed("mouse_left") or Input.is_action_pressed("mouse_right"):
			get_tree().change_scene("res://Cutscenes/Abduction.tscn")
