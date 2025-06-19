extends Node2D


func _on_retry_pressed() -> void:
	Global.has_fire = false
	Global.is_hidden = false
	Global.has_flamethrower = false
	Global.electricity = 100
	Global.lifes_left = 1
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_from_start_pressed() -> void:
	Global.has_fire = false
	Global.is_hidden = false
	Global.has_flamethrower = false
	Global.electricity = 100
	Global.lifes_left = 1
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
