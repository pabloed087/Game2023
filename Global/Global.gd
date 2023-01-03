extends Node

#Holds the scene being changed to when calling change_scene_with_transition
var _target_scene:PackedScene = null

#Change the scene with a fancy transition! Might add positional parameter later.
func change_scene_with_transition(new_scene:PackedScene) -> void:
	#If the new_scene is valid
	if new_scene != null:
		#If busy transitioning
		if $SceneTransition.is_transitioning:
			#If the transition is still changable (doing black)
			if $SceneTransition.is_changable:
				#Change the target scene we're changing to
				_target_scene = new_scene
				pass
			pass
		#Not transitioning, safe to start.
		else:
			#Start the transition animation
			$SceneTransition.start_transition()
			#Cache the target scene
			_target_scene = new_scene
			pass
		pass
	pass

#Signal fires when the transition has fully covered the scene
func _on_SceneTransition_covered() -> void:
	#If the target scene is valid
	if _target_scene != null:
		#Change the scene (The transition will reveal automatically)
		get_tree().change_scene_to(_target_scene)
		#Reset the _target_scene variable
		_target_scene = null
		pass
