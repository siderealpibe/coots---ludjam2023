extends Node2D

export(PackedScene) var NEXT_SCENE
export(NodePath) var PLAYER_PATH

onready var player : Player = get_node(PLAYER_PATH)

func _ready():
	$PlayerDetectionBox.connect("area_entered", self, "_exit_cutscene")

func _exit_cutscene(hitbox):
	player.end_stage()
	get_parent().add_child_below_node(player,self)
	$AnimationPlayer.play_backwards("Opening")
	yield($AnimationPlayer, "animation_finished")
	$AudioStreamPlayer.play()
	TransitionScreen.change_scene_to(NEXT_SCENE)
