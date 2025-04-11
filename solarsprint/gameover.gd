extends CanvasLayer

@onready var distance_label = $Control/distanceLabel
@onready var high_score_label = $Control/highscoreLabel
@onready var main_menu_button = $Control/exit

func _ready():
	print("Game Over UI loaded!")
	get_tree().paused = false

	var fact_screen = load("res://scenes/FactScreen.tscn").instantiate()
	var fact_manager = load("res://scripts/FactManager.gd").new()
	fact_screen.fact_manager = fact_manager
	add_child(fact_screen)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	fact_screen.next_pressed.connect(_on_fact_next)


	var button = $Control/restartButton
	if button:
		button.connect("pressed", Callable(self, "_on_button_pressed"))
		print("Restart button connected!")
	else:
		print("Restart button not found!")
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func _on_main_menu_pressed():
	queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


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
	
func _on_fact_next():
	print("Player closed fact screen on Game Over.")
