extends StaticBody2D

var HP = 100

func _on_Hurtbox_area_entered(_area):
	HP -= 50
	if HP <= 0:
		queue_free()
