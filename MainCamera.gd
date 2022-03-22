extends Camera2D


var target
var speed = 400

func _physics_process(delta):
	if target != null:
		var target_dir = (target.position - self.position).normalized()
		var step = speed * target_dir * delta
		if target.position.distance_squared_to(position) < (position + step).distance_squared_to(position):
			position = target.position
		else:
			position += step
	
	
func _ready():
	Main.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
