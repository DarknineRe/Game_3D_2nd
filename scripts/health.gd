extends Node
class_name Health

signal health_changed(health: float)
signal iframe_started
signal iframe_ended

@export var max_health := 100.0
@export var iframe_time := 0.5     
@export_group("Link Node")
@export var hitbox : Hitbox

@onready var health := max_health
@onready var unit = get_owner()

var invincible := false       

func damaged(attack: Attack):
	if invincible or not unit.alive:
		return 

	health -= attack.damage
	health_changed.emit(health)

	_start_iframe()

	if health <= 0:
		health = 0
		unit.alive = false


func _start_iframe():
	invincible = true
	iframe_started.emit() 

	var t = get_tree().create_timer(iframe_time)
	t.timeout.connect(_end_iframe)


func _end_iframe():
	invincible = false
	iframe_ended.emit()

func heal(amount: float):
	if health <= 0 or not unit.alive:
		return

	health = clamp(health + amount, 0, max_health)
	health_changed.emit(health)
