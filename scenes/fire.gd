extends Node2D

var fire_velocity

func _physics_process(delta: float) -> void:
	position += fire_velocity


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
