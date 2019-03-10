extends Area2D

var gravity_force = 0
var gravity_vector = Vector2(0,0)
var gravity_angle = 0

var velocity = Vector2(0,0)
var speed     = 20

var fired = false

onready var blackhole = get_node("/root/Game/Blackhole")


func fire(direction_vec):
	velocity = direction_vec * speed
	fired = true
	set_physics_process(true)
	
func _physics_process(delta):
	if fired:
		gravity_angle = position.angle_to_point(blackhole.position)
		gravity_force = blackhole.MASS / global_position.distance_squared_to(blackhole.position)	
		gravity_vector = Vector2(cos(gravity_angle), sin(gravity_angle))
		velocity -= gravity_vector * gravity_force
		rotation = gravity_angle - PI / 2
		
		position += (velocity * speed * delta)
		
		if position.x > 1000 or position.x < -1000 or position.y > 1000 or position.y < -1000:
			queue_free()

func _on_Bullet_body_entered(body):
	body.explode()
	queue_free()
	
func _on_Bullet_area_entered(area):
	queue_free()
	if area.is_in_group("Shield"):
		area.get_parent().get_node("ShieldHitSfx").play()
