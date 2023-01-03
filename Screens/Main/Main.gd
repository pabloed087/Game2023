extends Control

#The scene that the play button opens
export(PackedScene) var play_scene

func _on_PlayButton_pressed() -> void:
	#Trigger custom scene transition
	Global.change_scene_with_transition(play_scene)
	pass
