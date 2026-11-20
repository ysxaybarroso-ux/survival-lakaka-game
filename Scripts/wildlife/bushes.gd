extends AnimatedSprite2D





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
