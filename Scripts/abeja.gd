extends Area2D
#Variables
	#Variables Hijos
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D #Su Sprite animado
@onready var animation: AnimationPlayer = $AnimationPlayer #Controlador de animaciones
@onready var timer_polin: Timer = $timer_polin #Temporizador para el tiempo que dura una polinización

@onready var timer_panal: Timer = $timer_panal #Temporizador para tiempo en el panal

	#Variables vuelo
@export var velocidad: float = 10 #Velocidad de vuelo
var tol_final: float = 0.1 #Tolerancia de llegada al destino (si no da problemas al llegar)
@export var min_vuelo := 2 #Minima cantidad de puntos a los que volará antes de ir a una flor
@export var max_vuelo: int = 10 #Maxima =
@export var prob_min_volver := 50 #Minimo de nectar necesario para que pueda volver

	#Variables polinización
@export var polin_time := 3#Tiempo que tarda en polinizar
@export var max_nectar_dar := 25 #Maximo de nectar que puede recoger
@export var min_nectar_dar := 5 #Minimo =
@export var max_polen_dar := 10 #Maximo de polen que puede recoger
@export var min_polen_dar := 5 #Minimo = 

	#Estados
enum Estados {PANAL = 0,VOLAR = 1,POLIN = 2}

	# Variables movimiento
var destino : Vector2 #Punto al que se dirige en un momento dado
var estado_actual = Estados.VOLAR #Estado en el que se encuentra
var estado_anterior = Estados.PANAL #Estado anterior
var dir #Dirección a la que se dirige (se calcula como destino - posicion)
var pos_polen = [] #Vector de posiciones de las zonas de polen
var pos_planta_pol #Posición de la zona de polen a la que se dirige
var pos_panal : Vector2 #Posición de su panal
var c_nodos := 1 # ?? 
var volver : bool = false #Booleano que indica si tiene que volver al panal

	#Variables polen
@export var polen_max := 50 #Maximo polen
var polen := 0: set = _set_polen, get = _get_polen #Polen actual

	#Variables nectar
@export var nectar_max := 100 #Maximo nectar
var nectar := 0: set = _set_nectar, get = _get_nectar #Nectal actual


#Funciones

	#Funciones polen
func _set_polen(valor):
	polen = clamp(valor,0, polen_max)
func _add_polen(valor): #Añade al polen actual pero sin saltarse el maximo
	polen = clamp(polen + valor,0, polen_max)
func _get_polen(): #Devuelve la cantidad de polen
		return polen

	#Funciones nectar
func _set_nectar(valor):
	nectar = clamp(valor,0, nectar_max)
func _add_nectar(valor): #Añade al nectar actual pero sin saltarse el maximo
	nectar = clamp(nectar + valor,0, nectar_max)
func _get_nectar(): #Devuelve la cantidad de nectar
		return nectar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destino = position
	dir = destino - position
	pos_panal = get_parent().position
	timer_polin.wait_time = polin_time
	timer_panal.wait_time = 10
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match estado_actual: #Maquina de estados 
		Estados.VOLAR: #Entra cada vez que vuela, al salir del panal y al terminar de polinizar una flor
			if estado_anterior != Estados.VOLAR: #Se activa la primera vez que entra al estado
				animated_sprite_2d.play("volar")
				pos_planta_pol = pos_polen[randi_range(0,len(pos_polen)-1)] #Asigna la planta a la que se va a ir 
				c_nodos = randi_range(min_vuelo,max_vuelo)
				estado_anterior = Estados.VOLAR
				
			if c_nodos > 0: #Movemos de forma aleatoria hasta que completemos c_nodos
				if mover_aleatorio(delta): c_nodos -=1 
			else:
				if c_nodos == 0: #calcula la dirección solo la primera vez
					calculo_dir(pos_planta_pol - pos_panal) #Vuela hacia la planta escogida
					c_nodos = -1
				position += dir*delta*velocidad
			
		Estados.PANAL: 
			if estado_anterior != Estados.PANAL:  #Se activa la primera vez que entra al estado
				c_nodos = randi_range(min_vuelo,max_vuelo)
				volver = false
				estado_anterior = Estados.PANAL
			if c_nodos > 0:
				if mover_aleatorio(delta): c_nodos -=1
			else:
				calculo_dir(Vector2(0,-2))
				position += dir*delta*velocidad

		Estados.POLIN:
			if estado_anterior != Estados.POLIN:  #Se activa la primera vez que entra al estado
				timer_polin.start()
				animation.play("Polinizando")
				estado_anterior = Estados.POLIN
			
#Calcula la dirección a la que se tiene que mover la abeja a partir de su nuevo destino	
func calculo_dir(n_destino: Vector2):
	destino = n_destino 
	dir = (destino - position).normalized()
	var angulo = dir.angle()	
	rotation = angulo

#Mueve de manera aleatoria a la abeja
func mover_aleatorio(delta:float):
	var cambio = false
	if (position-destino).length() < tol_final:
		calculo_dir(Vector2(randf_range(10,100),randf_range(10,30))- pos_panal)
		cambio = true
	position += dir*delta*velocidad
	return cambio
	
#Escoge si vuelve basandose es la cantida de nectar que lleva la abeja
func probabilidad_volver():
	var prob = randi_range(0, _get_nectar())
	if prob >= prob_min_volver:
		volver = true

#Funcion que se activa al entrar en contacto con un area
func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_collision_layer() == 4 and c_nodos < 3: #Contacto con una planta
		#Recogiendo polen
		estado_actual = Estados.POLIN 
		var polen_rec = randi_range(min_polen_dar,max_polen_dar) #Variable que calcula el polen recogido
		var nectar_rec = randi_range(min_nectar_dar,max_nectar_dar) # = nectar = 
		polen_rec = min(polen_rec, area._get_polen()) #No dejamos que recoja mas de lo posible
		nectar_rec = min(nectar_rec, area._get_nectar()) #No dejamos que recoje mas de lo posible
		
		_add_polen(polen_rec) #Añadimos el polen a la abeja y se lo quitamos a la flor
		area._add_polen(-polen_rec)
		_add_nectar(nectar_rec) #Añadimos el nectar a la abeja y se lo quitamos a la flor
		area._add_nectar(-nectar_rec)
		
	elif area.get_collision_layer() == 1 and area.is_ancestor_of(self) and estado_actual == Estados.PANAL: #Contacto con panal
		# Entregando polen, el panal se encarga de sacar el polen y el nectar
		visible = false
		animated_sprite_2d.play("default")
		timer_panal.start()

#Se activa al terminar de polinizar, hace que vuele o que vuelva al panal
func _on_timer_polin_timeout() -> void:
	animation.play("RESET")
	probabilidad_volver()
	if volver:
		estado_actual = Estados.PANAL
	else:
		estado_actual = Estados.VOLAR
	
#Funcion activada al terminar de estar en el panal
func _on_timer_panal_timeout() -> void:
	visible = true
	estado_actual  = Estados.VOLAR
