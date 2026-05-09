class_name HitBox
extends Area3D

@export var bounce_on_coll = true

@export var exceptions: Array[DamageArea]

signal got_hit

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area3D):
	if area is DamageArea:
		if exceptions.has(area as DamageArea): return
		got_hit.emit()
