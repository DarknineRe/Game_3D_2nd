class_name BossHPbar
extends TextureProgressBar

@export var iframe := false
@export var timer2 := 1.0
@export var HPnode : Health

@onready var timer = $Timer
@onready var hp = HPnode.health

var player : Player = get_owner()

func _ready() -> void:
	HPnode.health_changed.connect(change_health)
	init_health(hp)

func change_health(HP: float) -> void:
	_set_health(HP)

func _set_health(new_hp: float) -> void:
	hp = clamp(new_hp, 0, HPnode.max_health)

	max_value = HPnode.max_health
	value = hp

func init_health(_hp: int) -> void:
	hp = _hp
	max_value = _hp
	value = _hp
