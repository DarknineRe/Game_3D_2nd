class_name Hitbox 
extends Area3D

signal damaged(attack: Attack)

func damage(attack: Attack):
	damaged.emit(attack)
