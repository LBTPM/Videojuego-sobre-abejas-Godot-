extends Node

@export var polen_total := 0: get = _get_polen_total, set = _add_polen_total
@export var miel_total := 0: get = _get_miel_total, set = _add_miel_total
@export var nectar_total := 0: get = _get_nectar_total, set = _add_nectar_total
@onready var gui: CanvasLayer = $GUI

var gen_miel: bool = false

func _get_polen_total():
	return polen_total
func _add_polen_total(valor: int):
	polen_total += valor

func _get_miel_total():
	return miel_total
func _add_miel_total(valor: int):
	miel_total += valor
	
func _get_nectar_total():
	return nectar_total
func _add_nectar_total(valor: int):
	nectar_total += valor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gen_miel	:
		gui.anim_miel(true)
	else:
		gui.anim_miel(false)
		
