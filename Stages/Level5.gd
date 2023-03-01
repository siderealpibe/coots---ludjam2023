extends Node

onready var player = $Player
export(PackedScene) var dialogBoxScene : PackedScene
var d1 = '[  {"Name": "Ludwig", "Text":"This doesn\'t seem to be the right way"}]'
var nottherightway_counter = 0

func play_dialog(dialogPath):
	var dialog = dialogBoxScene.instance()
	dialog.set("dialog", dialogPath)
	$UI.add_child(dialog)
	return dialog
	
func _nottherightway():
	player.states.force_idle()
	yield(play_dialog(d1), "dialog_finished")
	player.states.idle_right()

func _on_nottherightway_area_entered(area):
	if  $Controller.get_child_count() == 1:
		nottherightway_counter += 1
		if nottherightway_counter > 2:
			_nottherightway()
