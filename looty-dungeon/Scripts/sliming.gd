extends Node

var slime:Enemy

const slime_path = "uid://6c1gdumh0lvv"

func _process(_delta: float) -> void:
	if not slime:
		slime = get_parent() as Enemy
		slime.movement.finished_step.connect(on_step)

func on_step():
	$SlimeSound.play()
	#check no slime
	var space = slime.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(slime.position+Vector3.UP,slime.position+Vector3.DOWN,32)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space.intersect_ray(query)
	if result: return
	
	var slm = preload(slime_path).instantiate()
	slm.position = slime.position
	slm.position.y -= 0.5
	slime.add_sibling(slm)
