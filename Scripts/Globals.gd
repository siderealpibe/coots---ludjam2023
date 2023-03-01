extends Node

const UNIT_SIZE = 150
var final_fight_started = false
onready var PAUSEMENU = load("res://PauseMenu.tscn")

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		var pause = PAUSEMENU.instance()
		get_tree().root.add_child(pause)
		get_tree().paused = not get_tree().paused
