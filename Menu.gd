extends Node2D

var player2 = 0


func _on_Button_pressed():
	Stats.reset_score()
	Stats.set_player2(player2)
	MusicPlayer.play()
	get_tree().change_scene("res://Game.tscn")

func _on_AI_pressed():
	player2 = 0
	$CanvasLayer/UI/Player2/HUMAN.pressed = false

func _on_HUMAN_pressed():
	player2 = 2
	$CanvasLayer/UI/Player2/AI.pressed = false