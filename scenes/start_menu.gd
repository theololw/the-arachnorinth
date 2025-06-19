extends Node2D

func _ready() -> void:
	Global.player_position = Vector2(1,1)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/intro_cutscene.tscn")
