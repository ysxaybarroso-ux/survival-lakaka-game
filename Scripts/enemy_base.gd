extends AnimatedSprite2D

class_name Enemy_base
const dammage = 1.0
const SPEED = 80.0
const SPEED_WANDER = 60.0
var health = 5.0
var state = "dodo"
var can_dammage = true
var wander_direction = Vector2.ZERO
var wander_time = 0.0
var on_zone = false
var player = null
var cible = null
@onready var death_zone: Area2D = $death_zone
@onready var wake_up_zone: Area2D = $wake_up_zone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_controler()

func animation_controler():
	if state == "degat":
		self.play("Dammage")
		
	elif state == "dodo":
		self.play("Sleep")
	elif state == "reveil":
		self.play("Wake up")
	elif state == "reveillee":
		self.play("Idle")
	elif state == "go dodo":
		self.play("Go sleep")
	
func take_dammage(amount):
	health -= amount
	state = "degat"
	if health <= 0:
		self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dps_controller()
	if state not in ["dodo", "reveil" ,"go dodo"]:
		player_tracker(delta)


func player_tracker(delta):
	if cible != null:
		self.global_position += SPEED * delta * global_position.direction_to(cible.global_position)
	else:
		wander(delta)
		

func wander(delta):
	wander_time -= delta
	if wander_time <= 0.0:
		if wander_direction == Vector2.ZERO:
			wander_direction = Vector2.from_angle(randf_range(0, TAU))
		else:
			var turn = randf_range(-PI/2, PI/2)
			var side = [1, -1].pick_random()
			wander_direction = wander_direction.rotated(turn * side)
		wander_time = 0.4
	global_position += SPEED_WANDER * delta * wander_direction
	
func dps_controller():
	if on_zone and can_dammage and state not in ["dodo", "reveil"] and player != null:
		can_dammage = false
		player.take_dammage(dammage)
		await get_tree().create_timer(2.0).timeout
		can_dammage = true
		
func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		on_zone = true 
		player = body

func _on_wake_up_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		state = "reveil"
		animation_controler()
		cible = body


func _on_animation_finished() -> void:
	if animation == "Wake up":
		state = "reveillee"
		animation_controler()
	if animation == "Dammage":
		state = "reveil"
		animation_controler()
	if animation == "Idle":
		state = "reveillee"
		animation_controler()
	if animation == "Go sleep":
		state = "dodo"
		animation_controler()



func _on_wake_up_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		cible = null
		await get_tree().create_timer(10).timeout
		state = "go dodo"
		animation_controler()


func _on_death_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		on_zone = false
		player = null
