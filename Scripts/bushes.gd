extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	if animation == "Move":
		self.play("Idle")

func _on_enter_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		self.play("Move")
		body.in_bush +=1


func _on_enter_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		self.play("Move")
		body.in_bush -=1
