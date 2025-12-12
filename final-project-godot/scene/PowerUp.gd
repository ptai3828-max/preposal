extends Area2D

# 0 = heal, 1 = speed, 2 = invincible
@export var type := 0


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.apply_powerup(type)
		print("Something touched the powerup", body)
		queue_free()
