extends Node

export var max_health = 100
export(int) onready var health = max_health setget set_health
export var knockback = 140
export var resistance = 200
export var weight = 1
export var speed = 100
export var acceleration = 20
export var friction = 20

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
