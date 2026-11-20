extends CanvasLayer

@onready var inventory: Inventory = $Inventory 
@onready var hotbar_grid: GridContainer = $HotBar/CenterContainer/GridContainer
var is_open := false
@warning_ignore("unused_signal")
signal item_used(effect: String, amount: int) 
@warning_ignore("unused_signal")
signal equipment_used(item_name : String , effect: String , amount: int)
var equipped_slot: int = -1
var selected_item = null 
var selected_origin: InventorySlot = null
@warning_ignore("unused_signal")
signal equipped_changed(slot: int)

func _ready() -> void:
	inventory.visible = false

func add_item(item: Item) -> bool:
	return inventory.add_item(item)

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
	
	
	
# call the save for inventory and hotbar
func get_save_data() -> Array:
	var out = []
	for i in inventory.slots.size():
		_save_slot(out, "Inventory",i , inventory.slots[i])
	for i in hotbar_grid.get_child_count():
		var s =  hotbar_grid.get_child(i)
		if s is InventorySlot:
			_save_slot(out, "Hotbar", i, s)
	return out
	
#save the InventorySlot type
func _save_slot(out : Array, container : String, index: int, slot: InventorySlot) -> void:
	if slot.item == null or slot.item.stack == null:
		return
	out.append({
		"container": container,
		"slot": index,
		"id": slot.item.stack.data.id,
		"amount": slot.item.amount,
		"uses_left": slot.item.stack.uses_left
	})

#load a save and earase actual slot to remplace by the ones mentioned in the entries
func load_save_data(entries : Array) ->void:
	for s in inventory.slots:
		if s.item :
			s.remove_item()
	for s in hotbar_grid.get_children():
		if s is InventorySlot and s.item:
			s.remove_item()
	for e in entries:
		var data = ItemDB.get_item(e["id"])
		if data == null:
			push_warning("unknow object" + str(e["id"]))
			continue
		var slot
		if e["container"] == "Inventory":
			slot = inventory.slots[int(e["slot"])]
		else:
			slot = hotbar_grid.get_children(int(e["slot"]))
			var item : InventoryItem = inventory.inventory_item_scene.instantiate()
			item.set_data(data.display_name,data.icon, data.stack_size > 1, int(e["amount"]),data.effect, data.effect_amount, data.type, data.hand_icon,data.weapon_type, data.max_use)
			item.stack = ItemDB.new(data, int(e["amount"]))
			item.stack.uses_left = int(e["uses_left"])
			slot.item = item
			slot.update_slot()
