extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var noise = OpenSimplexNoise.new()
var amplitude = 0
var priority = 0

onready var camera = get_parent()

#duration: the total time of the shake
#frequency: the number of times the screen will shake
#amplitude: strenght of the shake in pixels
func start(duration : float = 0.2, frequency : int = 15, amplitude : int = 16, prority : int = 0):
	if priority >= self.priority:
		self.amplitude = amplitude
		self.priority = priority
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()
		
		_new_shake()
		
func _new_shake():
	var rand = Vector2()
	rand.x = noise.get_noise_2d(-amplitude, amplitude)
	rand.y = noise.get_noise_2d(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera,"offset",camera.offset, rand, $Frequency.wait_time, TRANS,EASE)
	$ShakeTween.start()

func _reset():
	$ShakeTween.interpolate_property(camera, "offset",camera.offset,Vector2(),$Frequency.wait_time,TRANS,EASE)

func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
	
	priority = 0
