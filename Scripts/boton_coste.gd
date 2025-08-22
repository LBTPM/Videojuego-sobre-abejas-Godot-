extends Button

@onready var coste: Label = $Panel/Coste

func set_coste(texto):
	coste.text = texto
