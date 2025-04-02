extends Node2D

@onready var sprite = $Sprite2D  # Adjust based on your smoke structure
var fade_value = 0.0
var fading = false

func _ready():
	add_to_group("smoke")

func _process(delta):
	if fading:
		fade_value += delta * 2.0  # Adjust the speed of fading
		fade_value = clamp(fade_value, 0.0, 1.0)  # Ensure it stays within range
		sprite.material.set_shader_parameter("fade_amount", fade_value)
		print("Fading smoke:", fade_value)  # Debugging
		if fade_value >= 1.0:
			print("Smoke fully faded, removing it.")
			queue_free()  # Remove the smoke

func clear_smoke():
	print("clear_smoke() called!")
	fading = true 
