extends Node


const PANAL = preload("res://Escenas/Panal.tscn")
@export var max_panales := 4
@export var pos_panales : Array[Vector2] = [Vector2(12,48),Vector2(52,48)]
var c_panal := 1
var panales = []










func nuevo_panal():
	var n_panal = PANAL.instantiate()
	n_panal.position = pos_panales[c_panal]
	panales.append(n_panal)
	add_child(n_panal)
	c_panal += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nuevo_panal = PANAL.instantiate()
	nuevo_panal.position = pos_panales[0]
	panales.append(nuevo_panal)
	add_child(nuevo_panal)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
