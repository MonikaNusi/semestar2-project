extends CanvasLayer

@onready var restart_button = $Control/restart
@onready var main_menu_button = $Control/exit
@onready var next_level_button = $Control/next

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure it works when the game is paused
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)

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
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
