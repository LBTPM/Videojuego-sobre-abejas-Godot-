class_name Mejora extends Node

var id
var nombre : String
var icono : String
var precio := 10
var variable_mejorar : String
var c_mejora := 5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func iniciar(n_id, n_nombre, n_icono, n_precio, n_variable, n_mejora):
	id = n_id
	nombre = n_nombre
	icono = n_icono
	precio = int(n_precio)
	variable_mejorar = n_variable
	c_mejora = int(n_mejora)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
