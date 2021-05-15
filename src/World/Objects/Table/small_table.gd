extends StaticBody2D

onready var hurtbox = $Hurtbox

var HP = 1

func _on_Hurtbox_area_entered(_area):
	HP -= 50
	hurtbox.create_hit_effect()
	if HP <= 0:
		queue_free()
