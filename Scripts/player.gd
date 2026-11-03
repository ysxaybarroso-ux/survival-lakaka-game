extends CharacterBody2D

class_name Player
@onready var health_bar: TextureProgressBar = $Health_bar
@onready var health_bar_anim: AnimatedSprite2D = $Health_bar/AnimatedSprite2D
@onready var thirst_bar: TextureProgressBar = $lives_bars/ThirstBar
@onready var thirst_pivot: Node2D = $lives_bars/ThirstBar/Pivot
@onready var hunger_bar: TextureProgressBar = $lives_bars/HungerBar
@onready var hunger_pivot: Node2D = $lives_bars/HungerBar/Pivot
@onready var endurance_bar: TextureProgressBar = $Endurance_bar
@onready var hand_anim : AnimationPlayer = $player_hand_anim
@onready var hand_pivot: Node2D = $hand_pivot
@onready var short_distance_area: Area2D = $equipement_area/short_distance



var temperature =20 
var nearby_collectible = null
var is_freezing = false
var is_burning =  false
var DASH_DURATION = 0.5
var dash_time = 0.0
var dash_velocity = Vector2.ZERO
const HUNGER_DECAY =  0.033
const THIRST_DECAY = 0.05
const TEMPERATURE_DECAY = 0.7
var ENDURANCE_DECAY = 1.3
var health = 10.0
var endurance = 20.0
var endurance_max = 20.0
var endurance_cible = 20.0
var thirst = 100.0
var thirst_cible = 100.0
var temperature_state: String = "mid"
var hunger = 100.0
var weapon_suffix = ""
var hunger_cible = 100.0
const SPEED = 250.0
const DASH_SPEED = 500.0
var in_dash = false
var dash_consumption = 10.0
const jauge_speed = 5.0
const jauge_speed_endurance = 10.0
var in_bush = 0
var horizontal_direction = "right"
var vertical_direction = null
var short_distance_enemy =[]
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
		health_bar.max_value = health
		health_bar.value = health
		InventoryManager.item_used.connect(_on_item_used)
		InventoryManager.equipment_used.connect(_on_equipment_used)
		
func animation_player(direction_x, direction_y):
	
	hand_pivot.visible = not in_dash and weapon_suffix !=""
	# action
	var action = "Idle"
	if direction_x != 0 or direction_y != 0:
		action = "Dash" if in_dash else "Run"


	var dir_name = "horizontal"
	if vertical_direction != null and (direction_y != 0 or direction_x == 0):
		dir_name = vertical_direction  # "up" ou "down"

	var suffix = "_" + weapon_suffix if weapon_suffix != "" else ""

	animated_sprite_2d.play(action + "_" + dir_name + suffix)
	hand_anim.play(action + "_" + dir_name +  suffix)

func freeze_dammage(amount):
	self.health -= amount 
func take_dammage(amount):
	self.health -= amount
	health_bar.value = self.health
	if health <= 0:
		self.queue_free()
	elif health <= 3:
		health_bar_anim.play("critic")
	elif health <= 6:
		health_bar_anim.play("mid")
	elif health >= 7:
		health_bar_anim.play("full")
		
func _on_item_used(effect: String, amount: int) -> void:
	if effect == "Thirst":
		thirst_cible = clampf(thirst_cible + amount,0.00, 100.0)
	if effect == "Hunger": 
		hunger_cible = clampf(hunger_cible + amount,0.00, 100.0)

func _on_equipment_used(item_name:  String, effect: String, effect_amount: int, direction_x, direction_y):
	if  effect == "Stun":
		if item_name == "Taser":
			pass
func _physics_process(delta: float) -> void:
	core_mouvement(delta)

