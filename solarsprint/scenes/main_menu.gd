extends Node2D

func _ready():
	$startButton.connect("pressed", Callable(self, "_on_start_button_pressed"))
	$exitButton.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	$shopButton.connect("pressed", Callable(self, "_on_shop_button_pressed"))
	$levelsButton.connect("pressed", Callable(self, "_on_levels_button_pressed"))

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
	
func _on_shop_button_pressed():
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	
func _on_levels_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
