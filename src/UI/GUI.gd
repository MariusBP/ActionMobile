extends MarginContainer

onready var HP_value = $HBoxContainer/Bars/Health/Count/Background/Number
onready var HP_bar = $HBoxContainer/Bars/Health/Gauge

func update_health_UI(value):
	HP_value.text = str(round(value))
	HP_bar.value = value
	
func _ready():
	var _error = PlayerStats.connect("health_changed", self, "update_health_UI")
	HP_value.text = str(round(PlayerStats.health))
	HP_bar.value = PlayerStats.health
