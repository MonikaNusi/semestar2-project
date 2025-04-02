extends CanvasLayer

@onready var distance_label = $Control/distanceLabel
@onready var high_score_label = $Control/highscoreLabel

func _ready():
	print("Game Over UI loaded!")
	get_tree().paused = false  # Unpause the game when the UI loads

	var button = $Control/restartButton  # Ensure this path is correct
	if button:
		button.connect("pressed", Callable(self, "_on_button_pressed"))
		print("Restart button connected!")
	else:
		print("Restart button not found!")
	process_mode = Node.PROCESS_MODE_ALWAYS

func update_scores(distance, high_score):
	# Display the distance travelled and high score
	distance_label.text = "Distance: " + str(distance) + "m"
	high_score_label.text = "High Score: " + str(high_score) + "m"

func _on_button_pressed():
	print("Restart button pressed!")

	# Remove the Game Over screen before restarting
	queue_free()

	# Unpause and reload the scene
	get_tree().paused = false
	get_tree().reload_current_scene()
