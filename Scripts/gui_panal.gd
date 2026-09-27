extends CanvasLayer

@onready var celdas: TileMapLayer = $"Panel mejoras panal/HBoxContainer/Panel/Celdas"
@onready var bot_anadir_abeja: Button = $"Panel mejoras panal/HBoxContainer/Panel/Panel_miel/Anadir Abeja"
@onready var precio_abeja: Panel = $"Panel mejoras panal/HBoxContainer/Panel/Precio abeja"
@onready var bot_anadir_celda: Button = $"Panel mejoras panal/HBoxContainer/Panel/Anadir Celda"
@onready var subir_nivel: Button = $"Panel mejoras panal/HBoxContainer/Panel/Subir Nivel"
@onready var lista_mejoras: ItemList = $"Panel mejoras panal/HBoxContainer/VBoxContainer/Panel_Mejoras/ListaMejoras"
@onready var etq_cant_polen: Label = $"Panel mejoras panal/HBoxContainer/VBoxContainer/Panel_info/etq_cant_polen"
@onready var etq_cant_miel: Label = $"Panel mejoras panal/HBoxContainer/VBoxContainer/Panel_info/etq_cant_miel"
@onready var etq_precio_miel_abeja: Label = $"Panel mejoras panal/HBoxContainer/Panel/Precio abeja/Etq_precio_miel_abeja"
@onready var etq_precio_polen_abeja: Label = $"Panel mejoras panal/HBoxContainer/Panel/Precio abeja/Etq_precio_polen_abeja"
@onready var etq_cant_abejas: Label = $"Panel mejoras panal/HBoxContainer/VBoxContainer/Panel_info/etq_cant_abejas"
@onready var etq_nivel_num: Label = $"Panel mejoras panal/HBoxContainer/VBoxContainer/Panel_info/etq_nivel_num"

signal celda_creada(coordenadas: Vector2)
signal sub_nivel
signal mejora_comprada(index)
signal abeja_anadida


var nivel_celdas = 0
var contador = 0 #Contador para poner las celdas
var coords_celda = Vector2(0,0)
var panal #variable para el padre

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panal = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bot_anadir_abeja.is_hovered(): #Cambiar para que no lo haga el process si no una señal
		precio_abeja.visible = true
	else:
		precio_abeja.visible = false
	
	if panal.aviso_celdas_max(): #Cambiar para que no lo haga el process si no una señal
		bot_anadir_celda.visible = false
		subir_nivel.visible = true

func _on_cerrar_panal_button_up() -> void:
	visible = false

func iniciar_celdas():
	for i in range(7):
		pintar_celda()
		anadir_celda()

func pintar_celda(): #Pinta las celdas en una forma espiral
	if 0 < contador:
		if contador <= nivel_celdas:
			match (contador%2):
				1:	coords_celda += Vector2(-1,-1)
				0:	coords_celda += Vector2(0,-1)
		elif contador <= 2*nivel_celdas:
			coords_celda += Vector2(-1,0)
		elif contador <= 3*nivel_celdas:
			match (contador%2 + nivel_celdas%2)%2: #Forma de tomar en cuenta la paridad del nivel_celdas
				1:	coords_celda += Vector2(-1,1)
				0:	coords_celda += Vector2(0,1)
		elif contador <= 4*nivel_celdas:
			match (contador%2 + nivel_celdas%2 + 1)%2: #Forma de tomar en cuenta la paridad del nivel_celdas
				1:	coords_celda += Vector2(1,1)
				0:	coords_celda += Vector2(0,1)
		elif contador <= 5*nivel_celdas:
			coords_celda += Vector2(1,0)
		elif contador <= 6*nivel_celdas - 1:
			match contador%2:
				0:	coords_celda += Vector2(1,-1)
				1:	coords_celda += Vector2(0,-1)
		else: 
			nivel_celdas +=1
			contador = 0
			coords_celda = Vector2(nivel_celdas,0)
			
	celdas.set_cell(coords_celda,1,Vector2(0,0),0)
	contador += 1

func anadir_celda():
	celda_creada.emit(coords_celda)

func cambiar_estado_celda(coords,estado):
	var tipo_celda = Vector2(0,0)
	match estado:
		0:
			tipo_celda = Vector2(0,0)
		1:
			tipo_celda = Vector2(1,0)
		2:
			tipo_celda = Vector2(2,0)
		3:
			tipo_celda = Vector2(0,1)
		4:
			tipo_celda = Vector2(2,1)
	
	celdas.set_cell(coords,1,tipo_celda,0)
	
func actualizar_abejas(cant_abj, cant_max):
	etq_cant_abejas.text = str(cant_abj) + "/" + str(cant_max)
	

func actualizar_polen_miel(nueva_miel,nuevo_polen):
	etq_cant_polen.text = str(nuevo_polen)
	etq_cant_miel.text = str(nueva_miel)
	lista_mejoras.comprobar_precios(nueva_miel,nuevo_polen)

func anadir_mejoras(mejoras):
	lista_mejoras.anadir_mejoras(mejoras)

	
func cambiar_precio_abejas(p_abeja):
	etq_precio_miel_abeja.text = str(p_abeja[0])
	etq_precio_polen_abeja.text = str(p_abeja[1])

func activar_bot_abeja(estado):
	if estado == true:
		bot_anadir_abeja.disabled = false
	else:
		bot_anadir_abeja.disabled = true
		
func activar_bot_celda(estado):
	if estado == true:
		bot_anadir_celda.disabled = false
	else:
		bot_anadir_celda.disabled = true


#Funciones de señales
func _on_anadir_celda_button_up() -> void:
	pintar_celda()
	anadir_celda()

func _on_subir_nivel_button_up() -> void:
	bot_anadir_celda.visible = true
	subir_nivel.visible = false
	etq_nivel_num.text = str(etq_nivel_num.text.to_int() + 1)
	sub_nivel.emit()
	
func _on_lista_mejoras_item_hovered(index: int) -> void:
	pass

func _on_lista_mejoras_item_selected(index: int) -> void:
	var id_mejora = lista_mejoras.get_item_index(index)
	lista_mejoras.quitar_mejora(index)
	mejora_comprada.emit(id_mejora)

func _on_anadir_abeja_button_up() -> void:
	abeja_anadida.emit()
