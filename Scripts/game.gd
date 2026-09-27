extends Node

#Variables dias
@onready var contador_de_días: Timer = $"Contador de días"
@export var tiempo_dias := 30

# Variables de panales
const PANAL = preload("res://Escenas/Panal.tscn")
@export var max_panales := 4
@export var pos_panales : Array[Vector2] = [Vector2(12,48),Vector2(52,48)]
var c_panal := 0
var panales = []

#Variables de mejoras
var mejoras_total: Array[Mejora] = []

func nuevo_panal(): #Añade un nuevo panal al juego
	var n_panal = PANAL.instantiate()
	n_panal.position = pos_panales[c_panal]
	n_panal.mejoras_activas = mejoras_total
	panales.append(n_panal)
	add_child(n_panal)
	c_panal += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mejoras_total = cargar_mejoras("res://Assets/Datos/Mejoras_abejas.txt")
	nuevo_panal()
	contador_de_días.wait_time = tiempo_dias
	contador_de_días.start()
	
	
func cargar_mejoras(path: String) -> Array:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("No se pudo abrir: " + path)
		return []
	
	file.get_csv_line()  # Saltar headers
	var items: Array[Mejora] = []
	while not file.eof_reached():
		var v := file.get_csv_line()
		if v.size() > 1:
			var mejora := Mejora.new()
			mejora.iniciar(v[0],v[1],v[2],v[3],v[4],v[5])
			items.append(mejora)
	file.close()
	return items   
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_contador_de_días_timeout() -> void:
	print("A pasado un día")
	for panal in panales:
		panal.consumir_noche()
