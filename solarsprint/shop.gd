extends Node2D

var coins: int = 0

var fuel_tank_level: int = 0
const FUEL_UPGRADE_AMOUNT = 20
const FUEL_UPGRADE_COST = 100

func _ready():
	$backButton.connect("pressed", Callable(self, "_on_back_button_pressed"))
	$FuelTankButton.connect("pressed", Callable(self, "_on_fuel_tank_button_pressed"))
	load_data()
	#load_coins()
	update_coin_label()  
	update_fuel_button_label() 

func load_coins():
	var config = ConfigFile.new()
	var err = config.load("user://player_data.cfg")
	if err == OK:
		coins = config.get_value("player_data", "coins", 0)
	else:
		coins = 0
		print("Failed to load coins. Starting at 0.")

func save_data():
	var config = ConfigFile.new()
	
	# Preserve any other data (like coins and fuel_tank_level)
	var err = config.load("user://player_data.cfg")
	if err != OK:
		print("Creating new config file.")
		
	config.set_value("player_data", "coins", coins)
	config.set_value("upgrades", "fuel_tank_level", fuel_tank_level)
	print("Saving fuel_tank_level =", fuel_tank_level)
	config.save("user://player_data.cfg")
	
func load_data():
	var config = ConfigFile.new()
	var err = config.load("user://player_data.cfg")
	if err == OK:
		coins = config.get_value("player_data", "coins", 0)
		fuel_tank_level = config.get_value("upgrades", "fuel_tank_level", 0)#
		print("Loaded fuel_tank_level =", fuel_tank_level)
	else:
		coins = 0
		fuel_tank_level = 0

func update_coin_label():
	$Label2.text = "Coins: " + str(coins)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_fuel_tank_button_pressed():
	if coins >= FUEL_UPGRADE_COST:
		coins -= FUEL_UPGRADE_COST
		fuel_tank_level += 1
		save_data()
		update_coin_label()
		update_fuel_button_label()
		print("Upgraded Fuel Tank to Level:", fuel_tank_level)
	else:
		print("Not enough coins!")

func update_fuel_button_label():
	$FuelTankButton.text = "Upgrade Fuel Tank (Level " + str(fuel_tank_level) + ") - " + str(FUEL_UPGRADE_COST) + " coins"
