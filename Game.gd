extends Node2D

onready var shield1 = get_node("CanvasLayer/UI/Shield1/ProgressBar")
onready var shield2 = get_node("CanvasLayer/UI/Shield2/ProgressBar")

var paused = false
var game_over = false

func _ready():
	$Player2.controlled = Stats.player2
	actualize_score()
	$CanvasLayer/UI/Round.text = "ROUND  " + str(Stats.round_no)
	set_process_input(true)
	
func _input(event):
	if event is InputEventKey and event.is_action_pressed('ui_accept'):
		Stats.reset_score()
		get_tree().change_scene("res://Game.tscn")

	if event is InputEventKey and event.is_action_pressed('ui_cancel'):
		if game_over:
			to_menu()
		else:
			if paused:
				paused = false
				$CanvasLayer/UI/PauseMenu.hide()
			else:
				paused = true
				$CanvasLayer/UI/PauseMenu.show()
		

func score(player_number):
	Stats.score(player_number)
	actualize_score()
	$Timer.stop()
	$Timer.wait_time = 1
	$Timer.start()

func game_over():
	game_over = true
	
	if Stats.score[0] > Stats.score[1]:
		$CanvasLayer/UI/GameOver/Title.text = "PLAYER 1 WINS!"
		
	if Stats.score[1] > Stats.score[0]:
		if Stats.player2 == 2:
			$CanvasLayer/UI/GameOver/Title.text = "PLAYER 2 WINS!"
		if Stats.player2 == 0:
			 $CanvasLayer/UI/GameOver/Title.text = "HUMILIATING DEFEAT!"
	
	if Stats.score[1] == Stats.score[0]:
		 $CanvasLayer/UI/GameOver/Title.text = "A TIE?!"
	
	$CanvasLayer/UI/GameOver.show()

func to_menu():
	get_tree().change_scene("res://Menu.tscn")
	

func next_round():
	Stats.round_no += 1
	get_tree().change_scene("res://Game.tscn")

func actualize_score():
	var p2_label = "Player 2"
	if Stats.player2 == 0:
		p2_label = "A.I."
		
	$CanvasLayer/UI/Score.text = "PLAYER 1    " + str(Stats.score[0]) + " : " + str(Stats.score[1]) + "    " + p2_label

func _on_Timer_timeout():
	if (Stats.score[0] >= 5 or Stats.score[1] >= 5) and Stats.score[0] != Stats.score[1]:
		game_over()
	else:
		next_round()
	
func update_shield_indicator(player_number, new_value):
	if player_number == 1:
		shield1.value = new_value
		if new_value <= 0:
			$CanvasLayer/UI/Shield1.text = "SHIELD DEPLETED"
			
	if player_number == 2:
		shield2.value = 100 - new_value
		if new_value <= 0:
			$CanvasLayer/UI/Shield2.text = "SHIELD DEPLETED"

func _on_PauseButton_pressed():
	paused = false
	$CanvasLayer/UI/PauseMenu.hide()
	

func _on_Exit_pressed():
	to_menu()