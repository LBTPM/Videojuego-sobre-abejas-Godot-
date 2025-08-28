class_name Panal
extends Area2D

const ABEJA = preload("res://Escenas/abeja.tscn")
@onready var timer_miel: Timer = $Timer_miel

@export var cant_nectar_para_miel: int = 50
@export var maximo_polen_celda: int = 100 
@export var tiempo_miel: int = 20
@export var ml_miel_celda: int = 1
@export var max_celdas := 10

# Posicion flores
var zonas_polen
var pos_polen : Array[Vector2]
var celdas : Array[Celda]

# Variables
var cant_abj: int = 3

var game_control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()
	timer_miel.wait_time = tiempo_miel
	timer_miel.start()
	zonas_polen = get_node("../Zonas_polen").get_children()
	
	# Recoger lugares polen
	for x in zonas_polen:
		pos_polen.append(x.global_position)
	
	# Iniciar abejas
	for x in cant_abj:
		var abeja = ABEJA.instantiate()
		abeja.visible = true
		abeja.position = Vector2(0,-2)
		abeja.pos_polen = pos_polen
		add_child(abeja)
		
	# Crear celdas
	for x in max_celdas:
		var nueva_celda = Celda.new()
		nueva_celda.iniciar(cant_nectar_para_miel,maximo_polen_celda)
		celdas.append(nueva_celda)
		
		
func guardar_polen(valor:int):
	for x in celdas:
		if valor > 0 and x.estado == x.estados.POLEN:
			valor -= x._add_cantidad(valor)
			x.mostrar()
	if valor > 0:
		for x in celdas:
			if valor > 0 and x.estado == x.estados.VACIO:
				x.cambiar_tipo(x.estados.POLEN)
				valor -= x._add_cantidad(valor)
				x.mostrar()
				
func guardar_nectar(valor:int):
	for x in celdas:
		if valor > 0 and x.estado == x.estados.NECTAR:
			valor -= x._add_cantidad(valor)
			x.mostrar()
	if valor > 0:
		for x in celdas:
			if valor > 0 and x.estado == x.estados.VACIO:
				x.cambiar_tipo(x.estados.NECTAR)
				valor -= x._add_cantidad(valor)		
				x.mostrar()		

func existe_miel_proc()-> bool:
	var existencia = false
	for x in celdas:
		if x.estado == x.estados.NECTAR and x._get_cantidad() == x.almacen_max:
			existencia = true
	return existencia

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	
	if self.is_ancestor_of(area):
		guardar_polen(area._get_c_polen_actual())
		guardar_nectar(area._get_nectar_actual())
		area._add_c_polen_actual(-area._get_c_polen_actual())
		area._add_nectar_actual(-area._get_nectar_actual())

func _process(delta: float) -> void:
	if existe_miel_proc():
		game_control.gen_miel = true
	else:
		game_control.gen_miel = false
	

func _on_timer_miel_timeout() -> void:
	for x in celdas:
		if x.estado == x.estados.NECTAR and x._get_cantidad() == x.almacen_max:
			x.cambiar_tipo(x.estados.MIEL)
