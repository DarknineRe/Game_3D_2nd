extends Area3D
class_name HealthBox

@export var heal_amount: float = 10.0

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is Player:
		body.health.heal(heal_amount)
		queue_free() 
