extends CanvasLayer

@onready var inventory: Inventory = $Inventory 
var is_open := false
signal item_used(effect: String, amount: float) 

func _ready() -> void:
	inventory.visible = false

func add_item(item: Item, amount: int) -> bool:
	return inventory.add_item(item, amount)

func retrieve_item(item_name: String, amount: int) -> Item:
	return inventory.retrieve_item(item_name, amount)

func remove_all(item_name: String) -> void:
	inventory.remove_all(item_name)

func clear_inventory() -> void:
	inventory.clear_inventory()
