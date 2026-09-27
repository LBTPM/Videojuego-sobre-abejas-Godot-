extends ItemList

signal item_hovered(index: int)

var precio_item = []
var indice_mejora = []

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var index := get_item_at_position(event.position)
		if index >= 0:
			item_hovered.emit(index)

func comprobar_precios(miel, _polen): #Añadir el precio en polen 
	for i in range(item_count):
		if miel >= precio_item[i]:
			set_item_selectable(i, true)
			set_item_disabled(i, false)
		else: 
			set_item_selectable(i, false)
			set_item_disabled(i, true)

func quitar_mejora(indice):
	remove_item(indice)

func anadir_mejoras(mejoras):
	for mejora in mejoras:
		var link_icono = load("res://Assets/Sprites_abejas/" + mejora.icono)
		add_item(mejora.nombre + ": " + str(mejora.precio) ,link_icono,false)
		indice_mejora.append(mejora.id)
		set_item_disabled(item_count - 1, false)
		set_item_tooltip_enabled(item_count - 1, 0)
		precio_item.append(mejora.precio)
		
func get_item_index(index):
	var devolver = indice_mejora[index]
	indice_mejora.remove_at(index)
	precio_item.remove_at(index)
	return devolver
