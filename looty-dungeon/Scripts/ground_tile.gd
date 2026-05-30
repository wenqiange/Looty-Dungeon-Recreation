extends StaticBody3D

@onready var nav_reg: NavigationRegion3D = $NavigationRegion3D

@export var Nav_front = true
@export var Nav_back = true
@export var Nav_left = true
@export var Nav_right = true

#dectec if has object
func _ready() -> void:
	pass
	#$NL_F.enabled = Nav_front
	#$NL_B.enabled = Nav_back
	#$NL_L.enabled = Nav_left
	#$NL_R.enabled = Nav_right
