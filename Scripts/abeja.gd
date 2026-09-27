extends Area2D
#Variables
	#Variables Hijos
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D #Su Sprite animado
@onready var animation: AnimationPlayer = $AnimationPlayer #Controlador de animaciones
@onready var timer_polin: Timer = $timer_polin #Temporizador para el tiempo que dura una polinización
@onready var timer_panal: Timer = $timer_panal #Temporizador para tiempo en el panal
@onready var timer_vida: Timer = $Timer_vida #Temporizador que muestra la cantidad de tiempo que vive la abeja
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D #Collision para poder recoger polen y entrar al panal

	#Variables vuelo
@export var velocidad: float = 10 #Velocidad de vuelo
@export var min_vuelo := 2 #Minima cantidad de puntos a los que volará antes de ir a una flor
@export var max_vuelo: int = 10 #Maxima =
@export var prob_min_volver := 50 #Minimo de nectar necesario para que pueda volver

	#Variables polinización
var polin_time := 3#Tiempo que tarda en polinizar
var panal_time := 10#Tiempo que tarda en polinizar
var max_nectar_recoger := 25 #Maximo de nectar que puede recoger
var min_nectar_recoger := 5 #Minimo =
var max_polen_recoger := 10 #Maximo de polen que puede recoger
var min_polen_recoger := 5 #Minimo = 


	#Estados
enum Estados {PANAL = 0,VOLAR = 1,POLIN = 2,MUERTE = 3}
var estado_actual = Estados.VOLAR #Estado en el que se encuentra
var estado_anterior = Estados.PANAL #Estado anterior
enum person {TRABAJADORA,GLOTONA,EXPLORADORA}

	# Variables movimiento
var destino : Vector2 #Punto al que se dirige en un momento dado
var dir #Dirección a la que se dirige (se calcula como destino - posicion)
var pos_polen = [] #Vector de posiciones de las zonas de polen
var pos_planta_pol #Posición de la zona de polen a la que se dirige
var pos_panal : Vector2 #Posición de su panal
var tol_llegada = 0.1
var volver = false

var c_nodos := 1 # Cantidad de nodos que visita antes de volver

	#Variables polen
@export var polen_max := 50 #Maximo polen
var polen := 0: set = _set_polen, get = _get_polen #Polen actual

	#Variables nectar
@export var nectar_max := 100 #Maximo nectar
var nectar := 0: set = _set_nectar, get = _get_nectar #Nectal actual

#Variables personalidad
var prob_trab = 50 #Probabilidad de ser trabajadora entre 0 y 97
var prob_glot = 10 #Probabilidad de ser glotona debe sumar 98 con el anterior como máximo, la otra probabilidad es complementaria
var personalidad = person.TRABAJADORA
var cant_comida := 3

#Variables vida
var media = 10
var desviacion = 1
var t_vida = randfn(media, desviacion)

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
	#Asignamos las variables para el movimiento
	destino = position
	dir = 0
	
	pos_panal = get_parent().position #Asignamos la posición del panal
	
	#Asignamos los temporizadores
	timer_polin.wait_time = polin_time
	timer_panal.wait_time = panal_time
	timer_vida.wait_time = t_vida
	
	#Iniciamos el tiempo de vida
	timer_vida.start()
	
	#Asignamos de forma aleatoria una personalidad a la abeja
	var pers_ale = randi()%100
	if pers_ale <= prob_trab:
		personalidad = person.TRABAJADORA
		cant_comida = 5
	elif pers_ale <= prob_trab + prob_glot:
		personalidad = person.GLOTONA
		cant_comida = 5
	else:
		personalidad = person.EXPLORADORA
		cant_comida = 5 
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match estado_actual: #Maquina de estados 
		Estados.VOLAR: #Entra al ir a polinizar una flor
			if estado_anterior != Estados.VOLAR: #Se activa la primera vez que entra al estado
				animated_sprite_2d.play("volar") #Iniciamos la animación de volar
				pos_planta_pol = pos_polen[randi_range(0,len(pos_polen)-1)] #Asigna aleatoriamente la planta a la que se va a ir 
				c_nodos = randi_range(min_vuelo,max_vuelo) #Asignamos de forma aleatoria cuanto va a divagar
				cambiar_destino_aleatorio()
				estado_anterior = Estados.VOLAR
			
			
			if c_nodos > 0: #Movemos de forma aleatoria hasta que completemos c_nodos
				if comprobar_llegado(): 
					c_nodos -=1 
					cambiar_destino_aleatorio()
			else:
				if c_nodos == 0: #calcula la dirección solo la primera vez
					if volver:
						cambiar_destino(Vector2(0,-2))
					else:
						cambiar_destino(pos_planta_pol - pos_panal) #Vuela hacia la planta escogida
						
					c_nodos = -1
			mover(delta)
			
		Estados.PANAL: 
			pass

		Estados.POLIN:
			if estado_anterior != Estados.POLIN:  #Se activa la primera vez que entra al estado
				timer_polin.start()
				animation.play("Polinizando")
				estado_anterior = Estados.POLIN
				
		Estados.MUERTE:
			if estado_anterior != Estados.PANAL:
				if estado_anterior != Estados.MUERTE:
					collision_shape_2d.disabled = true
					animated_sprite_2d.play("default")
					animation.play("RESET")
					cambiar_destino(Vector2(position.x,7))
					timer_polin.stop()
					
				if not comprobar_llegado():
					mover(delta)
				else:
					pass			
				
			
