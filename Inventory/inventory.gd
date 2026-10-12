extends Control
class_name Inventory

var inventory_item_scene: PackedScene = preload("res://Inventory/Item/inventory_item.tscn")

@export var rows: int = 6
@export var cols: int = 7
var hovered_slot: InventorySlot = null
@export var inventory_grid : GridContainer

@export var inventory_slot_scene : PackedScene
var slots: Array[InventorySlot]

@export var tooltip : Tooltip

static var selected_item: InventoryItem = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_grid.columns = cols
	for i in range(rows * cols):
		var slot = inventory_slot_scene.instantiate()
		slots.append(slot)
		inventory_grid.add_child(slot)
		slot.slot_input.connect(self._on_slot_input)
		slot.slot_hovered.connect(self._on_slot_hovered)
	tooltip.visible = false
	visible = false


func _on_slot_input(which: InventorySlot, actions: InventorySlot.InventorySlotAction):
	if not selected_item:
		if actions == InventorySlot.InventorySlotAction.SELECT:
			selected_item = which.select_item()
		elif actions == InventorySlot.InventorySlotAction.SPLIT:
			selected_item = which.split_item()
	else:
		selected_item = which.deselect_item(selected_item)

func _on_slot_hovered(which: InventorySlot , is_hovering : bool):
	if is_hovering:
		hovered_slot = which
	elif hovered_slot == which:
		hovered_slot = null
	if which.item:
		tooltip.set_text(which.item.item_name)
		tooltip.visible = is_hovering
	elif which.hint_item:
		tooltip.set_text(which.hint_item.item_name)
		tooltip.visible = is_hovering

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		self.visible = !self.visible
		InventoryManager.is_open = visible
		if not visible:
			hovered_slot = null
	elif event.is_action_pressed("interact") and visible and hovered_slot != null:
		hovered_slot.use_item()
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	tooltip.global_position = get_global_mouse_position() + Vector2.ONE * 8
	if selected_item:
		tooltip.visible = true
		selected_item.global_position = get_global_mouse_position()


func add_item(item: Item, amount: int) -> bool:
	var _item: InventoryItem = inventory_item_scene.instantiate()
	_item.set_data(item.item_name, item.icon, item.is_stackable, amount, item.effect , item.effect_amount, item.type )
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
