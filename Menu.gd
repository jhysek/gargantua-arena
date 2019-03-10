extends Node2D

var player2 = 0

func _ready():
	MusicPlayer.stop()

func _on_Button_pressed():
	$Click.play()
	Stats.reset_score()
	Stats.set_player2(player2)
	MusicPlayer.play()
	get_tree().change_scene("res://Game.tscn")

func _on_AI_pressed():
	$Click.play()
	player2 = 0
	$CanvasLayer/UI/Player2/HUMAN.pressed = false
	$CanvasLayer/UI/Player2/Controls.hide()
	
func _on_HUMAN_pressed():
	$Click.play()
	player2 = 2
	$CanvasLayer/UI/Player2/AI.pressed = false
	$CanvasLayer/UI/Player2/Controls.show()	

func _on_Button_mouse_entered():
	$Hover.play()