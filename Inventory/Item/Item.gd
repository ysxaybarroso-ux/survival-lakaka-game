extends Node
class_name Item
@export var item_name : String = ""
@export var icon : Texture
@export var is_stackable : int = 0
@export_enum("Consumable", "Equipment") var type : String = ""
@export_enum("Thirst", "Hunger") var effect: String = ""
@export var effect_amount: int = 0
@export_enum("2_hand_sword", "1_hand_sword", "2_hand_gun", "1_hand_gun", "launcher","knife", "grenade","None") var weapon_type : String 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Items")
