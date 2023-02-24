signal destroyed

class_name ControllerHitBox
extends Area2D

onready var animations : AnimationPlayer = $AnimationPlayer


func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox) -> void:
	if hitbox == null:
		return
	emit_signal("destroyed")
	queue_free()
