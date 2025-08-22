extends Control

@export var max_nivel = 5
@export var obj_nivel : PackedScene
@export var coste := 2
@export var texto := "Objeto X"
@onready var button: Button = $Button
@onready var label_nombre: Label = $Panel/Label

var gui_control
var nivel_actual = 0

func _ready() -> void:
	gui_control = get_parent().get_parent()
	button.set_coste(str(coste))
	label_nombre.text = texto

func _process(delta: float) -> void:
	if coste <= gui_control._get_miel_total():
		button.set_disabled(false)
	else:
		button.set_disabled(true)
		
func _on_button_pressed() -> void:
		var sig_nivel = obj_nivel.instantiate()
		nivel_actual += 1
		
		gui_control._add_miel_total(-coste)
		
		sig_nivel.position = button.position
		add_child(sig_nivel)
		print(str(nivel_actual))
		sig_nivel.set_text(str(nivel_actual))
		button.position.x += 60
		coste += 10
		button.set_coste(str(coste))
 
