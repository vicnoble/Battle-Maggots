extends WormState

var highest_point = 0
export var fall_damage_distance = 64

func enter(msg := {}) -> void:
	highest_point = worm.position.y 
	var dir = -1
	if worm.direction == worm.Direction.right:
		dir = 1
	if msg.has("do_jump"):
		AudioManager.play("res://Sounds/Jump.wav")
		worm.velocity.y = - worm.jump_impulse.y
		worm.velocity.x = dir * worm.jump_impulse.x


func physics_update(delta: float) -> void:

	if worm.position.y  < highest_point: highest_point = worm.position.y
	worm.velocity.y += worm.gravity * delta
	
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
	
	worm.velocity = worm.move_and_slide(worm.velocity, Vector2.UP)

	if worm.is_on_floor():
		var fall_distance = abs(highest_point - worm.position.y) 
		if fall_distance > fall_damage_distance:
			worm.ChangeHealth((fall_distance - fall_damage_distance)/2)
#			if(worm.is_dead):
#				state_machine.transition_to("die")
#				return
		state_machine.transition_to("idle")
		
	if worm.position.y > 0:
		print("wtf")
		worm.Die()
	if(worm.is_dead):
		state_machine.transition_to("die")
