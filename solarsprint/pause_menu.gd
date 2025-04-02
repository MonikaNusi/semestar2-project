extends CanvasLayer

@onready var resume_button = $Control/VBoxContainer/resume
@onready var restart_button = $Control/VBoxContainer/restart
@onready var exit_button = $Control/VBoxContainer/exit

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_resume_pressed():
	print("Resume button pressed!")
	get_tree().paused = false
	queue_free()  # Remove the pause menu when resuming

func _on_restart_pressed():
	if self:
		queue_free()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed():
	if self:
		queue_free()  
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
