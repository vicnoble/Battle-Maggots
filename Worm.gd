class_name Worm
extends KinematicBody2D

enum Direction {left, right}
var direction = Direction.right
var gravity = Main.gravity
var velocity = Vector2.ZERO
export var team = "Red"

export var worm_name = "Zuko"

onready var sprite = $icon
onready var health_label = $HealthLabel
onready var name_label = $HealthLabel/NameLabel
onready var arrow = $arrow

onready var grenade = $Grenade
onready var crosshair = $Grenade/cross_hair

onready var projectile = preload("res://weapons/Nade.tscn")

onready var ap = $AnimationPlayer

var raycasts = []


func fire():
	var nade = projectile.instance()
	get_tree().root.add_child(nade)
	nade.global_position = grenade.global_position
	
	#nade.look_at($Grenade/aim_point.position)	
	nade.angular_velocity = 10
	nade.apply_central_impulse (($Grenade/aim_point.global_position - global_position).normalized() * charge * 4 )
	charge = 0


var aim_angle = 0 setget aim_angle_set, aim_angle_get
var max_aim_angle = PI/2
var min_aim_angle = -PI/2

func aim_angle_set(new_angle):
	if new_angle > max_aim_angle:
		aim_angle = max_aim_angle
	elif new_angle < min_aim_angle:
		aim_angle = min_aim_angle
	else:
		aim_angle = new_angle
	update_aim_angle()
	
func aim_angle_get():
	return aim_angle

var charge = 0 setget charge_set, charge_get
var max_charge = 100

func charge_set(new_charge):
	if new_charge > max_charge:
		charge = max_charge
	elif new_charge < 0:
		charge = 0
	else:
		charge = new_charge
	
func charge_get():
	return charge

onready var state_machine = $StateMachine

export (int) var walk_speed = 120
export (Vector2) var jump_impulse = Vector2(80, 120)
export (int) var health := 100


var is_dead = false
var is_active = false setget is_active_set

func is_active_set(value: bool):
	is_active = value
	if value:
		arrow.show()
		crosshair.show()
	else:
		arrow.hide()
		crosshair.hide()

signal Skip()
signal Damaged(is_active)


func update_aim_angle():
	if direction == Direction.right:
		grenade.rotation = aim_angle
		grenade.scale.y = 1
		
	elif direction == Direction.left:
		grenade.rotation = -aim_angle -PI
		grenade.scale.y = -1


func ChangeDirection(new_direction):
		
	if new_direction == Direction.right:
		sprite.set_flip_h( false )
		direction = Direction.right
				
	elif new_direction == Direction.left:
		sprite.set_flip_h( true )
		direction = Direction.left
	
	update_aim_angle()


func _input(event):
	if is_active:
		if event.is_action_pressed("suicide"):
			ChangeHealth(health)
		if event.is_action_pressed("skip"):
			emit_signal("Skip")

func Die():
	is_dead = true
	
#	if team == "Red":
#		Main.reds.erase(self)
#	elif team == "Blue":
#		Main.blues.erase(self)
func ChangeHealth(damage):
	health -= damage
	emit_signal("Damaged")
	for i in 4:
		modulate.a = 0
		yield(get_tree().create_timer(.1), "timeout")
		modulate.a = 1.0
		yield(get_tree().create_timer(.1), "timeout")
	if health <= 0:
		Die()

#func _handle_input(delta):
#	velocity.x = 0
#	if (Input.is_action_pressed("up")):
#		pass
#	if (Input.is_action_pressed("right")):
#		velocity.x += speed 
#	elif (Input.is_action_pressed("left")):
#		velocity.x += -speed

#func is_on_floor():
#	for raycast in raycasts:
#		if raycast.is_colliding():
#			return true
#	return false




func _ready():
	name_label.text = worm_name
	if team == "Red":
		health_label.modulate = Color.red
		name_label.modulate = Color.red
		arrow.modulate = Color.red
		crosshair.modulate = Color.red
		Main.reds.append(self)
	elif team == "Blue":
		health_label.modulate = Color.blue
		name_label.modulate = Color.blue
		arrow.modulate = Color.blue
		crosshair.modulate = Color.blue
		Main.blues.append(self)



func _physics_process(delta):
	if !is_dead:
		health_label.text = health as String
	else:
		health_label.text = "RIP"
	$state.text = state_machine.state.name
#	_handle_input(delta)
#	velocity.y += gravity * delta
#	velocity = move_and_slide(velocity, Vector2.UP)
#	if Input.is_action_just_pressed("jump"):
#		if is_on_floor():
#			pass
