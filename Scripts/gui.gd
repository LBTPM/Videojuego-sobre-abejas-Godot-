extends CanvasLayer

var game_control
@onready var cantidad_polen: Label = $Panel_polen/Cantidad
@onready var cantidad_miel: Label = $Panel_polen2/Cantidad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cantidad_polen.text = str(game_control._get_polen_total())
	cantidad_miel.text = str(game_control._get_miel_total())
