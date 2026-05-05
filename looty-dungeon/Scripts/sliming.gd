extends Node

var slime:Enemy

const slime_path = "uid://n8gf0beh1tli"

func _process(_delta: float) -> void:
	if not slime:
		slime = get_parent() as Enemy
		slime.movement.finished_step.connect(on_step)

func on_step():
	var slm = preload(slime_path).instantiate()
	slm.position = slime.position
	slm.position.y -= 0.5
	slime.add_sibling(slm)
