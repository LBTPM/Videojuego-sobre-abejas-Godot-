extends CanvasLayer

@onready var celdas: TileMapLayer = $"Panel mejoras panal/HBoxContainer/Panel/Celdas"
@onready var anadir_abeja: Button = $"Panel mejoras panal/HBoxContainer/Panel/Panel_miel/Añadir Abeja"
@onready var precio_abeja: Panel = $"Panel mejoras panal/HBoxContainer/Panel/Precio abeja"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if anadir_abeja.is_hovered():
		precio_abeja.visible = true
	else:
		precio_abeja.visible = false

func _on_cerrar_panal_button_up() -> void:
	visible = false
