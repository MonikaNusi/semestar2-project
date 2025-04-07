extends StaticBody2D

var restored := false

func restore():
	if restored:
		return
	
	restored = true
	
	if has_node("SS2D_Shape_Closed"):
		var visual = $SS2D_Shape_Closed
		visual.modulate = Color(0.4, 1.0, 0.4)  # Bright green

	print("Platform restored at:", global_position)
