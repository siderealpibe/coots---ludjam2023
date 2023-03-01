extends Node

export(PackedScene) var dialogBoxScene : PackedScene
export(PackedScene) var startingScene : PackedScene
export(PackedScene) var endingScene : PackedScene

onready var controller = $ControllerEntrance/PathFollow2D/Path2D/PathFollow2D/BossController
onready var player = $Player
onready var coots = $Coots
var coots_boss_battle_song = load("res://Assets/Music/Coots Boss Battle.wav") 
var fight_started : bool = false

func _ready():
	var audio_file =  "res://Assets/Music/Coots Boss Battle.wav"
	controller.connect("update_stage", self, "_update_stage")
	if Globals.final_fight_started:
		$Player.position = Vector2(-1922,1495)
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = coots_boss_battle_song
		$AudioStreamPlayer.play()
		controller.fight_stage = 1
		coots.disable_paws_col()
		coots.can_paw = false
		coots.can_shoot = true
		$BossFightCamera.current = true
		$Cutscenes.play("stage2")
		yield($Cutscenes, "animation_finished")
		controller.enable_shield()
		$ControllerFloat.play("ControllerFloat")
		$Cutscenes.play("smilebot_entry")
		player.states.idle_right()
		yield($Cutscenes, "animation_finished")
		#$Platform1/LULW.CAN_SHOOT = true 
		$Platform2/LULW.CAN_SHOOT = true
		$Platform4/LULW.CAN_SHOOT = true
		#$Platform5/LULW.CAN_SHOOT = true
		coots.animations.play_backwards("Sitting_down")
		yield(coots.animations, "animation_finished")
		coots.start_walking_turned()
		coots._on_laser_timer_timeout()
	else:
		$PlayerDetectionBox.connect("area_entered", self, "_start_cutscene")
		controller.connect("taunt", self, "_taunt")

var d1 = '[  {"Name": "Ludwig", "Text":"COOTS! Is that you???"}]'
var d2 = '[ {"Name": "???", "Text":"Hahaha, I\'ve taken control of your \'Coots\' and made her into MY cat."},{"Name": "???", "Text":"Now I\'ll be the one milking her for content!"}]'
var d3 = '[ {"Name": "???", "Text":"Ow, what are you doing???"},{"Name": "???", "Text":"Listen to me!"}]'
var d4 = '[{"Name": "???", "Text":"Enough playing around!"},{"Name": "???", "Text":"To me my minions!"},{"Name": "???", "Text":"Let us get rid of this second-rate streamer!"}]'
var d5 = '[{"Name": "???", "Text":"Ughhh, I suppose I\'m finished."},{"Name": "???", "Text":"My stream numbers were declining and I thought maybe your cat could save them for me."},{"Name": "Ludwig", "Text":"Coots isn\'t just content to me, she\'s also much more."},{"Name": "Ludwig", "Text":"Coots is a friend I could never replace!"},{"Name": "???", "Text":"I can see that now. GGs Ludwig. Its time you finished me off..."}]'
var taunt = '[{"Name": "???", "Text":"It\'ll take more than 1 or 2 hits to defeat me!"}]'

func play_dialog(dialogPath):
	var dialog = dialogBoxScene.instance()
	dialog.set("dialog", dialogPath)
	$UI.add_child(dialog)
	return dialog

func _taunt():
	player.states.force_idle()
	yield(play_dialog(taunt), "dialog_finished")
	player.states.idle_right()

func _start_cutscene(hitbox):
	if Globals.final_fight_started or fight_started:
		pass
	else:
		fight_started = true
		$PlayerDetectionBox/CollisionShape2D.set_deferred("disabled", true)
		#Ludwig finds coots
		player.states.force_idle()
		$camera_transition.transition_camera2D($Player.get_camera(), $BossFightCamera)
		yield($camera_transition, "finished_transition")
		#yield(play_dialog("res://UI/Dialog/bossFight1.json"), "dialog_finished")
		yield(play_dialog(d1), "dialog_finished")
		
		var start = startingScene.instance()
		$UI.add_child(start)
		$AudioStreamPlayer.stop()
		yield(start,"scene_over")
		$UI/Life.hide()
		
		#Coots Shoots Ludwig
		coots.turn_and_shoot()
		yield(player,"hit")
		player.current_health += 1
		$UI/Life.show()
		player.emit_signal("life_changed", player.current_health)
		player.states.force_idle()
		
		#Controller Enters
		controller.idle()
		$Cutscenes.play("ControllerEntry")
		yield($Cutscenes, "animation_finished")
		$Cutscenes.play("ControllerFloat")
		#yield(play_dialog("res://UI/Dialog/bossFight2.json"), "dialog_finished")
		yield(play_dialog(d2), "dialog_finished")
		
		#Coots Paws at controller
		coots.walk_left_and_sit()
		yield(coots, "sat_down")
		#yield(play_dialog("res://UI/Dialog/bossFight3.json"), "dialog_finished")
		yield(play_dialog(d3), "dialog_finished")
		coots.can_paw = true
		coots._on_paw_timer_timeout()
		yield($Player, "progress")
		player.states.idle_right()

		
		#TESTING CODE
		"""controller.fight_stage = 1
		_update_stage(1)
		yield($Cutscenes,"animation_finished")
		yield($Cutscenes,"animation_finished")
		controller.fight_stage = 2
		_update_stage(2)
		yield(get_tree().create_timer(1),"timeout")
		controller.emit_signal("destroyed")
		player.states.idle_right()"""

func _update_stage(stage: int) -> void:
	match stage:
		1: 
			player.states.force_idle()
			coots.can_paw = false
			#yield(play_dialog("res://UI/Dialog/bossFight4.json"), "dialog_finished")
			yield(play_dialog(d4), "dialog_finished")
			Globals.final_fight_started = true
			coots.can_shoot = true
			$Cutscenes.play("stage2")
			yield($Cutscenes, "animation_finished")
			controller.enable_shield()
			$ControllerFloat.play("ControllerFloat")
			$Cutscenes.play("smilebot_entry")
			player.states.idle_right()
			$AudioStreamPlayer.stop()
			$AudioStreamPlayer.stream = coots_boss_battle_song
			yield($Cutscenes, "animation_finished")
			$AudioStreamPlayer.play()
			#$Platform1/LULW.CAN_SHOOT = true 
			$Platform2/LULW.CAN_SHOOT = true
			$Platform4/LULW.CAN_SHOOT = true
			#$Platform5/LULW.CAN_SHOOT = true
			coots.animations.play_backwards("Sitting_down")
			yield(coots.animations, "animation_finished")
			coots.start_walking_turned()
			coots._on_laser_timer_timeout()
		2:
			coots.can_shoot = false
			controller.disable_shield()
			controller.falling()
			$ControllerFloat.play("ControllerFall")
			yield($ControllerFloat,"animation_finished")
			coots.animations.play("Sitting_down")
			player.states.force_idle()
			#yield(play_dialog("res://UI/Dialog/bossFight5.json"), "dialog_finished")
			yield(play_dialog(d5), "dialog_finished")
			player.states.idle_right()
		3:
			controller.animations.play("Falling")
			$AudioStreamPlayer.stop()
			yield(controller.animations, "animation_finished")
			TransitionScreen.fade_white_to(endingScene)
			
		
