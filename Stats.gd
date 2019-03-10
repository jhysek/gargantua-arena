extends Node

var score = [0, 0]
var round_no = 1
var player2 = 2

func reset_score():
	round_no = 1
	score = [0, 0]
	
func set_player2(number):
	player2 = number

func score(player_number):
	if player_number == 1:
		score[0] += 1

	if player_number == 2:
		score[1] += 1
