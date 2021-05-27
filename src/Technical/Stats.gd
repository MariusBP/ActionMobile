extends Node

export(int) var max_health = 100 setget set_max_health
export(int) onready var health = max_health setget set_health
export var knockback = 140
export var resistance = 200
export var weight = 1
export var speed = 100
export var acceleration = 300
export var friction = 200
export var damage = 20

signal no_health
signal health_changed(value)

func set_max_health(value):
	max_health = max(value, 1)

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
