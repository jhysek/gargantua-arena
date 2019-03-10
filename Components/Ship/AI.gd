extends Object

var ship
var game

var decision_cooldown = 0.1

var rotation_target
var actions = {}

var bullets

func _init(controlled_ship, played_game):
	ship = controlled_ship
	game = played_game
	bullets = ship.get_node("/root/Game/Bullets")
	
	
func process(delta):
	if decision_cooldown > 0:
		decision_cooldown -= delta
	else:
		decision_cooldown = 0.2
		calculate_actions(delta)
	
		if is_action_just_pressed("shield") and ship.shield_power > 0:
			ship.raise_shield()
				
		if is_action_just_released('shield'):
			ship.lower_shield()
			
		if !ship.shield_raised and is_action_just_pressed("fire"):
			ship.fire()
			
				
		reset_actions()
	

func is_action_just_pressed(action):
	return actions.has(action) and actions[action] == 'just_pressed'
	
func is_action_just_released(action):
	return actions.has(action) and actions[action] == 'just_released'
	
func is_action_pressed(action):
	return actions.has(action) and actions[action] == 'pressed'
	
	
func reset_actions():
	for action in actions:
		if actions[action] == 'just_pressed':
			actions[action] = 'pressed'
		
		if actions[action] == 'just_released':
			actions[action] = null	
	
func press(action):
	actions[action] = 'just_pressed'

func release(action):
	actions[action] = 'just_released'


func calculate_actions(delta):
	var taken_action = null
	var safe_space = true
	
	for bullet in bullets.get_children():
		if abs(ship.position.distance_to(bullet.position)) < 120:
			safe_space = false
			press('shield')
			
	if safe_space and actions.has('shield'):
		release('shield')
	
	if safe_space:	
		random_attacking_maneuvr()
			

func random_attacking_maneuvr():
	var action_no = randi() % 10
	
	if action_no < 4:
	  press('fire')
	
	
	