extends WormState

# Virtual base class for all states.

# We store a reference to the state machine to call its `transition_to()` method directly.


func enter(_msg := {}) -> void:
	worm.velocity = Vector2.ZERO
	worm.grenade.show()


func physics_update(_delta: float) -> void:
	if not worm.is_on_floor():
		print("Transitioning to air")
		worm.velocity.x *= 0.4
		state_machine.transition_to("air")
		return
		
	if worm.is_active:
		
		if Input.is_action_pressed('up'):
			worm.aim_angle = worm.aim_angle - PI/180*3
		elif Input.is_action_pressed('down'):
			worm.aim_angle = worm.aim_angle + PI/180*3
			
		if Input.is_action_pressed('fire'):
			worm.charge = worm.charge + 1
		
		if Input.is_action_just_released("fire"):
			AudioManager.play('res://Sounds/Shoot1.wav')
			worm.fire()
			
		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to("air", {do_jump = true})
		elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			state_machine.transition_to("walk")
	
	
	if(worm.is_dead):
		state_machine.transition_to("die")



# All methods below are virtual and called by the state machine.
func handle_input(_event: InputEvent) -> void:
	pass

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	worm.grenade.hide()
	worm.charge = 0
	pass
