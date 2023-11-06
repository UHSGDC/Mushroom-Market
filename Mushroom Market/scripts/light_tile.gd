extends PointLight2D


const MIN_ENERGY = 0.4

func _process(delta: float) -> void:
	energy = _get_energy()


func _get_energy() -> float:
	var frame: int = int(Time.get_ticks_msec() / 200.0 - 3.5) % 12

	if frame < 2:
		return 1.0
	elif frame < 6:
		return lerpf(1.0, MIN_ENERGY, (frame - 2) / 4.0)
	elif frame >= 6 and frame < 8:
		return MIN_ENERGY
	else:
		return lerpf(MIN_ENERGY, 1.0, (frame - 8) / 4.0)	
