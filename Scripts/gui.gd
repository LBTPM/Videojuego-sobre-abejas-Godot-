extends CanvasLayer

var game_control
@onready var cantidad_polen: Label = $Panel_polen/Cantidad
@onready var cantidad_miel: Label = $Panel_miel/Cantidad
@onready var imagen: TextureRect = $Panel_miel/Imagen
@onready var cantidad_nectar: Label = $Panel_miel/Panel_nectar/Cantidad
const BOTON_MEJORAS = preload("res://Escenas/Boton_mejoras.tscn")
# Paneles
@onready var panel_mejoras_panal: Panel = $"Panel mejoras panal"
@onready var panel_mejoras_flor: Panel = $"Panel mejoras flor"
@onready var panel_mejoras_abeja: Panel = $"Panel mejoras abeja"

# Botones
@onready var mejoras_panal: Button = $"Mejoras panal"
@onready var mejoras_flor: Button = $"Mejoras flor"
@onready var mejoras_abeja: Button = $"Mejoras abeja"
#Boton panal
@onready var boton_añadir_panal: Button = $"Panel mejoras panal/Boton_añadir_panal"

var coste := 0
var c_panales := 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()
	boton_añadir_panal.set_coste(str(coste))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cantidad_polen.text = str(_get_polen_total())
	cantidad_miel.text = str(_get_miel_total())
	cantidad_nectar.text = str(game_control._get_nectar_total())
	
	if c_panales >= 4:
		boton_añadir_panal.visible = false
		boton_añadir_panal.disabled = true
	
	#Funcionamiento boton
	if coste <= game_control._get_miel_total():
		boton_añadir_panal.set_disabled(false)
	else:
		boton_añadir_panal.set_disabled(true)
	

func anim_miel(valor:bool):
	imagen.gen_miel = valor

func _get_polen_total():
	return game_control._get_polen_total()
	
func _get_miel_total():
	return game_control._get_miel_total()

func gastar_miel(valor):
	game_control.gastar_miel(valor)


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


func _on_boton_añadir_panal_pressed() -> void:
	var nuevo_boton = BOTON_MEJORAS.instantiate()
	coste += 20
	boton_añadir_panal.set_coste(str(coste))
	nuevo_boton.position = Vector2(10,10)
	nuevo_boton.position.y +=c_panales*60
	game_control.nuevo_panal()
	nuevo_boton.texto = "Panal " + str(c_panales) #Cambiar
	panel_mejoras_panal.add_child(nuevo_boton)
	boton_añadir_panal.position.y += 60
	
