extends Node
class_name Item
@export var data: ItemData
@export var item_name : String = ""
@export var icon : Texture
@export var amount :int 
@export var max_use: int
@export var hand_icon : Texture
@export var is_stackable : int = 0
@export_enum("Consumable", "Equipment") var type : String = ""
@export_enum("Thirst", "Hunger","Stun") var effect: String = ""
@export var effect_amount: int = 0
@export_enum("none","2_hand_sword", "1_hand_sword", "2_hand_gun", "1_hand_gun", "launcher","knife", "grenade") var weapon_type : String 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Items")
	if data != null:
		item_name = data.display_name
		icon = data.icon
		hand_icon = data.hand_icon
		type = data.type
		effect = data.effect
		effect_amount = data.effect_amount
		max_use = data.max_use
		is_stackable = data.stack_size if data.stack_size > 1 else 0
		amount = 1 if data.max_use == 0 else data.max_use  
	
func to_stack() -> ItemStack:
	if data == null:
		return null
	if data.max_use >0:
		var s = ItemStack.new(data,1)
		s.uses_left = clampi(amount,0,data.max_use)
		return s
	return ItemStack.new(data,max(amount,1))
	
