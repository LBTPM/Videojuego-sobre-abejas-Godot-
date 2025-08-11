class_name Panal
extends Area2D

const ABEJA = preload("res://Escenas/abeja.tscn")
@onready var timer_miel: Timer = $Timer_miel

@export var cant_polen_para_miel: int = 50
@export var tiempo_miel: int = 20
@export var ml_miel_celda: float = 2
@export var max_celdas := 10

# Posicion flores
var zonas_polen
var pos_polen : Array[Vector2]

# Variables
var cant_abj: int = 3
var ml_miel: float = 0
var g_polen: int = 0

var celdas_miel_prod := 0
var celdas_miel := 0
var nuevas_celdas_miel := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_miel.wait_time = tiempo_miel
	timer_miel.start()
	zonas_polen = get_node("../Zonas_polen").get_children()
	for x in zonas_polen:
		pos_polen.append(x.global_position)
	
	for x in cant_abj:
		var abeja = ABEJA.instantiate()
		abeja.visible = true
		abeja.position = Vector2(0,-2)
		abeja.pos_polen = pos_polen
		add_child(abeja)


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if self.is_ancestor_of(area):
		g_polen += area.c_polen_actual
		print("Granos polen: " + str(g_polen))
		area._add_c_polen_actual(-area._get_c_polen_actual())

func _process(delta: float) -> void:
	if g_polen >= cant_polen_para_miel and celdas_miel + celdas_miel_prod + nuevas_celdas_miel <= max_celdas:
		g_polen -= cant_polen_para_miel
		nuevas_celdas_miel += 1
		print("Granos polen: " + str(g_polen))

func _on_timer_miel_timeout() -> void:
	ml_miel += celdas_miel_prod*ml_miel_celda
	celdas_miel += celdas_miel_prod
	celdas_miel_prod = 0
	celdas_miel_prod += nuevas_celdas_miel
	nuevas_celdas_miel = 0
