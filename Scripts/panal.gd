class_name Panal
extends Area2D

#Objetos con los que el panal va a trabajar
const ABEJA = preload("res://Escenas/abeja.tscn")
@onready var timer_miel: Timer = $Timer_miel #Timer para la producción de miel

#Variables visibles
@export var cant_nectar_para_miel: int = 50 #Cantidad necesaria de nectar para producir miel
@export var maximo_polen_celda: int = 100 #Maximo de polen por celda
@export var tiempo_miel: int = 20 #Tiempo que tarda en producirse la miel
@export var ml_miel_celda: int = 1 #Cantidad de miel que se produce en una celda
@export var max_celdas := 20 #Cantidad maxima de celdas que puede tener el panal
@export var max_abejas := 10 #Cantidad maxima de abejas que puede tener el panal
@export var celdas_ini := 10 #Celdas con las que empieza el panal
@export var cant_abj_ini := 3 #Cantidad de abejas con las que empieza el panal
# Posicion flores
var zonas_polen

# Variables
var cant_abj := 0 #Cantidad de abejas que tiene el panal
var game_control #Padre, para comunicarse con el resto de objetos
var pos_polen : Array[Vector2] #Array con las posiciones de las zonas_polen para pasarselo a las abejas
var celdas : Array[Celda] #Las celdas del panal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_control = get_parent()
	timer_miel.wait_time = tiempo_miel
	timer_miel.start()
	zonas_polen = get_node("../Zonas_polen").get_children()
	
	# Recoger posicion polen
	for x in zonas_polen:
		pos_polen.append(x.global_position)
	
	# Iniciar abejas
	for x in cant_abj_ini:
		añadir_abeja()
		
	# Crear celdas
	for x in celdas_ini:
		añadir_celda()

func _process(delta: float) -> void:
	if existe_miel_proc(): #Le dice a la gui si se esta produciendo miel
		game_control.gen_miel = true
	else:
		game_control.gen_miel = false
		
func guardar_polen(valor:int): #Guarda el polen en las celdas si hay hueco
	for x in celdas: #Metemos el polen primero en las que tienen estado polen y no estan llenas
		if valor > 0 and x.estado == x.estados.POLEN:
			valor = x._add_cantidad(valor) # _add_cantidad devuelve la diferencia
			x.mostrar()
	if valor > 0: #Si sigue quedando polen lo metemos en nuevas celdas hasta que no quede
		for x in celdas:
			if valor > 0 and x.estado == x.estados.VACIO:
				x.cambiar_tipo(x.estados.POLEN)
				valor = x._add_cantidad(valor)
				x.mostrar()
				
func guardar_nectar(valor:int):  #Guarda el nectar en las celdas si hay hueco
	for x in celdas:
		if valor > 0 and x.estado == x.estados.NECTAR:
			valor = x._add_cantidad(valor)
			x.mostrar()
	if valor > 0:
		for x in celdas:
			if valor > 0 and x.estado == x.estados.VACIO:
				x.cambiar_tipo(x.estados.NECTAR)
				valor = x._add_cantidad(valor)		
				x.mostrar()		

func gastar_miel(valor)-> int: #Gasta la miel que se le dice, solo funciona cuando se gasta la cantidad justa, cambiar
	for x in celdas:
		if x.estado == x.estados.MIEL and valor > 0:
			x.reiniciar()
			valor -= ml_miel_celda
	return valor
	
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
		if x.estado == x.estados.MIEL:
			c_miel +=1
	return c_miel
	
func cantidad_polen()-> int: #Devuelve la cantidad de polen en el panal
	var c_polen = 0
	for x in celdas:
		if x.estado == x.estados.POLEN:
			c_polen += x._get_cantidad()
	return c_polen

func existe_miel_proc()-> bool: #Devuelve True si alguna de las celdas esta produciendo miel
	var existencia = false
	for x in celdas:
		if x.estado == x.estados.NECTAR and x._get_cantidad() == x.almacen_max:
			existencia = true
	return existencia

func añadir_celda(): #Añade una celda al panal si no superan la cantidad máxima
	if len(celdas) <= max_celdas:
		var nueva_celda = Celda.new()
		nueva_celda.iniciar(cant_nectar_para_miel,maximo_polen_celda)
		celdas.append(nueva_celda)
		
func añadir_abeja(): #Añade una nueva abeja al panal
	if cant_abj < max_abejas:
		var abeja = ABEJA.instantiate()
		abeja.visible = true
		abeja.position = Vector2(0,-2)
		abeja.pos_polen = pos_polen
		add_child(abeja)
		cant_abj += 1

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	
	if self.is_ancestor_of(area): #Cuando la entrada al panal toca una abeja del panal guardamos su polen
		guardar_polen(area._get_polen())
		guardar_nectar(area._get_nectar())
		area._set_polen(0)
		area._set_nectar(0)



func _on_timer_miel_timeout() -> void: #Al terminar el temporizador de miel se ha producido miel
	for x in celdas:
		if x.estado == x.estados.NECTAR and x._get_cantidad() == x.almacen_max:
			x.cambiar_tipo(x.estados.MIEL)
			x.mostrar()
