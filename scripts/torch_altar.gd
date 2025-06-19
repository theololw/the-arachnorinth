extends Node2D

var charge_left = 50

func _physics_process(delta: float) -> void:
	if $recharger.get_overlapping_areas() and charge_left > 0:
		if Global.electricity < 100:
			Global.electricity += 100 * delta
			charge_left -= 100 * delta
			$PointLight2D.energy = charge_left/200
