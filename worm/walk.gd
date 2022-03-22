extends WormState

# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#worm.ap.stop(true)
	worm.ap.play("walk")
	pass


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	
	worm.ap.play("idle")
	pass


func physics_update(delta: float) -> void:
	
	
	
	if not worm.is_on_floor():
		print("Transitioning to air")
		worm.velocity.x *= 0.4
		state_machine.transition_to("air")
		return

	if worm.is_active:
		var input_direction_x: float = (
			Input.get_action_strength("right")
			- Input.get_action_strength("left")
		)
		if input_direction_x > 0:
			worm.ChangeDirection(worm.Direction.right)
		
		if input_direction_x < 0:
			worm.ChangeDirection(worm.Direction.left)
		
		worm.velocity.x = worm.walk_speed * input_direction_x
		worm.velocity.y += worm.gravity * delta
		worm.velocity = worm.move_and_slide(worm.velocity, Vector2.UP)

		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to("air", {do_jump = true})
		elif is_equal_approx(input_direction_x, 0.0):
			state_machine.transition_to("idle")
	
	
	if(worm.is_dead):
		state_machine.transition_to("die")
