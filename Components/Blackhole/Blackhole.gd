extends Area2D

func _on_Blackhole_body_entered(body):
	body.explode()