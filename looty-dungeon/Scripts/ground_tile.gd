extends StaticBody3D

@onready var nav_reg: NavigationRegion3D = $NavigationRegion3D


#dectec if has object
func _ready() -> void:
	for c in get_children():
		if c is StaticBody3D:
			disable()
			break

func disable():
	nav_reg.enabled = false
