extends CanvasLayer

@onready var restart_button = $Control/restart
@onready var main_menu_button = $Control/exit
@onready var next_level_button = $Control/next
@onready var distance_label = $Control/distanceLabel
@onready var high_score_label = $Control/highscoreLabel

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)
	

	var fact_screen = load("res://scenes/FactScreen.tscn").instantiate()
	var fact_manager = load("res://scripts/FactManager.gd").new()
	fact_screen.fact_manager = fact_manager
	add_child(fact_screen)

	fact_screen.next_pressed.connect(_on_fact_next)
	

func update_scores(distance, high_score):
	# Display the distance travelled and high score
	distance_label.text = "Distance: " + str(distance) + "m"
	high_score_label.text = "High Score: " + str(high_score) + "m"

func _on_fact_next():
	print("Player closed fact screen on Game Win.")

func _on_restart_pressed():
	queue_free()
	get_tree().paused = false  # Unpause before restarting
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	queue_free()
	get_tree().paused = false  # Unpause before going to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_next_level_pressed():
	queue_free()
	get_tree().paused = false

	var current_scene = get_tree().current_scene.scene_file_path

	match current_scene:
		"res://scenes/levels/level_1.tscn":
			get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
		"res://scenes/levels/level_2.tscn":
			get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")
		_:
			print("Unknown level or final level reached.")
			get_tree().change_scene_to_file("res://scenes/level_select.tscn")
