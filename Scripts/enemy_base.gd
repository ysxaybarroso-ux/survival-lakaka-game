extends CharacterBody2D

class_name Enemy_base
const dammage = 1.0
const SPEED = 80.0
const SPEED_WANDER = 60.0
var health = 5.0
var state = "dodo"
var can_dammage = true
var wander_direction = Vector2.ZERO
var last_seen_pos = null
var wander_time = 0.0
var on_zone = false
var player = null
var cible = null
@onready var death_zone: Area2D = $death_zone
@onready var wake_up_zone: Area2D = $wake_up_zone
@onready var sprite : AnimatedSprite2D = $Enemy_base
@onready var agent: NavigationAgent2D = $NavigationAgent2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	animation_controler()

func move_to(point):
	agent.target_position = point 
	var next = agent.get_next_path_position()
	velocity = SPEED * global_position.direction_to(next)
	
func animation_controler():
	if state == "degat":
		sprite.play("Dammage")
		
	elif state == "dodo":
		sprite.play("Sleep")
	elif state == "reveil":
		sprite.play("Wake up")
	elif state == "reveillee":
		sprite.play("Idle")
	elif state == "go dodo":
		sprite.play("Go sleep")
	
func take_dammage(amount):
	health -= amount
	state = "degat"
	if health <= 0:
		self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	check_wake_up()
	dps_controller()
	if state not in ["dodo", "reveil" ,"go dodo"]:
		player_tracker(delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func can_see(t) -> bool:
	if t.in_bush > 0:
		return false
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(self.global_position,t.global_position)
	query.collision_mask = 2
	query.exclude = [self]
	var result = space.intersect_ray(query)
	return result.is_empty()
	
func player_tracker(delta):
	if cible != null and can_see(cible):
		last_seen_pos = cible.global_position
		velocity = SPEED  * global_position.direction_to(cible.global_position)
	elif last_seen_pos != null:
		if global_position.distance_to(last_seen_pos) < 5:
			last_seen_pos = null
		else:
			move_to(last_seen_pos)
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
	velocity = SPEED_WANDER  * wander_direction
	
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

func check_wake_up():
	if state in ["reveil", "go dodo", "degat"]:
		return
	for body in wake_up_zone.get_overlapping_bodies():
		if body is Player and can_see(body):
			if state == "dodo":
				state = "reveil"
				animation_controler()
			cible = body


func _on_wake_up_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		cible = null
		last_seen_pos = body.global_position
		await get_tree().create_timer(8).timeout
		if cible == null:
			state = "go dodo"
			animation_controler()


func _on_death_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		on_zone = false
		player = null


func _on_enemy_base_animation_finished() -> void:
	if sprite.animation == "Wake up":
		state = "reveillee"
		animation_controler()
	if sprite.animation == "Dammage":
		state = "reveil"
		animation_controler()
	if sprite.animation == "Idle":
		state = "reveillee"
		animation_controler()
	if sprite.animation == "Go sleep":
		state = "dodo"
		animation_controler()
