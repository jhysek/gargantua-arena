extends KinematicBody2D

# Credits
# - music: Zefz on opengameart.org
# - music: Zander Noriega on opengameart.org (perpetial tension) https://twitter.com/codingobviously
# - sound effects: Unnamed (Viktor.Hahn@web.de), is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License. 
# - sfx: shield hit https://freesound.org/people/StormwaveAudio/
# - sfx: fire: Michel Baradari on openGameArt
# - sfx: https://freesound.org/people/MortisBlack/ shield depleted
# - sfx: shield raised: https://freesound.org/people/Misty_Audio/

 
var BLACKHOLE_MASS = 30000
var speed          = 10
var applies_gravity = false

export var velocity = Vector2(-40, 0)
export var recoil_force = 2
export var controlled = 0

var fire_cooldown = 0.5
var gravity_force = 0
var gravity_vector = Vector2(0,0)
var gravity_angle = 0

var aim_angle = 0
var shield_raised = false
var shield_power = 5
var dead = false 

var Bullet = load("res://Components/Bullet/Bullet.tscn")
var AI     = load("res://Components/Ship/AI.gd")
var ai 

onready var blackhole = get_node("/root/Game/Blackhole")
onready var game      = get_node("/root/Game")


func _ready():
	if controlled == 0:
		ai = AI.new(self, game)
		
	set_physics_process(true)
		
func _physics_process(delta):
	if game.paused:
		return
		
	if !applies_gravity:
		if abs(position.x - blackhole.position.x) < 10:
			applies_gravity = true 
	else:
		gravity_angle = position.angle_to_point(blackhole.position)
		gravity_force = blackhole.MASS / position.distance_squared_to(blackhole.position)	
		gravity_vector = Vector2(cos(gravity_angle), sin(gravity_angle))
		velocity -= gravity_vector * gravity_force
		
		if shield_raised and shield_power > 0:
			shield_power -= delta
			var ind_number = controlled
			if ind_number == 0:
				ind_number = 2
				
			game.update_shield_indicator(ind_number, shield_power / 5.0 * 100)
			if shield_power <= 0:
				$ShieldDepletedSfx.play()
				lower_shield()
		
		if controlled == 0:
			ai.process(delta)
			
		if controlled == 1:
			if Input.is_action_just_pressed("ui_up") and shield_power > 0:
			  raise_shield()
			
			if Input.is_action_just_released("ui_up"):
				lower_shield()
				
			if !shield_raised and Input.is_action_just_pressed("ui_down"):
				fire()
					
			if Input.is_action_pressed("ui_left"):
				rotation -= 2 * PI * delta
				
			if Input.is_action_pressed("ui_right"):
				rotation += 2 * PI * delta
				
		if controlled == 2:
			if Input.is_action_just_pressed("ui_shield_B") and shield_power > 0:
				raise_shield()
				
			if Input.is_action_just_released("ui_shield_B"):
				lower_shield()
			
			if !shield_raised and Input.is_action_just_pressed("ui_fire_B"):
				fire()
				
			if Input.is_action_pressed("ui_left_B"):
				rotation -= 2 * PI * delta
				
			if Input.is_action_pressed("ui_right_B"):
				rotation += 2 * PI * delta
			
	move_and_collide(velocity * speed * delta)
	
func raise_shield():
	if !dead and shield_power > 0 and !shield_raised:	
		$ShieldRaisedSfx.play()
		shield_raised = true
		$Shield.show()
		$Shield.monitoring = true
		$Shield.monitorable = true
	
func lower_shield():
	$ShieldRaisedSfx.stop()
	shield_raised = false
	$Shield.hide()
	$Shield.monitoring = false
	$Shield.monitorable = false
			
func explode():
	if !dead:
		dead = true
		$AnimationPlayer.play("Explode")
		get_node("/root/Game/Camera2D").shake(1, 30, 30)
		$ExplosionSfx.play()
	
		if controlled == 1:
			if game.has_node("Player2"):
				game.score(2)
		if controlled == 2 or controlled == 0:
			if game.has_node("Player1"):
				game.score(1)

	
func fire():
	if !dead:
		var bullet = Bullet.instance()
		get_node("/root/Game/Bullets").add_child(bullet)
		bullet.position = position -Vector2(cos(rotation), sin(rotation)) * 20
		bullet.fire(-Vector2(cos(rotation), sin(rotation)))
		$FireSfx.play()
		speed -= 0.2


func _on_ExplosionSfx_finished():
	queue_free()
	