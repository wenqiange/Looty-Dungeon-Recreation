extends Label

func _on_coins_changed(total: int) -> void:
	text = str(total)
