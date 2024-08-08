extends Node3D

func _ready():
	$ArcadeCar.active = true

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_focus_next"):
		$ArcadeCar.active = not $ArcadeCar.active
		$ArcadeMotorcycle.active = not $ArcadeMotorcycle.active
