extends KinematicBody2D

class_name Enemy

onready var stats = $Stats
const BatDeathEffect = preload("res://src/Enemies/Bat/bat_death_effect.tscn")
 
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.resistance*delta)
	velocity = move_and_slide(velocity)

func on_death():
	var batDeathEffect = BatDeathEffect.instance()
	get_parent().add_child(batDeathEffect)
	batDeathEffect.set_offset(Vector2(0,-12))
	batDeathEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	velocity = area.knockback_vector * stats.knockback
	stats.health -= area.damage

func _on_Stats_no_health():
	on_death()
	queue_free()
