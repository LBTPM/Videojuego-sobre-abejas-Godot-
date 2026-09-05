extends Node

@export var polen_total := 0: get = _get_polen_total
@export var miel_total := 0: get = _get_miel_total
@export var nectar_total := 0: get = _get_nectar_total, set = _add_nectar_total
@onready var gui: CanvasLayer = $GUI
const PANAL = preload("res://Escenas/Panal.tscn")
@export var max_panales := 4
@export var pos_panales : Array[Vector2] = [Vector2(12,48),Vector2(52,48)]
var c_panal := 1
var panales = []

var gen_miel: bool = false

# Funciones get set
func _get_polen_total():
	return polen_total

func _get_miel_total():
	return miel_total
	
func _get_nectar_total():
	return nectar_total
func _add_nectar_total(valor: int):
	nectar_total += valor

#Calculo de miel total
func calc_miel()-> int:
	var miel = 0
	for x in panales:
		miel += x.cantidad_miel()
	return miel

func calc_polen()-> int:
	var polen = 0
	for x in panales:
		polen += x.cantidad_polen()
	return polen

func gastar_miel(valor):
	for x in panales:
		if valor > 0:
			valor = x.gastar_miel(valor)
		
func gastar_polen(valor):
	for x in panales:
		if valor > 0:
			valor = x.gastar_polen(valor)

func nuevo_panal():
	var n_panal = PANAL.instantiate()
	n_panal.position = pos_panales[c_panal]
	panales.append(n_panal)
	add_child(n_panal)
	c_panal += 1
	gui.c_panales = c_panal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nuevo_panal = PANAL.instantiate()
	nuevo_panal.position = pos_panales[0]
	panales.append(nuevo_panal)
	add_child(nuevo_panal)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gen_miel	:
		gui.anim_miel(true)
	else:
		gui.anim_miel(false)
		
	miel_total = calc_miel()
	polen_total = calc_polen()
