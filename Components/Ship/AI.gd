extends Object

var ship
var bullets
var game

var actions = {}

var waiting_cooldown = 0
var decision_cooldown = 0.2
var rotation_cooldown = 0
var rotation_target
var rotating = false
var target_decision_cooldown = 0.2


func _init(controlled_ship, played_game):
	
	if Stats.round_no <= 3:
		decision_cooldown = 0.3
	if Stats.round_no >= 3 and Stats.round_no <= 10:
		decision_cooldown = 0.2
	if Stats.round_no > 10:
		decision_cooldown = 0.01
	if Stats.round_no == 1:
		decision_cooldown = 0.4
		
	target_decision_cooldown = decision_cooldown
	
	ship = controlled_ship
	game = played_game
	bullets = ship.get_node("/root/Game/Bullets")
	
	
func process(delta):
	if ship.dead:
		return
		
	if waiting_cooldown > 0:
		waiting_cooldown -= delta
	
	if rotation_cooldown > 0:
		rotation_cooldown -= delta
		if rotation_cooldown <= 0:
			release('left')
			release('right')
		
	if decision_cooldown > 0:
		decision_cooldown -= delta
	else:
		decision_cooldown = target_decision_cooldown
		calculate_actions(delta)
	
		if is_action_just_pressed("shield") and ship.shield_power > 0:
			ship.raise_shield()
				
		if is_action_just_released('shield'):
			ship.lower_shield()
			
				
		if !ship.shield_raised and is_action_just_pressed("fire"):
			ship.fire()
				
		reset_actions()

	if is_action_pressed("left"):
		ship.rotation -= 2 * PI * delta
				
	if is_action_pressed("right"):
		ship.rotation += 2 * PI * delta
	

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
	if ship.dead:
		return
		
	var taken_action = null
	var safe_space = true
	
	for bullet in bullets.get_children():
		if abs(ship.position.distance_to(bullet.position)) < 80 + (randi() % 50):
			safe_space = false
			press('shield')
			
	if safe_space and actions.has('shield'):
		release('shield')
	
	if safe_space:	
		random_attacking_maneuvr()
	
func random_rotation():
	rotation_cooldown = rand_range(0.3, 1)
	if randi() % 2 == 0:
		press('left')
	else:
		press('right')

func random_attacking_maneuvr():
	if waiting_cooldown > 0:
		return
		
	var action_no = randi() % 4
	
	if action_no < 2:
	  press('fire')
	
	if action_no == 2:
		random_rotation()
		
	if action_no == 3:
		waiting_cooldown = 2
		
	