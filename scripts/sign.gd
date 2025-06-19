extends Node2D

@export var text : String

func _ready() -> void:
	$CanvasLayer.hide()
	$CanvasLayer/Label.text = text


func _on_area_2d_area_entered(area: Area2D) -> void:
	$CanvasLayer.show()
func _on_area_2d_area_exited(area: Area2D) -> void:
	$CanvasLayer.hide()