func core_mouvement(delta):
	var direction_x := Input.get_axis("Left", "Right")
	var direction_y := Input.get_axis("Up", "Down")
	
	animation_player(direction_x, direction_y)
	# Get the input direction and handle the movement/deceleration
	
	if Input.is_action_just_pressed("Dash") and not in_dash and endurance >= dash_consumption:
		var dir = Vector2.ZERO
		if direction_x and not direction_y:
			dir = Vector2(direction_x , 0)
		elif direction_y and not direction_x:
			dir = Vector2(0, direction_y )
		elif not direction_x and not direction_y: #immobile
			if vertical_direction == "up":
				dir = Vector2(0, -1)
			elif vertical_direction == "down":
				dir = Vector2(0,1)
			elif horizontal_direction == "right":
				dir = Vector2(1,0)
			else:
				dir = Vector2(-1,0)
		if dir != Vector2.ZERO:
			endurance_cible -= dash_consumption
			in_dash = true
			dash_time = DASH_DURATION
			dash_velocity = dir * DASH_SPEED
			
	if in_dash: #dash cmpt
		velocity = dash_velocity
		dash_time -= delta
		if dash_time <= 0:
			in_dash = false
	else: # no dash so mouvement
		if direction_x and !direction_y:
			self.velocity.x = direction_x * SPEED
		else:
			self.velocity.x = move_toward(velocity.x, 0, SPEED)
		if direction_y and !direction_x:
			self.velocity.y = direction_y * SPEED
		else:
			self.velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if direction_x < 0:
		self.animated_sprite_2d.flip_h = true
		self.short_distance_area.position = Vector2(-20,0.0)
		horizontal_direction = "left"
	elif direction_x > 0 :
		self.animated_sprite_2d.flip_h = false
		self.short_distance_area.position = Vector2(20,0.0)
		horizontal_direction = "right"
	elif not direction_x and direction_y:
		horizontal_direction = null
		
	if direction_y < 0:
		vertical_direction = "up"
		self.short_distance_area.position = Vector2(0.0,-16.0)
		
	elif direction_y > 0 :
		vertical_direction = "down"
		self.short_distance_area.position = Vector2(0.0,11.2)
	elif not direction_y and direction_x:
		vertical_direction = null

	move_and_slide()
	
func _process(delta: float) -> void:
	endurance_bar.max_value = endurance_max
	
	hunger = move_toward(hunger , hunger_cible, jauge_speed* delta)
	thirst = move_toward(thirst, thirst_cible,jauge_speed * delta)
	endurance = move_toward(endurance, endurance_cible, jauge_speed_endurance * delta)
	thirst_bar.value = thirst
	thirst_pivot.rotation_degrees = thirst/100 * 360
	hunger_bar.value = hunger
	hunger_pivot.rotation_degrees = hunger/100 * 360
	endurance_bar.value = endurance
	

	endurance_cible = clampf(endurance_cible + ENDURANCE_DECAY * delta ,0.00, endurance_max)
	thirst_cible = clampf(thirst_cible - THIRST_DECAY * delta,0.0,100.0)
	hunger_cible = clampf(hunger_cible - HUNGER_DECAY * delta,0.0,100.0)
	 
	if Input.is_action_just_pressed("interact") and nearby_collectible and !InventoryManager.is_open:
		InventoryManager.add_item(nearby_collectible, 1)
		nearby_collectible = null
		
	for i in range(6):
		if Input.is_action_just_pressed("Slot_" + str(i + 1)):
			InventoryManager.equipped_slot = i
			InventoryManager.equipped_changed.emit(i)
			print("slot en main : ", i)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Items"):
		nearby_collectible = area

func temperatureManager(delta):
	if temperature <= -5:
		is_burning = false
		await get_tree().create_timer(4).timeout
		take_dammage(1)
	if temperature  >= 45:
		is_freezing = false 
		await get_tree().create_timer(4).timeout
		take_dammage(1)
	if is_freezing:
		temperature -= clampf(TEMPERATURE_DECAY * delta, -20,60)
	if is_burning:
		temperature -=  clampf(TEMPERATURE_DECAY * delta,-20,60)
			

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Items"):
		nearby_collectible = null 


func _on_short_distance_body_entered(body: Node2D) -> void:
	print("in", body)
	if body.is_in_group("enemy"):
		short_distance_enemy.append(body)
		print("in")


func _on_short_distance_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		short_distance_enemy.erase(body)
		print("out")
