extends ItemList

signal item_hovered(index: int)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var index := get_item_at_position(event.position)

		if index >= 0:
			item_hovered.emit(index)
