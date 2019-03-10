extends Node

var score = [0, 0]
var round_no = 1


func score(player_number):
	if player_number == 1:
		score[0] += 1

	if player_number == 2:
		score[1] += 1
