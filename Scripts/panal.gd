class_name Panal
extends Area2D

#Objetos con los que el panal va a trabajar
const ABEJA = preload("res://Escenas/abeja.tscn")
const CELDA = preload("uid://brq8wax12hb0e")


@onready var gui_panal: CanvasLayer = $GUI_panal

#Variables visibles
@export var cant_nectar_para_miel: int = 50 #Cantidad necesaria de nectar para producir miel
@export var maximo_polen_celda: int = 100 #Maximo de polen por celda
@export var tiempo_miel: int = 5 #Tiempo que tarda en producirse la miel
@export var ml_miel_celda: int = 1 #Cantidad de miel que se produce en una celda
@export var max_celdas := 19 #Cantidad maxima de celdas que puede tener el panal
@export var max_abejas := 10 #Cantidad maxima de abejas que puede tener el panal
@export var cant_abj_ini := 3 #Cantidad de abejas con las que empieza el panal
# Posicion flores
var zonas_polen

#Cantidad de elementos
var nectar = 0
var polen = 0
var miel = 0

# Variables generales
var cant_abj := 0 #Cantidad de abejas que tiene el panal
var game_control #Padre, para comunicarse con el resto de objetos
var pos_polen : Array[Vector2] #Array con las posiciones de las zonas_polen para pasarselo a las abejas
var celdas : Array #Las celdas del panal

# Variables nivel
@export var nivel_max := 5
var nivel := 1

var mejoras_inicial
var mejoras_activas : Array[Mejora] = []
var mejoras_compradas : Array[Mejora] = []

func _get_nivel():
	return nivel
	
func subir_nivel():
	if nivel < nivel_max:
		nivel+=1
		match nivel:
			2:
				max_celdas += 42
			3:
				max_celdas += 66
			4:
				max_celdas += 1
			_:
				print("Esto no es posible")

func get_cant_celdas():
	return celdas.size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()
	zonas_polen = get_node("../Zonas_polen").get_children()
	
	# Recoger posicion polen
	for x in zonas_polen:
		pos_polen.append(x.global_position)
	
	# Iniciar abejas
	for x in cant_abj_ini:
		añadir_abeja()
		
	# Crear celdas
	gui_panal.iniciar_celdas()

func _process(delta: float) -> void:
	pass
		
func guardar_polen(valor:int): #Guarda el polen en las celdas si hay hueco
	for x in celdas: #Metemos el polen primero en las que tienen estado polen y no estan llenas
		if valor > 0 and x.estado == x.estados.POLEN:
			valor = x._add_cantidad(valor) # _add_cantidad devuelve la diferencia
	if valor > 0: #Si sigue quedando polen lo metemos en nuevas celdas hasta que no quede
		for x in celdas:
			if valor > 0 and x.estado == x.estados.VACIO:
				x.cambiar_estado(x.estados.POLEN)
				valor = x._add_cantidad(valor)
				
func guardar_nectar(valor:int):  #Guarda el nectar en las celdas si hay hueco
	for x in celdas: 
		if valor > 0 and x.estado == x.estados.NECTAR:
			valor = x._add_cantidad(valor)
			x.comprobar_miel()
	if valor > 0:
		for x in celdas:
			if valor > 0 and x.estado == x.estados.VACIO:
				x.cambiar_estado(x.estados.NECTAR)
				valor = x._add_cantidad(valor)		
				x.comprobar_miel()

func gastar_miel(valor)-> int: #Gasta la miel que se le dice, solo funciona cuando se gasta la cantidad justa, cambiar
	valor = -valor #Vamos a usar el valor en negativo
	for x in celdas:
		if x.estado == x.estados.MIEL and valor < 0:
			valor = x._add_cantidad(valor)
			if x._get_cantidad() <= 0:
				x.reiniciar()
	return -valor
	
func gastar_polen(valor)-> int: #Gasta el polen que se le dice
	valor = -valor #Vamos a usar el valor en negativo
	for x in celdas:
		if x.estado == x.estados.POLEN and valor < 0:
			valor = x._add_cantidad(valor)
			if x._get_cantidad() <= 0:
				x.reiniciar()
	return -valor

func cantidad_miel()-> int: #Devuelve la cantidad de miel en el panal, solo funciona si la ml_miel = 1
	var c_miel = 0
	for x in celdas:
		if x.estado == x.estados.POLEN:
			c_miel += x._get_cantidad()
	return c_miel
	
func cantidad_polen()-> int: #Devuelve la cantidad de polen en el panal
	var c_polen = 0
	for x in celdas:
		if x.estado == x.estados.POLEN:
			c_polen += x._get_cantidad()
	return c_polen


func añadir_celda(coords : Vector2): #Añade una celda al panal si no superan la cantidad máxima
	if len(celdas) <= max_celdas:
		var nueva_celda = CELDA.instantiate()
		celdas.append(nueva_celda)
		add_child(nueva_celda)
		nueva_celda.iniciar(coords, cant_nectar_para_miel,maximo_polen_celda,ml_miel_celda,tiempo_miel)
		nueva_celda.cambio_celda.connect(_on_celda_cambio_celda)
		
func añadir_abeja(): #Añade una nueva abeja al panal
	if cant_abj < max_abejas:
		var abeja = ABEJA.instantiate()
		abeja.visible = true
		abeja.position = Vector2(0,-2)
		abeja.pos_polen = pos_polen
		add_child(abeja)
		cant_abj += 1

func aviso_celdas_max():
	return get_cant_celdas() == max_celdas


#Funciones de señales
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if self.is_ancestor_of(area): #Cuando la entrada al panal toca una abeja del panal guardamos su polen
		guardar_polen(area._get_polen())
		guardar_nectar(area._get_nectar())
		area._set_polen(0)
		area._set_nectar(0)

func _on_gui_boton_button_up() -> void:
	gui_panal.visible = true

func _on_gui_panal_celda_creada(coordenadas: Vector2) -> void:
	añadir_celda(coordenadas)

func _on_gui_panal_sub_nivel() -> void:
	subir_nivel()

func _on_celda_cambio_celda(coords,estado):
	gui_panal.cambiar_estado_celda(coords,estado)
