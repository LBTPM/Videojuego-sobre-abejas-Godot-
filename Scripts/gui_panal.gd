extends CanvasLayer

@onready var celdas: TileMapLayer = $"Panel mejoras panal/HBoxContainer/Panel/Celdas"
@onready var anadir_abeja: Button = $"Panel mejoras panal/HBoxContainer/Panel/Panel_miel/Añadir Abeja"
@onready var precio_abeja: Panel = $"Panel mejoras panal/HBoxContainer/Panel/Precio abeja"

signal celda_creada(coordenadas: Vector2)


var nivel = 0
var contador = 0 #Contador para poner las celdas
var siguiente_celda = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if anadir_abeja.is_hovered():
		precio_abeja.visible = true
	else:
		precio_abeja.visible = false

func _on_cerrar_panal_button_up() -> void:
	visible = false

func iniciar_celdas():
	for i in range(9):
		pintar_celda()
		anadir_celda()

func pintar_celda(): #Pinta las celdas en una forma espiral
	if 0 < contador:
		if contador <= nivel:
			match (contador%2):
				1:	siguiente_celda += Vector2(-1,-1)
				0:	siguiente_celda += Vector2(0,-1)
		elif contador <= 2*nivel:
			siguiente_celda += Vector2(-1,0)
		elif contador <= 3*nivel:
			match (contador%2 + nivel%2)%2: #Forma de tomar en cuenta la paridad del nivel
				1:	siguiente_celda += Vector2(-1,1)
				0:	siguiente_celda += Vector2(0,1)
		elif contador <= 4*nivel:
			match (contador%2 + nivel%2 + 1)%2: #Forma de tomar en cuenta la paridad del nivel
				1:	siguiente_celda += Vector2(1,1)
				0:	siguiente_celda += Vector2(0,1)
		elif contador <= 5*nivel:
			siguiente_celda += Vector2(1,0)
		elif contador <= 6*nivel - 1:
			match contador%2:
				0:	siguiente_celda += Vector2(1,-1)
				1:	siguiente_celda += Vector2(0,-1)
		else: 
			nivel +=1
			contador = 0
			siguiente_celda = Vector2(nivel,0)
			
	celdas.set_cell(siguiente_celda,1,Vector2(0,0),0)
	contador += 1

func anadir_celda():
	celda_creada.emit(siguiente_celda)

func _on_añadir_celda_button_up() -> void:
	pintar_celda()
	anadir_celda()
