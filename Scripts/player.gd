extends CharacterBody2D

class_name Player

var health = 10.0
const SPEED = 250.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func animation_player(direction_x, direction_y):
	if direction_x or direction_y:
		self.animated_sprite_2d.play("Run")
	else: 
		self.animated_sprite_2d.play("Idle")

func take_dammage(amount):
	self.health -= amount
	if health <= 0:
		self.queue_free()

func _physics_process(_delta: float) -> void:
	var direction_x := Input.get_axis("Left", "Right")
	var direction_y := Input.get_axis("Up", "Down")
	
	animation_player(direction_x , direction_y)
	# Get the input direction and handle the movement/deceleration.
	
	if direction_x and !direction_y:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
		
	#same for up down
	if direction_y and !direction_x:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
		
	if direction_x < 0:
		self.animated_sprite_2d.flip_h = true
	elif direction_x > 0 :
		self.animated_sprite_2d.flip_h = false

	move_and_slide()
