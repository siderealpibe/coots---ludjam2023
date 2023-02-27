extends ParallaxBackground

onready var stormLimitTL : Vector2 = $Layer1/Sprite/stormLimitTL.position
onready var stormLimitBR : Vector2 = $Layer1/Sprite/stormLimitBR.position
export(PackedScene) var LIGHTNING_SCENE

func _ready():
	$StormTimer.start(_get_random_float(0,3))

func _get_random_int(mim_num,max_num):
	randomize()
	return round(rand_range(mim_num,max_num))

func _get_random_float(mim_num,max_num):
	randomize()
	return rand_range(mim_num,max_num)

func _on_StormTimer_timeout():
	$StormTimer.start(_get_random_float(0,4))
	var randomPos = Vector2(_get_random_int(stormLimitTL.x,stormLimitBR.x),_get_random_int(stormLimitTL.y,stormLimitBR.y))
	var lightning = LIGHTNING_SCENE.instance()
	match _get_random_int(1,3):
		1: $Layer1/Sprite.add_child(lightning)
		2: $Layer2/Sprite.add_child(lightning)
		_: $Layer3/Sprite.add_child(lightning)
	lightning.position = randomPos
