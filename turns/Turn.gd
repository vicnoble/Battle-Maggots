# Virtual base class for all states.
class_name Turn
extends State

var is_active_state = false
# We store a reference to the state machine to call its `transition_to()` method directly.
var team = 'red'
var blue_index = 0
var red_index = 0

onready var timer = $Timer
var worm = null

func toggle_team():
	if team == 'red': team = 'blue'
	else: team = 'red'

func _ready():
	#yield(owner, "ready")
	randomize()
	if randi() % 2 == 1:
		team = 'red'
	else:
		team = 'blue'
	
	if not Main.reds or not Main.blues:
		yield(get_tree().create_timer(.5), "timeout")
	for w in Main.reds:
		w.connect("Skip", self, "EndTurn")
		w.connect("Damaged", self, "EndTurn")
	for w in Main.blues:
		w.connect("Skip", self, "EndTurn")
		w.connect("Damaged", self, "EndTurn")
	Main.turn = self
		
# All methods below are virtual and called by the state machine.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var reds = Main.reds
	var blues = Main.blues
	
	Main.charge.value = worm.charge
#	for w in blues:
#		w.is_active = false
#	for w in reds:
#		w.is_active = false
	
	worm.is_active = true	
	Main.camera.target = worm
	
	
	if !Main.CheckBlues():
		if !Main.CheckReds():
			state_machine.transition_to("Draw")
			return
		else:
			state_machine.transition_to("Red Wins")
			return
	if !Main.CheckReds():
		state_machine.transition_to("Blue Wins")
	var time_left = timer.time_left as int + 1
	if Main.ui_timer:
		Main.ui_timer.text = time_left as String


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Main.charge.show()
	
	is_active_state = true;
	toggle_team()
	timer.start()
	var reds = Main.reds
	var blues = Main.blues
	if team == 'red':
		worm = reds[red_index]
		IncRed()
	else:
		worm = blues[blue_index]
		IncBlue()

func EndTurn():
	if is_active_state:
		state_machine.transition_to("Aftermath")
func IncBlue():
	
	var new_blues =[]
	for w in Main.blues:
		if !w.is_dead:
			new_blues.append(w)
	Main.blues = new_blues
	
	blue_index += 1
	if blue_index >= Main.blues.size():
		blue_index = 0
		
func IncRed():
	
	var new_reds =[]
	for w in Main.reds:
		if !w.is_dead:
			new_reds.append(w)
	Main.reds = new_reds
	
	red_index += 1
	if red_index >= Main.reds.size():
		red_index = 0

func exit() -> void:
	Main.charge.hide()
	is_active_state = false
	if worm:
		worm.is_active = false
	worm = null
	timer.stop()


func _on_Timer_timeout():
	EndTurn()
