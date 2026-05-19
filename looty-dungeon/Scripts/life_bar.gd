class_name LifeBar
extends TextureRect

func setLives(num_lives:int):
	if num_lives <= 0: hide()
	else: show()
	size.x = 8*num_lives
