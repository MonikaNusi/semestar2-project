extends Node2D

var coins_collected = 0
var start_x = 0
var distance_travelled = 0
var high_score = 0
var fuel_upgraded: bool = false


@onready var music = $player/backgroudMusic

@onready var car = get_node("player")
@onready var distance_label = $UI/Control/distance
@onready var high_score_label = $UI/Control/highscore
var distance_scaling_factor = 10


@onready var pause_button = $UI/Control/pauseButton
var pause_menu_instance = null

func _ready():
	
	load_coins()
	
	start_x = car.position.x
	
	var config = ConfigFile.new()
	if config.load("user://player_data.cfg") == OK:
		var fuel_level = config.get_value("upgrades", "fuel_tank_level", 0)
		fuel_upgraded = fuel_level > 0
	
	if music:
		music.play()
	
	pause_button.pressed.connect(_on_pause_button_pressed)
	
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		high_score = file.get_var()
		file.close()
		
		if high_score > 10000: 
			print("High score too large, resetting to 0.")
			high_score = 0
	

	high_score_label.text = "High Score: " + str(high_score) + "m"

func _on_pause_button_pressed():
	print("Pause button pressed!")
	var player = get_node("player")
	if player:
		player.toggle_pause() 
		
@export var energy_leech_scene: PackedScene



func _physics_process(delta):
	distance_travelled = int((car.position.x - start_x) / distance_scaling_factor)
	distance_label.text = "Distance: " + str(distance_travelled) + "m"

	if distance_travelled > high_score:
		high_score = distance_travelled
		high_score_label.text = "High Score: " + str(high_score) + "m"
		save_high_score()



func add_coins(amount):
	coins_collected += amount
	update_coin_UI()
	save_coins()
	$UI/coin/Label.text = str(coins_collected)
	
func load_coins():
	var config = ConfigFile.new()
	var err = config.load("user://player_data.cfg")
	if err == OK:
		coins_collected = config.get_value("player_data", "coins", 0)
	else:
		coins_collected = 0
		print("No saved coins found, starting from 0")

func save_coins():
	var config = ConfigFile.new()
	var err = config.load("user://player_data.cfg")
	if err != OK:
		print("No existing config, creating new.")

	var fuel_level = config.get_value("upgrades", "fuel_tank_level", 0)
	config.set_value("player_data", "coins", coins_collected)
	config.set_value("upgrades", "fuel_tank_level", fuel_level)
	config.save("user://player_data.cfg")
	
func update_coin_UI():
	$UI/coin/Label.text = str(coins_collected)
	
func update_fuel_UI(value):
	var player = get_node("player")
	if player:
		var bar = $UI/fuel/ProgressBar
		bar.max_value = player.max_fuel
		bar.value = value

		# Resize width based on max_fuel
		var base_width = 100  # width for 100 max fuel
		var new_width = base_width + (player.max_fuel - 100) * 1.5
		bar.size.x = new_width 
		print("Fuel bar resized to:", new_width)
		
	if value == 0:
		$UI/fuel/AnimationPlayer.play("alarm")
	else:
		$UI/fuel/AnimationPlayer.play("idle")

	
func save_high_score():
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_var(high_score)
	file.close()
	print("High score saved: ", high_score)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		save_high_score()  
		save_coins()