#Calcula la dirección a la que se tiene que mover la abeja a partir de su nuevo destino	
func calculo_dir():
	dir = (destino - position).normalized()
	var angulo = dir.angle()	
	rotation = angulo

func cambiar_destino(n_destino):
	destino = n_destino
	calculo_dir()

func comprobar_llegado():
	var llegado = false
	if (position - destino).length() < tol_llegada:
		llegado = true
	return llegado

func mover(delta):
	
	if position.x < -10 - pos_panal.x or position.x > 120 - pos_panal.x or position.y < -5 - pos_panal.y or position.y > 60 - pos_panal.y:
		cambiar_destino_aleatorio()
	position += dir*delta*velocidad
	

func dejar_de_mover():
	dir = Vector2(0,0)

#Asigna un destino aleatorio a la abeja
func cambiar_destino_aleatorio():
	destino = Vector2(randf_range(10,100)- pos_panal.x,randf_range(10,30) - pos_panal.y) #valores de pantalla que cambiar
	calculo_dir()
	return
	
#Escoge si vuelve basandose es la cantida de nectar que lleva la abeja
func probabilidad_volver():
	var prob = randi_range(0, _get_nectar())
	if prob >= prob_min_volver:
		volver = true
	return

#Funcion que se activa al entrar en contacto con un area
func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.get_collision_layer() == 4 and c_nodos < 1: #Contacto con una planta
		#Recogiendo polen
		dejar_de_mover()
		estado_actual = Estados.POLIN 
		var polen_rec = randi_range(min_polen_recoger,max_polen_recoger) #Variable que calcula el polen recogido
		var nectar_rec = randi_range(min_nectar_recoger,max_nectar_recoger) # = nectar = 
		polen_rec = min(polen_rec, area._get_polen()) #No dejamos que recoja mas de lo posible
		nectar_rec = min(nectar_rec, area._get_nectar()) #No dejamos que recoje mas de lo posible
		
		_add_polen(polen_rec) #Añadimos el polen a la abeja y se lo quitamos a la flor
		area._add_polen(-polen_rec)
		_add_nectar(nectar_rec) #Añadimos el nectar a la abeja y se lo quitamos a la flor
		area._add_nectar(-nectar_rec)
		probabilidad_volver()
	elif area.get_collision_layer() == 1 and area.is_ancestor_of(self) and volver: #Contacto con panal
		# Entregando polen, el panal se encarga de sacar el polen y el nectar
		dejar_de_mover()
		volver = false
		estado_actual = Estados.PANAL
		visible = false
		animated_sprite_2d.play("default")
		timer_panal.start()

#Se activa al terminar de polinizar, hace que vuele o que vuelva al panal
func _on_timer_polin_timeout() -> void:
	animation.play("RESET")
	estado_anterior = estado_actual
	estado_actual = Estados.VOLAR
	
#Funcion activada al terminar de estar en el panal
func _on_timer_panal_timeout() -> void:
	visible = true
	estado_anterior = estado_actual
	estado_actual = Estados.VOLAR

func _on_timer_vida_timeout() -> void:
	print("He muerto")
	estado_anterior = estado_actual
	estado_actual = Estados.MUERTE
	
