signal update_stage(state_num)

class_name ControllerBoss
extends ControllerHitBox

var fight_stage = 0
var hits = 0

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

#func _ready() -> void:
	#connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox) -> void:
	if hitbox == null or (fight_stage == 2 and hitbox is Laser):
		return
	$Damage.play("damage")
	hits += 1
	if hits >= 3:
		if fight_stage == 1:
			emit_signal("destroyed")
		fight_stage += 1
		emit_signal("update_stage", fight_stage)
		hits = 0

func falling():
	$Propulsion.set_deferred("visible", false)

func idle():
	animations.play("Idle")
