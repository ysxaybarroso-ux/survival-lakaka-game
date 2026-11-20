extends RefCounted
class_name ItemStack

var data: ItemData
var amount :int =1
var uses_left :int = 0

func _init(_data: ItemData, _amount: int = 1) -> void:
	self.data = _data
	self.amount = _amount
	self.uses_left = _data.max_use

func to_dict() -> Dictionary:
	return {"id":data.id, "amount":amount,"uses_left": uses_left}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
