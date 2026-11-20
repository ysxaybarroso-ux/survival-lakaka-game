extends Control
class_name HotBar

var inventory_item_scene: PackedScene = preload("res://Inventory/Item/inventory_item.tscn")

@export var rows: int = 1
@export var cols: int = 6
@export var inventory_grid : GridContainer

@export var inventory_slot_scene : PackedScene
var slots: Array[InventorySlot]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_grid.columns = cols
	for i in range(rows * cols):
		var slot = inventory_slot_scene.instantiate()
		slots.append(slot)
		inventory_grid.add_child(slot)
		slot.slot_input.connect(self._on_slot_input)
	visible = true


func _on_slot_input(which: InventorySlot, actions: InventorySlot.InventorySlotAction):
	if not InventoryManager.selected_item:
		if actions == InventorySlot.InventorySlotAction.SELECT:
			if  InventoryManager.is_open:
				InventoryManager.selected_item = which.select_item()
				if InventoryManager.selected_item:
					InventoryManager.selected_origin = which
			else:
				which.use_item()	
	else:
		InventoryManager.selected_item = which.deselect_item(InventoryManager.selected_item)
		if not InventoryManager.selected_item:
			InventoryManager.selected_origin = null
func add_item(item: Item) -> bool:
	var _item: InventoryItem = inventory_item_scene.instantiate()
	_item.set_data(item.item_name, item.icon, item.is_stackable, item.amount, item.effect , item.effect_amount, item.type, item.hand_icon ,item.weapon_type, item.max_use )
	if item.is_stackable > 0:
		for slot in slots:
			if slot.item and slot.item.item_name == _item.item_name and slot.item.amount < item.is_stackable :
				slot.item.amount += _item.amount
				slot.update_slot()
				_item.free()
				item.queue_free()
				return true
	for slot in slots:
		if slot.item == null and slot.is_respecting_hint(_item):
			slot.item = _item
			slot.update_slot()
			item.queue_free()
			return true
	_item.free()
	return false
		
func retrieve_item(_item_name : String , amount: int) -> Item:
	for slot in slots:
		if slot.item and slot.item.item_name == _item_name:
			var copy_item = Item.new()
			copy_item.item_name = slot.item.item_name
			copy_item.name = copy_item.item_name
			copy_item.icon = slot.item.icon
			copy_item.is_stackable = slot.item.is_stackable
			if slot.item.amount > 1:
				slot.item.amount -= amount 
			else: 
				slot.remove_item()
			return copy_item
	return null

func remove_all(_name: String) -> void:
	for slot in slots:
		if slot.item and slot.item.item_name == _name:
			slot.remove_item()

func clear_inventory() -> void:
	for slot in slots:
		slot.remove_item()

func _process(_delta: float) -> void:
	if InventoryManager.selected_item and !InventoryManager.is_open:
		InventoryManager.selected_item.global_position = get_global_mouse_position()
