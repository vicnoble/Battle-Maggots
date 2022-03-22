# Virtual base class for all states.
class_name Aftermath
extends State

# We store a reference to the state machine to call its `transition_to()` method directly.
var is_active_state = false
onready var timer = $Timer

func _ready():
	if not Main.reds or not Main.blues:
		yield(get_tree().create_timer(.5), "timeout")
	for w in Main.reds:
		w.connect("Skip", self, "NewTurn")
		w.connect("Damaged", self, "AddTime")
	for w in Main.blues:
		w.connect("Skip", self, "NewTurn")
		w.connect("Damaged", self, "AddTime")
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	
	if Main.projectile != null:
		timer.paused = true
	else:
		timer.paused = false
	
	if !Main.CheckBlues():
		if !Main.CheckReds():
			state_machine.transition_to("Draw")
			return
		else:
			state_machine.transition_to("Red Wins")
			return
	if !Main.CheckReds():
		state_machine.transition_to("Blue Wins")

func enter(_msg := {}) -> void:
	is_active_state = true
	timer.start()
	Main.ui_timer.hide()
	pass



func exit() -> void:
	is_active_state = false
	timer.stop()
	Main.ui_timer.show()
	pass

func NewTurn():
	if is_active_state:
		state_machine.transition_to("Turn")


func AddTime():
	if is_active_state:
		pass

func _on_Timer_timeout():
	NewTurn()
