extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var gen_miel: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gen_miel:
		animation_player.play("Generando_Miel")
