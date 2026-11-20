extends CharacterBody2D

class_name Deer

var health = 15.0
const hunger_decay = 0.08
var hunger = 100.0
var axis = "x"
var state = "Idle"
var walk_ready = true
var food_target = null # verify before eating the bus is existing
var sleep_timer := randf_range(60.0, 120.0)  # before nexsleep
const SLEEP_DURATION = 60.0
var chasser = null
var stop_timer := randf_range(3.0, 6.0)
var escaping = false
var speed = 100
var escape_speed = 200
var target = null
var going_to_eat =false
var walking = false
var near_food = []
var direction = "right"
@onready var wake_up_zone: Area2D = $wake_up_zone
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.

func animation_controller():
	var anim = state + "_" + direction
	if animated_sprite_2d.sprite_frames.has_animation(anim) and animated_sprite_2d.animation != anim:
		animated_sprite_2d.play(anim)
		animation_player.play(anim)


func check_wake_up():
	if state in ["Wake_up", "Go_sleep", "Dammage","Escape", "Idle"]:
		return
	for body in wake_up_zone.get_overlapping_bodies():
		if (body is Player or body.is_in_group("enemy") or body.is_in_group("aggresive_animals") or body.is_in_group("human")) and can_see(body):
			if state == "Sleep":
				state = "Wake_up"
				animation_controller()
				
				
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hunger = clampf(hunger - hunger_decay * delta,0.0,100.0)
	if state == "Sleep" :
		velocity = Vector2.ZERO
		sleep_timer -= delta
		if sleep_timer <= 0.0 and not self.escaping:
			state = "Idle"
			sleep_timer = randf_range(30.0, 90.0)  # prochain réveil -> prochaine sieste
	else:
		sleep_timer -= delta
		if sleep_timer <= 0.0 and not escaping:
			state = "Go_sleep"
			sleep_timer = SLEEP_DURATION
	check_wake_up()
	behavior_controller(delta)
	animation_controller()
	

func behavior_controller(delta):
	if state in ["Sleep", "Wake_up", "Go_sleep", "Eat"]:
		velocity = Vector2.ZERO
		return 
	if !walk_ready:
		stop_timer -= delta
		if stop_timer <= 0:
			stop_timer = randf_range(1.0, 7.0)
			self.walk_ready = true
	if state == "Run" and target != null and self.global_position.distance_to(target) <6:
		state = "Idle"
		target = null
		self.walk_ready = false
		if going_to_eat:
			if is_instance_valid(food_target) and food_target in near_food:
				state = "Eat"
				walk_ready = false
				hunger = clampf(hunger + 40, 0.0, 100.0)
			going_to_eat = false
			food_target = null
	if self.escaping == true and self.chasser !=null:
		state = "Escape"
		going_to_eat = false
		var away = global_position - chasser.global_position
		target = global_position + away.normalized() * 100
	else:
		if state != "Run" and self.walk_ready:
			var offset = Vector2(randf_range(-300,300),randf_range(-300,300))
			target = global_position + offset
			state = "Run"
	var food = nearest(near_food)
	if state in ["Idle", "Run"] and hunger < 60 and food and not self.escaping:
			state = "Run"
			food_target = food 
			target = food.global_position
			going_to_eat = true
	if target!= null:
		var SPEED = escape_speed if escaping else speed
		velocity = SPEED * direction_4(target)
	else:
		velocity = Vector2.ZERO

	

func direction_4(target_pos: Vector2) -> Vector2:
	var diff = target_pos - global_position
	if abs(diff.x) < 4 and abs(diff.y) < 4:
		return Vector2.ZERO
	if axis == "x" and abs(diff.x) < 4:
		axis = "y"
	elif axis == "y" and abs(diff.y) < 4:
		axis = "x"
	if axis == "x":
		direction = "right" if diff.x > 0 else "left"
		return Vector2(sign(diff.x), 0)
	else:
		direction = "down" if diff.y > 0 else "up"
		return Vector2(0, sign(diff.y))
	
func nearest(candidates: Array):
	var _nearest = null
	var best_dist = INF
	for c in candidates:
		if not is_instance_valid(c):
			continue
		var d =  self.global_position.distance_squared_to(c.global_position)
		if d < best_dist:
			best_dist = d
			_nearest = c
	return _nearest
		
	
func can_see(t):
	if "in_bush" in t:
		if t.in_bush > 0:
			return false
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(self.global_position, t.global_position)
	query.collision_mask = 2
	query.exclude = [self]
	var result = space.intersect_ray(query) 
	
	return result.is_empty()
func take_dammage(amount: int ):
		self.health -=amount
		if self.health <= 0:
			self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group("enemy") or body.is_in_group("aggresive_animals") or body.is_in_group("human"):
		self.escaping = true 
		self.state = "Escape"
		self.chasser = body
		self.going_to_eat = false
		self.food_target = null
		

func _on_interac_area_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.is_in_group("food_bush"):
		near_food.append(area)


func _on_interac_area_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.is_in_group("food_bush"):
		near_food.erase(area)


func _on_wake_up_zone_body_entered(body: Node2D) -> void:
	if (body.is_in_group("enemy") or body.is_in_group("aggresive_animals") or body.is_in_group("human")) and state == "Sleep":
		self.state = "Wake_up"


func _on_animated_sprite_2d_animation_finished() -> void:
	if state == "Wake_up":
		state = "Idle"
	if state == "Go_sleep":
		state = "Sleep"
	if state == "Eat":
		state = "Idle"


func _on_area_2d_body_exited(body: Node2D) -> void:
		if body is Player or body.is_in_group("enemy") or body.is_in_group("aggresive_animals") or body.is_in_group("human"):
			self.escaping = false
			self.state = "Idle"
			self.chasser = null
			self.target = null
			self.going_to_eat = false
			self.food_target = null
			self.sleep_timer = randf_range(30.0, 90.0)
