extends Node2D

onready var shield1 = get_node("CanvasLayer/UI/Shield1/ProgressBar")
onready var shield2 = get_node("CanvasLayer/UI/Shield2/ProgressBar")

func _ready():
	actualize_score()
	$CanvasLayer/UI/Round.text = "ROUND  " + str(Stats.round_no)

func score(player_number):
	Stats.score(player_number)
	actualize_score()
	$Timer.start()

func next_round():
	Stats.round_no += 1
	get_tree().change_scene("res://Game.tscn")

func actualize_score():
	$CanvasLayer/UI/Score.text = "Player 1    " + str(Stats.score[0]) + " : " + str(Stats.score[1]) + "    Player 2"

func _on_Timer_timeout():
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