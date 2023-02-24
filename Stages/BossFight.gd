extends Node

onready var controller = $ControllerEntrance/PathFollow2D/BossController
onready var player = $Player
onready var coots = $Coots 

var fight_started : bool = false 

func _ready():
	OS.set_window_maximized(true)
	$PlayerDetectionBox.connect("area_entered", self, "_start_cutscene")
	controller.connect("update_stage", self, "_update_stage")

func _start_cutscene(hitbox):
	if fight_started:
		return
	$PlayerDetectionBox/CollisionShape2D.disabled = true
	fight_started = true
	player.states.force_idle()
	$camera_transition.transition_camera2D($Player.get_camera(), $BossFightCamera)
	yield($camera_transition, "finished_transition")
	coots.turn_and_shoot()
	yield(player,"hit")
	player.states.force_idle()
	controller.idle()
	$Cutscenes.play("ControllerEntry")
	yield($Cutscenes, "animation_finished")
	$Cutscenes.play("ControllerFloat")
	coots.walk_left_and_sit()
	yield(coots, "sat_down")
	coots.can_paw = true
	coots._on_paw_timer_timeout()
	yield($Player, "progress")
	player.states.idle_right()
	#controller.fight_stage = 1
	#_update_stage(1)

func _update_stage(stage: int) -> void:
	match stage:
		1: 
			coots.can_paw = false
			coots.can_shoot = true
			$Cutscenes.play("stage2")
			yield($Cutscenes, "animation_finished")
			$Cutscenes.play("ControllerFloat2")
			$Cutscenes.play("smilebot_entry")
			yield($Cutscenes, "animation_finished")
			coots.animations.play_backwards("Sitting_down")
			yield(coots.animations, "animation_finished")
			coots.start_walking()
			coots._on_laser_timer_timeout()
		2:
			return 
			
		
