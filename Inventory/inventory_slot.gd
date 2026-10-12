extends Control
class_name InventorySlot

@export var inventory_item_scene :PackedScene = preload("res://Inventory/Item/inventory_item.tscn")

@export var item : InventoryItem
@export var hint_item : InventoryItem = null 

enum InventorySlotAction{
	SPLIT, SELECT, 
	}
	
signal slot_input(which: InventorySlot ,action: InventorySlotAction)
signal slot_hovered(which: InventorySlot , is_hovering: bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("inventory_slots")


func is_respecting_hint(new_item: InventoryItem, in_amount_as_well: bool = true) -> bool:
	if not hint_item:
		return true
	if in_amount_as_well:
		return (
			new_item.item_name == self.hint_item.item_name
			and new_item.amount >= self.hint_item.amount
		)
	else:
		return new_item.item_name == self.hint_item.item_name



# Sets hint item
func set_item_hint(new_item_hint: InventoryItem):
	if self.hint_item:
		self.hint_item.free()
	self.hint_item = new_item_hint
	self.add_child(new_item_hint)
	update_slot()


# Deletes hint item
func clear_item_hint():
	if self.hint_item:
		self.hint_item.free()
	self.hint_item = null
	update_slot()



# Removes item from slot
func remove_item():
	self.remove_child(item)
	item.free()
	item = null
	update_slot()
	
	
func _on_texture_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			slot_input.emit(self, InventorySlotAction.SELECT)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			slot_input.emit(self, InventorySlotAction.SPLIT)



func _on_texture_button_mouse_entered() -> void:
	slot_hovered.emit(self, true)


func _on_texture_button_mouse_exited() -> void:
	slot_hovered.emit(self, false)
	
func select_item() -> InventoryItem:
	var inventory = self.get_parent().get_parent() # the inv root
	var tmp_item = self.item
	if tmp_item:
		tmp_item.reparent(inventory) 
		self.item = null
		tmp_item.z_index = 128
	return tmp_item
	
func deselect_item(new_item: InventoryItem) -> InventoryItem:
	if not is_respecting_hint(new_item):
		return new_item
	var inventory = self.get_parent().get_parent() # the inv (root)
	if self.is_empty():
		new_item.reparent(self)
		self.item = new_item
		self.item.z_index = 64 
		return null
	else : 
		if has_same_item(new_item):
			self.item.amount += new_item.amount
			new_item.free()
			return null
		else:
			new_item.reparent(self)
			self.item.reparent(inventory)
			var tmp_item = self.item
			self.item = new_item
			new_item.z_index = 64
			tmp_item.z_index = 128
			return tmp_item

func split_item() -> InventoryItem:
	if self.is_empty():
		return null
	var inventory = self.get_parent().get_parent() 
	if self.item.amount > 1:
		var new_item :InventoryItem = inventory_item_scene.instantiate()
		new_item.set_data(
			self.item.item_name, self.item.icon,
			self.item.is_stackable, self.item.amount, 
			self.effect , self.effect_amount, self.type
		)
		new_item.amount = self.item.amount / 2
		self.item.amount -= new_item.amount
		inventory.add_child(new_item)
		new_item.z_index = 128
		return new_item 
	elif self.item.amount:
		return self.select_item()
	else:
		return null
		
func use_item() -> void:
	if is_empty():
		return
	if item.type == "Consumable":
		InventoryManager.item_used.emit(item.effect, item.effect_amount)
		item.amount -= 1
		if item.amount <= 0:
			remove_item()


# Is slot empty (has no item)
func is_empty():
	return self.item == null




# Has same kind of item? (same name)
func has_same_item(_item: InventoryItem):
	return _item.item_name == self.item.item_name



func update_slot():
	if item:
		if not self.get_children().has(item):
			add_child(item)
			item.sprite.texture = item.icon
			#item.label.text = str(item.amount) + " - " + str(item.name)
			#If amount ios 0, make iot semi-transparent
		if item.amount < 1:
			item.fade()
	if hint_item:
		if not self.get_children().has(hint_item):
			add_child(hint_item)
		hint_item.fade() # Visually look faded
