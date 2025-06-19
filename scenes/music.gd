extends Node
var playing_insane_music = false
var playing_normal_music = false

func _process(delta: float) -> void:
	if Global.has_flamethrower == false:
		$"EPIC MUSIC".stop()
		if $"boring music".playing == false:
			$"boring music".play()
	
	if Global.has_flamethrower:
		$"boring music".stop()
		if $"EPIC MUSIC".playing == false:
			$"EPIC MUSIC".play()
