extends Control

func _ready():
	OS.set_window_maximized(true)
	
func _on_Button_pressed():
	get_tree().change_scene("res://Cutscenes/Abduction.tscn")


func _on_Button2_pressed():
	get_tree().change_scene("res://Stages/Tutorial.tscn")
