extends Item
class_name InventoryItem


@export var texture_use : ProgressBar
@export var sprite: Sprite2D
@export var label: Label
var stack: ItemStack = null

var fill_style :StyleBoxFlat

func set_data(_name: String, _icon: Texture2D, _is_stackable: bool, _amount: int, _effect : String , _effect_amount: int , _type: String, _hand_icon: Texture, _weapon_type:String, _max_use : int):
	self.item_name = _name
	self.name = _name
	self.icon = _icon
	self.is_stackable = _is_stackable
	self.amount = _amount
	self.effect = _effect
	self.effect_amount = _effect_amount
	self.type = _type
	self.hand_icon =_hand_icon
	self.weapon_type = _weapon_type
	self.max_use = _max_use

func _ready() -> void:
	super()
	self.fill_style = StyleBoxFlat.new()
	self.texture_use.add_theme_stylebox_override("fill", fill_style)

func _process(_delta):
	self.texture_use.max_value = max_use
	self.texture_use.value = amount
	self.sprite.texture = self.icon
	var ratio = 0.0 
	if max_use > 0:
		ratio = float(amount) / max_use
	else: 
		ratio = 0.0
	fill_style.bg_color = Color.RED.lerp(Color.GREEN, ratio)
	self.set_sprite_size_to(sprite, Vector2(42, 42))
	if is_stackable:
		self.label.text = str(self.amount)
	else:
		label.visible = false
	if type != "Equipment" or max_use == 0:
		self.texture_use.visible = false
	else:
		self.texture_use.visible = true



func set_sprite_size_to(target: Sprite2D, size: Vector2):
	if target.texture == null:
		return
	var texture_size = target.texture.get_size()
	if texture_size.x == 0 or texture_size.y == 0:
		return
	target.scale = Vector2(size.x / texture_size.x, size.y / texture_size.y)



func fade():
	self.sprite.modulate = Color(1, 1, 1, 0.4)
	self.label.modulate = Color(1, 1, 1, 0.4)
