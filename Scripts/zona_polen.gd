extends Area2D

#Temporizador para producir miel
@onready var timer_gen: Timer = $timer_gen

#Tiempo que tarda en generar
@export var time_gen := 5

# Variables polen
@export var polen_max := 100 #Polen maximo
@export var gen_polen_max := 10 #Polen maximo generable
@export var gen_polen_min := 5 #Polen mínimo generable


# variables nectar
@export var nectar_max := 200 #Nectar máximo
@export var gen_nectar_max := 15 #Nectar máximo generable
@export var gen_nectar_min := 5 #Nectar mínimo generable

var polen := 0: set = _add_polen, get = _get_polen

var nectar := 0: set = _add_nectar, get = _get_nectar

func _set_polen(valor):
	polen = clamp(valor,0, polen_max)
func _add_polen(valor):
	polen = clamp(polen + valor,0, polen_max)
func _get_polen():
		return polen

func _set_nectar(valor):
	nectar = clamp(valor,0, nectar_max)
func _add_nectar(valor):
	nectar = clamp(nectar + valor,0, nectar_max)
func _get_nectar():
		return nectar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_gen.wait_time = time_gen #Asignamos el tiempo de generacion
	timer_gen.start() #Activamos la generacion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_gen_timeout() -> void: #Cuando termian el tiempo generamos
	var gen_polen = randi_range(gen_polen_min,gen_polen_max)
	polen  = clamp(polen + gen_polen,0, polen_max)
		
	var gen_nectar = randi_range(gen_nectar_min,gen_nectar_max)
	nectar = clamp(nectar + gen_nectar,0, nectar_max)
