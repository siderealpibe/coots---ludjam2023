extends Node2D


func _ready():
	match (_get_random_number(1,3)):
		1:
			$AnimationPlayer.play("Normal")
		2:
			$AnimationPlayer.play("Double")
		_:
			$AnimationPlayer.play("Short")
	$Sprite.frame = _get_random_number(0,7)



func _get_random_number(mim_num,max_num):
	randomize()
	round(rand_range(mim_num,max_num))


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
