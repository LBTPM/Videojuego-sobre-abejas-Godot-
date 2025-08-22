extends CanvasLayer

var game_control
@onready var cantidad_polen: Label = $Panel_polen/Cantidad
@onready var cantidad_miel: Label = $Panel_miel/Cantidad
@onready var imagen: TextureRect = $Panel_miel/Imagen
@onready var cantidad_nectar: Label = $Panel_miel/Panel_nectar/Cantidad

# Paneles
@onready var panel_mejoras_panal: Panel = $"Panel mejoras panal"
@onready var panel_mejoras_flor: Panel = $"Panel mejoras flor"
@onready var panel_mejoras_abeja: Panel = $"Panel mejoras abeja"

# Botones
@onready var mejoras_panal: Button = $"Mejoras panal"
@onready var mejoras_flor: Button = $"Mejoras flor"
@onready var mejoras_abeja: Button = $"Mejoras abeja"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cantidad_polen.text = str(_get_polen_total())
	cantidad_miel.text = str(_get_miel_total())
	cantidad_nectar.text = str(game_control._get_nectar_total())

func anim_miel(valor:bool):
	imagen.gen_miel = valor

func _get_polen_total():
	return game_control._get_polen_total()
	
func _get_miel_total():
	return game_control._get_miel_total()
	
func _add_miel_total(valor):
	game_control._add_miel_total(valor)


# Botones de paneles mejoras
func _on_mejoras_panal_toggled(toggled_on: bool) -> void:
	if toggled_on:
		panel_mejoras_panal.visible = true
		panel_mejoras_abeja.visible = false
		panel_mejoras_flor.visible = false
		mejoras_abeja.set_pressed_no_signal(false)
		mejoras_flor.set_pressed_no_signal(false)
	else:
		panel_mejoras_panal.visible = false

func _on_mejoras_flor_toggled(toggled_on: bool) -> void:
	if toggled_on:
		panel_mejoras_panal.visible = false
		panel_mejoras_abeja.visible = false
		panel_mejoras_flor.visible = true
		mejoras_abeja.set_pressed_no_signal(false)
		mejoras_panal.set_pressed_no_signal(false)
	else:
		panel_mejoras_flor.visible = false


func _on_mejoras_abeja_toggled(toggled_on: bool) -> void:
	if toggled_on:
		panel_mejoras_panal.visible = false
		panel_mejoras_abeja.visible = true
		panel_mejoras_flor.visible = false
		mejoras_panal.set_pressed_no_signal(false)
		mejoras_flor.set_pressed_no_signal(false)
	else:
		panel_mejoras_abeja.visible = false
