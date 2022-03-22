class_name WormState
extends State

var worm: Worm


func _ready() -> void:
	yield(owner, "ready")
	worm = owner as Worm
	assert(worm != null)
