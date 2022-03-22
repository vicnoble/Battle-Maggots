extends WormState

func enter(_msg := {}) -> void:
	worm.ChangeHealth(0)
	worm.fire()
	worm.hide()
