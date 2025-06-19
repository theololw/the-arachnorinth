extends Node2D

func _ready() -> void:
	Global.flamethrower_position = $flamethrower.global_position


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
