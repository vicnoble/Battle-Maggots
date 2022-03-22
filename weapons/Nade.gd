extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var damage = 40

onready var explosion = preload("res://Explosion.tscn")

onready var explosion_zone = $ExplosionZone

onready var explosion_radius = $ExplosionZone/CollisionShape2D.get_shape().get_radius()
# Called when the node enters the scene tree for the first time.
func _ready():
	Main.new_projectile(self)


func kaboom():
	
	AudioManager.play("res://Sounds/explosion.wav")
	var targets = explosion_zone.get_overlapping_bodies ()
	
	for t in targets:
		if t is TileMap:
			var tile_map : TileMap = t
			var cell_size = tile_map.cell_size
			
			var initial_cell_coordinates = global_position / cell_size
			var iccx : int = initial_cell_coordinates.x
			var iccy : int = initial_cell_coordinates.y
			
			print("initial " + initial_cell_coordinates.x as String  + " " + initial_cell_coordinates.y as String )
			print("posiion " + global_position.x as String + " " + global_position.y as String)
			print("radius " + explosion_radius as String)
			
			var radius = Vector2(explosion_radius, explosion_radius) / cell_size
			var rx : int = radius.x
			var ry : int = radius.y
			
			for i in range (iccx - rx - 1, iccx + rx + 1 ):
				for j in range (iccy - ry - 1, iccy + ry + 1 ):
					if global_position.distance_to(Vector2(i,j) * cell_size) < explosion_radius:
						tile_map.set_cell(i, j, -1)
						tile_map.update_bitmask_area(Vector2(i,j))
#		
		elif t.has_method("ChangeHealth"):
			t.ChangeHealth(damage)
			if t.state_machine.state.name != "die":
				t.state_machine.transition_to("air")
	
	
	var e = explosion.instance()
	get_tree().root.add_child(e)
	e.global_position = global_position
	
func _physics_process(delta):
	var time_left = $Timer.time_left as int + 1
	$Node2D/Label.text = time_left as String

	$Node2D.rotation = - rotation

func _on_Timer_timeout():
	kaboom()
	queue_free()
	pass # Replace with function body.
