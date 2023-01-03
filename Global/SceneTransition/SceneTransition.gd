extends CanvasLayer

#Fires when the transition fully covers the screen
signal covered
#Fires when the transition is done and the screen is fully visible
signal revealed

#Tracks if the transition is active
var is_transitioning:bool = false
#Tracks if the animation is still going dark (so we could swap the target scene if needed)
var is_changable:bool = false

#Start the transition animation
func start_transition() -> void:
	#Make the screen go black
	$AnimationPlayer.play("GoBlack")
	#Update variables
	is_transitioning = true
	is_changable = true
	pass

#Fires when an animation is complete
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	#If the animation was the "set to black" animation
	if(anim_name == "GoBlack"):
		#Start the timer to delay the reveal
		$BlackTimer.start()
		#Emit the signal
		emit_signal("covered")
		pass
	#If the animation was the "reveal the screen" animation
	elif(anim_name == "Reveal"):
		#Emit the signal
		emit_signal("revealed")
		#Update the variables
		is_transitioning = false
		is_changable = true
		pass
	pass

#Fires when the "black screen delay" timer runs out
func _on_BlackTimer_timeout() -> void:
	#Play the reveal animation
	$AnimationPlayer.play("Reveal")
	#Update variable
	is_changable = false
	pass
