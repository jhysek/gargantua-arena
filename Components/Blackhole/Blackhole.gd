extends Area2D

export var MASS = 20000


func _on_Blackhole_body_entered(body):
	body.explode()