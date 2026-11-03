extends CanvasLayer

@onready var inventory: Inventory = $Inventory 
@onready var hotbar_grid: GridContainer = $HotBar/CenterContainer/GridContainer
var is_open := false
signal item_used(effect: String, amount: int) 
signal equipment_used(item_name : String , effect: String , amount: int)
var equipped_slot: int = -1
var selected_item = null 
var selected_origin: InventorySlot = null
signal equipped_changed(slot: int)

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

func use_equipped() -> void:
	if equipped_slot < 0 or equipped_slot > 5:
		return 
	var slot = hotbar_grid.get_child(equipped_slot)
	if slot is not InventorySlot:
		return
	slot.use_item()
