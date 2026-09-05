extends CanvasLayer

@onready var celdas: TileMapLayer = $Celdas


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	celdas.set_cell(Vector2i(0,0),1,Vector2i(0,0),0)
	for x in range(1,7):
		celdas.set_cell(Vector2i(x,0),1,Vector2i(1,0),0)
		celdas.set_cell(Vector2i(-x,0),1,Vector2i(2,0),0)
		celdas.set_cell(Vector2i(0,x),1,Vector2i(0,1),0)
		celdas.set_cell(Vector2i(0,-x),1,Vector2i(1,1),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_cerrar_panal_button_up() -> void:
	visible = false
