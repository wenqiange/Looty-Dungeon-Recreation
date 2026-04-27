extends Node

enum direction {UP,DOWN,LEFT,RIGTH}

func vec_to_dir(vec:Vector2):
	if abs(vec.x) >= abs(vec.y):
		if sign(vec.x) >= 0 : return direction.RIGTH
		else: return direction.LEFT
	else:
		if sign(vec.y) >= 0: return direction.UP
		else: return direction.DOWN

func dir_to_vec(dir:direction):
	match dir:
		direction.UP:
			return Vector2(0,1)
		direction.DOWN:
			return Vector2(0,-1)
		direction.LEFT:
			return Vector2(-1,0)
		direction.RIGTH:
			return Vector2(1,0)
