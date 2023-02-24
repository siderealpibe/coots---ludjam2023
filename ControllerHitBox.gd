signal destroyed

class_name ControllerHitBox
extends Area2D

onready var animations : AnimationPlayer = $AnimationPlayer


func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	animations.play("Idle")

func _on_area_entered(hitbox) -> void:
	if hitbox == null:
		return
	animations.play("Falling")
	yield(animations, "animation_finished")
	emit_signal("destroyed")
	queue_free()
