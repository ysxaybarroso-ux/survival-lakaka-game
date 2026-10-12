extends Node
class_name Item
@export var item_name : String = ""
@export var icon : Texture
@export var is_stackable : int = 0
@export var type : String = ""
@export var effect: String = ""
@export var effect_amount: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Items")
