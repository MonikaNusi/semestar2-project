extends CanvasLayer

@onready var level1_button = $Control/level1
@onready var level2_button = $Control/level2
@onready var back_button = $Control/backButton

func _ready():
	level1_button.pressed.connect(_on_level1_pressed)
	level2_button.pressed.connect(_on_level2_pressed)
	back_button.pressed.connect(_on_back_pressed)

	# Load saved progress from disk
	var config = ConfigFile.new()
	var err = config.load("user://progress.cfg")
	var level_1_done = false

	if err == OK:
		level_1_done = config.get_value("progress", "level_1_completed", false)

	# Enable or lock Level 2
	if level_1_done:
		level2_button.disabled = false
	else:
		level2_button.disabled = true
		level2_button.text = "Level 2 (Locked)"

func _on_level1_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_level2_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
