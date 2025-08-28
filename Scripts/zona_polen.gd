extends Area2D

@onready var timer_polen_gen: Timer = $timer_polen_gen

@export var time_gen := 5

# Variables polen
@export var c_polen_max := 100
@export var c_gen_polen_max := 10
@export var c_gen_polen_min := 5


# variables nectar
@export var nectar_max := 200
@export var gen_nectar_max := 15
@export var gen_nectar_min := 5

var c_polen := 0: set = _add_c_polen_actual, get = _get_c_polen_actual

var nectar := 0: set = _add_nectar_actual, get = _get_nectar_actual

func _add_c_polen_actual(valor):
	c_polen = min(c_polen + valor, c_polen_max)
func _get_c_polen_actual():
		return c_polen

func _add_nectar_actual(valor):
	nectar = min(nectar + valor, nectar_max)
func _get_nectar_actual():
		return nectar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_polen_gen.wait_time = time_gen
	timer_polen_gen.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_timer_polen_gen_timeout() -> void:
	var c_gen_polen = randi_range(c_gen_polen_min,c_gen_polen_max)
	if c_polen + c_gen_polen <= c_polen_max:
		c_polen += c_gen_polen
	elif c_polen + c_gen_polen > c_polen_max:
		c_polen = c_polen_max
		
	var gen_nectar = randi_range(gen_nectar_min,gen_nectar_max)
	if nectar + gen_nectar <= nectar_max:
		nectar += gen_nectar
	elif nectar + gen_nectar > nectar_max:
		nectar = nectar_max
