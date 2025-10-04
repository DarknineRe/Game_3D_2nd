extends CharacterBody3D
class_name Player


var damage_attack = 10
var press_esc: bool = false
var double_jump: bool = true
var attack: bool = false
var alive: bool = true
@export var gravity: float = 20.0
@export var walk_speed: float = 5.0
@export var run_speed: float = 10.0
@export var sensitivity: float = 0.2

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera = $Camera3D
@onready var state_machine = animation_tree["parameters/playback"]
@onready var hp_bar: HPbar = $CanvasLayer/HpBar

@onready var health: Health = $Health
@onready var don_t: Node3D = $Don_T

func _ready() -> void:
	hp_bar.init_health(health.max_health)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation_tree.active = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !press_esc:
		rotation_degrees.y -= event.relative.x * sensitivity
		#camera.rotation_degrees.x -= event.relative.y * sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80.0 , 80.0)
	elif event.is_action_pressed("ui_cancel"):
		press_esc = !press_esc
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if press_esc else Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if health.health <= 0:
		return 

	var input_direction_2D = Input.get_vector("move_left","move_right","move_forward","move_back")
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	var direction = transform.basis * input_direction_3D
	
	var current_speed = walk_speed
	if Input.is_action_pressed("run"):
		current_speed = run_speed
	
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.5
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		attack = true
		state_machine.travel("Locomotion-Library_attack1")
		await animation_tree.animation_finished
		attack = false
	elif !is_on_floor() and !attack:
		state_machine.travel("Locomotion-Library_jump")
	elif Vector2(velocity.x, velocity.z).length() > 0.1 and !attack:
		state_machine.travel("Locomotion-Library_run" if Input.is_action_pressed("run") else "Locomotion-Library_walk")
	else:
		state_machine.travel("Locomotion-Library_idle1")

func damage(attack3: Attack) -> void:
	health.damaged(attack3)
	if health.health <= 0:
		die()

func die():
	alive = false
	print("Player is dead!")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://game_over.tscn")

func punch(body: Node3D):
	if body.is_in_group("boss"):
		var attack2 = Attack.new()
		attack2.damage = damage_attack
		body.damage(attack2)
