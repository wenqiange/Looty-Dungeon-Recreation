class_name GroundSlime
extends Area3D

@onready var animator: AnimationPlayer = $AnimationPlayer

func _on_area_entered(area: Area3D) -> void:
	var body = area.get_parent()
	var movement:GridMovement
	if body is Player:
		movement = (body as Player).grid_movement
	elif body is Enemy:
		movement = (body as Enemy).movement
	else: return
	if movement.inmune_to && 1 == 1: return
	animator.play("slime_trap")
	
	movement.cur_effect = 1
	await movement.remove_slime
	movement.cur_effect = 0
	
	animator.play("slime_remove")
	await animator.animation_finished
	queue_free()
