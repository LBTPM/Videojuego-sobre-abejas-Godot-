class_name Celda

#Contenidos que puede tener la celda
enum estados {VACIO,POLEN,NECTAR,MIEL,BEBE}

#Variables de almacenamiento
var estado := estados.VACIO #Estado inicial
var almacen_nectar := 50 #Cantidad máxima de nectar que puede guardar
var almacen_polen := 100 #Cantidad máxima de polen que puede guardar
var almacen_max := almacen_polen
var cantidad := 0 : get = _get_cantidad, set = _set_cantidad

func _get_cantidad(): #Devuelve la cantidad que tiene guardada
	return cantidad
	
func _set_cantidad(valor:int): #Pone la cantidad a un valor concreto
	cantidad = valor
	
func _add_cantidad(valor:int): #Añade la cantidad que puede hasta el máximo y luego devuelve la diferencia 
	var cantidad_2 = clamp(cantidad + valor,0, almacen_max)
	var diferencia = cantidad + valor - cantidad_2
	cantidad = cantidad_2
	return diferencia
	
func comprobar_miel() -> bool: #Empieza a hacer miel si la celda tiene suficiente nectar 
	var mielear = false
	if estado == estados.NECTAR and cantidad == almacen_max:
		cambiar_tipo(estados.MIEL)
		mielear = true
	return mielear

func iniciar(alma_nectar:= 50, alma_polen:= 100): #???
	almacen_nectar = alma_nectar
	almacen_polen = alma_polen
	
func cambiar_tipo(tipo): #Cambia entre los estados, faltan cosas
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
			_set_cantidad(0)
		estados.BEBE:
			estado = estados.BEBE
			_set_cantidad(0)
		_:
			reiniciar()
	
func reiniciar():
	estado = estados.VACIO
	almacen_max = 0
	_set_cantidad(0)
	
func mostrar():
	var texto = "VACIO"
	match estado:
		estados.POLEN:
			texto = "POLEN"
			almacen_max = almacen_polen
		estados.NECTAR:
			texto = "NECTAR"
			almacen_max = almacen_nectar
		estados.MIEL:
			texto = "MIEL"
		estados.BEBE:
			texto = "BEBE"
	print(texto)
	print(str(_get_cantidad()))
