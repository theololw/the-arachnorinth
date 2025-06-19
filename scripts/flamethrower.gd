extends Node2D


func _on_flamethrower_area_entered(area: Area2D) -> void:
	Global.has_flamethrower = true
	queue_free()
