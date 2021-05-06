extends Control

onready var label = $Label

func update_health_UI():
	label.text = "HP = " + str(PlayerStats.health)
	
func _ready():
	PlayerStats.connect("health_changed", self, "update_health_UI")
	label.text = "HP = " + str(PlayerStats.health)
