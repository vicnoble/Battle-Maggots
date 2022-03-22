extends Node2D

const gravity = 400
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera
var reds = []
var blues = []
var ui_timer

var draw
var red_victory
var blue_victory
var charge
var projectile
var turn

func new_projectile(nade):
	projectile = nade
	camera.target = nade
	turn.EndTurn()


func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	if event.is_action_pressed("restart"):
		blues = []
		reds = []
		get_tree().reload_current_scene()
		yield(get_tree().create_timer(0.1), "timeout")
		AudioManager.toggle_victory(false)
		
func CheckBlues():
	for worm in blues:
		if !worm.is_dead :
			return true
	return false
	
func CheckReds():
	for worm in reds:
		if !worm.is_dead :
			return true
	return false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
