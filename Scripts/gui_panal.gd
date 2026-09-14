extends CanvasLayer

@onready var celdas: TileMapLayer = $"Panel mejoras panal/HBoxContainer/Panel/Celdas"
@onready var anadir_abeja: Button = $"Panel mejoras panal/HBoxContainer/Panel/Panel_miel/Añadir Abeja"
@onready var precio_abeja: Panel = $"Panel mejoras panal/HBoxContainer/Panel/Precio abeja"
@onready var añadir_celda: Button = $"Panel mejoras panal/HBoxContainer/Panel/Añadir Celda"
@onready var subir_nivel: Button = $"Panel mejoras panal/HBoxContainer/Panel/Subir Nivel"
@onready var lista_mejoras: ItemList = $"Panel mejoras panal/HBoxContainer/VBoxContainer/Panel_Mejoras/ListaMejoras"


signal celda_creada(coordenadas: Vector2)
signal sub_nivel


var nivel_celdas = 0
var contador = 0 #Contador para poner las celdas
var coords_celda = Vector2(0,0)
var panal #variable para el padre

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panal = get_parent()
	lista_mejoras.set_item_tooltip_enabled(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if anadir_abeja.is_hovered():
		precio_abeja.visible = true
	else:
		precio_abeja.visible = false
	
	if panal.aviso_celdas_max():
		añadir_celda.visible = false
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
			tipo_celda = Vector2(0,2)
	
	celdas.set_cell(coords,1,tipo_celda,0)


func _on_añadir_celda_button_up() -> void:
	pintar_celda()
	anadir_celda()


func _on_subir_nivel_button_up() -> void:
	añadir_celda.visible = true
	subir_nivel.visible = false
	sub_nivel.emit()
	


func _on_lista_mejoras_item_hovered(index: int) -> void:
	print(lista_mejoras.get_item_text(index))
