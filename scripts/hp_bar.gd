class_name HPbar
extends ProgressBar

@export var iframe := false
@export var timer2 := 1.0
@export var HPnode : Health

@onready var timer = $Timer
@onready var damgae_bar = $DamageBar
@onready var hp = HPnode.health

var player : Player = get_owner()

func _ready() -> void:
	HPnode.health_changed.connect(change_health)
	HPnode.iframe_started.connect(_on_iframe_start)
	HPnode.iframe_ended.connect(_on_iframe_end)
	init_health(hp)

func change_health(HP: float) -> void:
	_set_health(HP)

func _set_health(new_hp: float) -> void:
	var prev_hp = hp
	hp = clamp(new_hp, 0, HPnode.max_health)

	# Update bar max values when max health changes
	max_value = HPnode.max_health
	damgae_bar.max_value = HPnode.max_health

	# Set current values
	value = hp
	damgae_bar.value = min(damgae_bar.value, hp)

	var hp_percent = float(hp) / max_value

	# Get the shared style
	var fill_style = get("theme_override_styles/fill")
	if fill_style:
		fill_style = fill_style.duplicate()
		set("theme_override_styles/fill", fill_style)

	# Change color based on hp %
	if hp_percent <= 0.2:
		fill_style.bg_color = Color.RED
	elif hp_percent <= 0.5:
		fill_style.bg_color = Color.YELLOW
	else:
		fill_style.bg_color = Color.LIME

	# Damage animation
	if hp < prev_hp:
		timer.start()
	else:
		damgae_bar.value = hp

func init_health(_hp: int) -> void:
	hp = _hp
	max_value = _hp
	value = _hp
	damgae_bar.max_value = _hp
	damgae_bar.value = _hp

func _on_timer_timeout() -> void:
	damgae_bar.value = hp

func _on_iframe_start():
	iframe = true 

func _on_iframe_end():
	iframe = false
