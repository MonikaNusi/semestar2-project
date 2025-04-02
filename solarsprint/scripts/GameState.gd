extends Node

var current_level = 1
var level_1_completed = false

func load_progress():
	var config = ConfigFile.new()
	if config.load("user://progress.cfg") == OK:
		level_1_completed = config.get_value("progress", "level_1_completed", false)

func save_progress():
	var config = ConfigFile.new()
	config.set_value("progress", "level_1_completed", level_1_completed)
	config.save("user://progress.cfg")

func _ready():
	load_progress()
