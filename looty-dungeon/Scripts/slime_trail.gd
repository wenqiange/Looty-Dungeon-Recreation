extends Area3D

@onready var hitbox_col: CollisionShape3D = $HitBox/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_entered(area: Area3D) -> void:
	if area.get_parent() is Slime: return
	animation_player.play("slime_trap")
	hitbox_col.disabled = false


func _on_hit_box_area_entered(area: Area3D) -> void:
	queue_free()
