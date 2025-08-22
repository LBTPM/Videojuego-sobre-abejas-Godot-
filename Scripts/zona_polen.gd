extends Area2D

@onready var timer_polen_gen: Timer = $timer_polen_gen

@export var time_gen := 5

# Variables polen
@export var c_polen_max := 100
@export var c_gen_polen_max := 10
@export var c_gen_polen_min := 5
@export var max_polen_dar := 10
@export var min_polen_dar := 5

# variables nectar
@export var nectar_max := 200
@export var gen_nectar_max := 15
@export var gen_nectar_min := 5
@export var max_nectar_dar := 25
@export var min_nectar_dar := 5

var c_polen := 0
var nectar := 0


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


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.c_nodos < 3:
		var polen_dar = randi_range(min_polen_dar,max_polen_dar)
		if polen_dar >= c_polen:
			polen_dar = c_polen
		c_polen -= polen_dar
		area._add_c_polen_actual(polen_dar)
		var nectar_dar = randi_range(min_nectar_dar,max_nectar_dar)
		if nectar_dar >= nectar:
			nectar_dar = nectar
		nectar -= nectar_dar
		area._add_nectar_actual(nectar_dar)
