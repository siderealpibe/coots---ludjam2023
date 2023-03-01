extends Node2D

export var emiting : bool = true
var CONTROLLER

func _ready():
	$AnimatedSprite.playing = true
	if emiting:
		$AnimatedSprite.offset = Vector2(0,0)
		$AnimatedSprite.play("emiting")
	else:
		$AudioStreamPlayer2D.stop()
		$AnimatedSprite.offset = Vector2(202,-202)
		$AnimatedSprite.rotation_degrees += 45
		$AnimatedSprite.play("receiving")
		

func _process(delta):
	if CONTROLLER != null and is_instance_valid(CONTROLLER):
		look_at(CONTROLLER.global_position)
