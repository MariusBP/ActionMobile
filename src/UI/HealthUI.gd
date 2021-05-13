extends Control

onready var label = $Label

func update_health_UI(value):
	label.text = "HP = " + str(value)
	
func _ready():
	var _error = PlayerStats.connect("health_changed", self, "update_health_UI")
	label.text = "HP = " + str(PlayerStats.health)
