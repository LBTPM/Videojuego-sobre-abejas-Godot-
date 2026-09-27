extends CanvasLayer

var game_control
@onready var cantidad_polen: Label = $Panel_polen/Cantidad
@onready var cantidad_miel: Label = $Panel_miel/Cantidad
@onready var cantidad_nutrientes: Label = $Panel_nutrientes/Cantidad


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func gastar_miel(valor):
	game_control.gastar_miel(valor)
