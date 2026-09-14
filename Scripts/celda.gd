extends Node2D

@onready var timer_miel: Timer = $Timer_miel


signal cambio_celda(coords, estado)

#Contenidos que puede tener la celda
enum estados {VACIO,POLEN,NECTAR,MIEL,BEBE}

#Variables de almacenamiento
var estado := estados.VACIO #Estado inicial
var almacen_nectar := 50 #Cantidad máxima de nectar que puede guardar
var almacen_polen := 100 #Cantidad máxima de polen que puede guardar
var almacen_miel := 20 #Cantidad máxima de miel que puede guardar
var almacen_max := almacen_polen
var cantidad := 0 : get = _get_cantidad, set = _set_cantidad

var coordenadas = Vector2(0,0)

func _get_cantidad(): #Devuelve la cantidad que tiene guardada
	return cantidad
	
func _set_cantidad(valor:int): #Pone la cantidad a un valor concreto
	cantidad = valor
	
func _add_cantidad(valor:int): #Añade la cantidad que puede hasta el máximo y luego devuelve la diferencia 
	var cantidad_2 = clamp(cantidad + valor,0, almacen_max)
	var diferencia = cantidad + valor - cantidad_2
	cantidad = cantidad_2
	return diferencia

func comprobar_miel(): #Empieza a hacer miel si la celda tiene suficiente nectar 
	if estado == estados.NECTAR and cantidad == almacen_max and timer_miel.is_stopped():
		timer_miel.start()
		


func iniciar(coords: Vector2, alma_nectar:= 50, alma_polen:= 100, alma_miel:= 100, t_miel = 10):
	coordenadas = coords
	almacen_nectar = alma_nectar
	almacen_polen = alma_polen
	timer_miel.wait_time = t_miel
	timer_miel.one_shot = true
	
	estado = estados.VACIO
	
func cambiar_estado(tipo): #Cambia entre los estados, faltan cosas
	match tipo:
		estados.POLEN:
			estado = estados.POLEN
			almacen_max = almacen_polen
			_set_cantidad(0)
		estados.NECTAR:
			estado = estados.NECTAR
			almacen_max = almacen_nectar
			_set_cantidad(0)
		estados.MIEL:
			estado = estados.MIEL
			almacen_max = almacen_miel
			_set_cantidad(almacen_max)
		estados.BEBE:
			estado = estados.BEBE
			_set_cantidad(0)
		_:
			reiniciar()
	cambio_celda.emit(coordenadas,estado)
	
func reiniciar():
	estado = estados.VACIO
	almacen_max = 0
	_set_cantidad(0)
	
func mostrar():
	var texto = "VACIO"
	match estado:
		estados.POLEN:
			texto = "POLEN"
		estados.NECTAR:
			texto = "NECTAR"
		estados.MIEL:
			texto = "MIEL"
		estados.BEBE:
			texto = "BEBE"
	print(texto)
	print("Almacen: " + str(_get_cantidad()))
	
func _on_timer_miel_timeout():
	cambiar_estado(estados.MIEL)
	
