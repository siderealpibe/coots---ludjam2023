extends ParallaxBackground

func _ready():
	pass
#	spawn lightnings inside SpawnLightning boundaries

func _process(delta):
	pass

func _get_random_number(mim_num,max_num):
	randomize()
	round(rand_range(mim_num,max_num))
