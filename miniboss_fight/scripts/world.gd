extends Node3D

@onready var player: Node3D = $player
@onready var respawn_point = $Player_Spawn_Point
@onready var boss_spawn_point: Marker3D = $Boss_Spawn_Point
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var health_box_scene: PackedScene = preload("res://scenes/health_box.tscn")
@export var spawn_area_size: Vector3 = Vector3(100, 0.5, 100)
@export var ground_y: float = 0.5
@export var max_boxes: int = 5 


func _ready():
	for i in range(2): 
		spawn_health_box()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		teleport_player(body)
	elif body.is_in_group("boss"):
		teleport_boss(body)


func teleport_player(player_node: Node3D) -> void:
	player_node.global_transform = respawn_point.global_transform

func teleport_boss(boss_node: Node3D) -> void:
	boss_node.global_transform = boss_spawn_point.global_transform

func _on_spawn_timer_timeout() -> void:
	spawn_health_box()


func spawn_health_box():
	var box = health_box_scene.instantiate()
	add_child(box) 

	var x = randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2)
	var z = randf_range(-spawn_area_size.z / 2, spawn_area_size.z / 2)
	var y = ground_y + 0.5

	box.global_transform.origin = Vector3(x, y, z)
