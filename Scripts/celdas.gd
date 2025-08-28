class_name Celda

enum estados {VACIO,POLEN,NECTAR,MIEL,BEBE}

var estado := estados.VACIO
var almacen_nectar := 50
var almacen_polen := 100
var almacen_max := 100
var cantidad := 0 : get = _get_cantidad, set = _add_cantidad

func _get_cantidad():
	return cantidad
	
func _add_cantidad(valor:int):
	var cantidad_2 = clamp(cantidad + valor,0, almacen_max)
	var diferencia = cantidad + valor - cantidad_2
	cantidad = cantidad_2
	return valor - diferencia
	
func comprobar_miel() -> bool:
	var mielear = false
	if estado == estados.POLEN and cantidad == almacen_max:
		estado = estados.MIEL
		mielear = true
	return mielear

func iniciar(alma_nectar:= 50, alma_polen:= 100):
	almacen_nectar = alma_nectar
	almacen_polen = almacen_polen
	
func cambiar_tipo(tipo):
	match tipo:
		estados.POLEN:
			estado = estados.POLEN
			almacen_max = almacen_polen
		estados.NECTAR:
			estado = estados.NECTAR
			almacen_max = almacen_nectar
		estados.MIEL:
			estado = estados.MIEL
		estados.BEBE:
			estado = estados.BEBE
		_:
			reiniciar()
	
func reiniciar():
	estado = estados.VACIO
	almacen_max = 100
	_add_cantidad(-_get_cantidad())
	
func mostrar():
	print(str(estado))
	print(str(_get_cantidad()))
