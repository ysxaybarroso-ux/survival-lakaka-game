extends Node

var items : Dictionary ={}
const PATH_FILES = "res://Inventory/Item/tres/"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at(PATH_FILES):
		file = file.trim_suffix(".remap")
		if file.ends_with(".tres"):
			var res = load(PATH_FILES + file)
			if res is ItemData:
				if items.has(res.id):
					push_error("error double id"+ res.id)
				items[res.id]= res

func get_item(id: String) -> ItemData:
	return items.get(id)
