extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("is_boosting") and body.is_boosting():
			print("CAR ENTERED MUD BUT IS BOOSTING — skipping slowdown")
			return  # Skip mud effect while boosting

		if body.has_method("set_max_speed"):  
			body.set_max_speed(10)
			body.set_linear_damp(10)
			body.reduce_wheel_power(0.5)
		print("DETECTED CAR IN MUD - from mud")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("set_max_speed"):
			body.set_max_speed(50)  # Reset max speed  
			body.set_linear_damp(1)  # Keep a little resistance for realism  
			body.reduce_wheel_power(1)  # Restore full power  
		print("DETECTED CAR OUTSIDE MUD - from mud")
