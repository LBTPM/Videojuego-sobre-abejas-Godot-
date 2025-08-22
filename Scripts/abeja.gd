extends Area2D


# cambio vuelta con nectar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer_polin: Timer = $timer_polin
@onready var timer_panal: Timer = $timer_panal

@export var velocidad: float = 10
@export var tol_final: float = 0.1
@export var min_vuelo := 2
@export var max_vuelo: int = 10
@export var polin_time := 3
@export var prob_min_volver := 50

enum Estados {PANAL = 0,VOLAR = 1,POLIN = 2}

# Variables movimiento
var destino : Vector2 
var estado_actual = Estados.VOLAR
var estado_anterior = Estados.PANAL
var dir 
var pos_polen = []
var pos_planta_pol
var pos_panal : Vector2
var c_nodos := 1
var volver : bool = false

#Variables polen
@export var c_polen_max := 50
var c_polen_actual := 0: set = _add_c_polen_actual, get = _get_c_polen_actual

#Variables nectar
@export var nectar_max := 100
var nectar_actual := 0: set = _add_nectar_actual, get = _get_nectar_actual

func _add_c_polen_actual(valor):
	c_polen_actual = min(c_polen_actual + valor, c_polen_max)
func _get_c_polen_actual():
		return c_polen_actual

func _add_nectar_actual(valor):
	nectar_actual = min(nectar_actual + valor, nectar_max)
func _get_nectar_actual():
		return nectar_actual

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destino = position
	dir = destino - position
	pos_panal = get_parent().position
	timer_polin.wait_time = polin_time
	timer_panal.wait_time = 10
	
func calculo_dir(n_destino: Vector2):
	destino = n_destino 
	dir = (destino - position).normalized()
	var angulo = dir.angle()	
	rotation = angulo

func mover_aleatorio(delta:float):
	var cambio = false
	if (position-destino).length() < tol_final:
		calculo_dir(Vector2(randf_range(10,100),randf_range(10,30))- pos_panal)
		cambio = true
	position += dir*delta*velocidad
	return cambio
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match estado_actual:
		Estados.VOLAR:
			if estado_anterior != Estados.VOLAR:
				animated_sprite_2d.play("volar")
				pos_planta_pol = pos_polen[randi_range(0,len(pos_polen)-1)]
				c_nodos = randi_range(min_vuelo,max_vuelo)
				
			if c_nodos > 0:
				if mover_aleatorio(delta): c_nodos -=1 
			else:
				calculo_dir(pos_planta_pol - pos_panal)
				position += dir*delta*velocidad
			estado_anterior = Estados.VOLAR
		Estados.PANAL:
			if estado_anterior != Estados.PANAL:
				c_nodos = randi_range(min_vuelo,max_vuelo)
				volver = false
			if c_nodos > 0:
				if mover_aleatorio(delta): c_nodos -=1
			else:
				calculo_dir(Vector2(0,-2))
				position += dir*delta*velocidad
			estado_anterior = Estados.PANAL
		Estados.POLIN:
			if estado_anterior != Estados.POLIN:
				timer_polin.start()
				animation.play("Polinizando")
			estado_anterior = Estados.POLIN
			
func probabilidad_volver():
	var prob = randi_range(0, _get_nectar_actual())
	if prob >= prob_min_volver:
		volver = true

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_collision_layer() == 4 and c_nodos < 3:
		estado_actual = Estados.POLIN 
	elif area.get_collision_layer() == 1 and area.is_ancestor_of(self):
		visible = false
		animated_sprite_2d.play("default")
		timer_panal.start()
		# solucion un poco de mierda a que toque el panal aleatoriamente
		estado_actual = Estados.PANAL
		estado_anterior = Estados.PANAL
		c_nodos = 0

func _on_timer_polin_timeout() -> void:
	animation.play("RESET")
	probabilidad_volver()
	if volver:
		estado_actual = Estados.PANAL
	else:
		estado_actual = Estados.VOLAR
		
	print("Polen: " + str(c_polen_actual))
	print("Nectar: " + str(nectar_actual))
	

func _on_timer_panal_timeout() -> void:
	visible = true
	estado_actual  = Estados.VOLAR
