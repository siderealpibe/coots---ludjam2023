extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = not get_tree().paused
		queue_free()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Cancel_pressed():
	get_tree().paused = not get_tree().paused
	queue_free()
