extends Resource
class_name ItemData

@export var id: String = ""            # identifiant unique, ex: "taser"
@export var display_name: String = ""
@export var icon: Texture2D
@export var hand_icon: Texture2D
@export var stack_size: int = 1        # 1 = non empilable (remplace is_stackable)
@export_enum("Consumable", "Equipment","Materials") var type: String = "Consumable"
@export_enum("Thirst", "Hunger", "Stun","none","fireworks") var effect: String = ""
@export var effect_amount: int = 0
@export_enum("none", "2_hand_sword", "1_hand_sword", "2_hand_gun", "1_hand_gun", "launcher", "knife", "grenade") var weapon_type: String = "none"
@export var max_use: int = 0           # 0 = pas de durabilité
