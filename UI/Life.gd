extends Control

var heart_size: int = 256

func on_player_life_changed(player_hearts) -> void:
	$Heart.rect_size.x = player_hearts * heart_size
