extends CanvasLayer

@onready var loot_ui: Control = $Loot_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loot_ui.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
