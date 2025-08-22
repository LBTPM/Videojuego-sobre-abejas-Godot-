extends Panel


@onready var label: Label = $Label


func set_text(texto: String):
	label.text = texto
