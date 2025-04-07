extends Node2D

var coins: int = 0

var fuel_tank_level: int = 0
const FUEL_UPGRADE_AMOUNT = 20
const FUEL_UPGRADE_COST = 100

var wheel_power_level: int = 0
const WHEEL_UPGRADE_COST = 150 

var double_bullet_unlocked: bool = false
const DOUBLE_BULLET_COST = 300

func _ready():
	$backButton.connect("pressed", Callable(self, "_on_back_button_pressed"))
	$FuelTankButton.connect("pressed", Callable(self, "_on_fuel_tank_button_pressed"))
	$DoubleBulletButton.connect("pressed", Callable(self, "_on_double_bullet_button_pressed"))
	load_data()
	#load_coins()
	update_coin_label()  
	update_fuel_button_label() 
	
	update_wheel_button_label()
	
	update_double_bullet_button_label()

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
	
	config.set_value("upgrades", "wheel_power_level", wheel_power_level)
	
	config.set_value("upgrades", "wheel_power_level", wheel_power_level)
	config.set_value("upgrades", "double_bullet_unlocked", double_bullet_unlocked)  # Save flag
	config.save("user://player_data.cfg")
	
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
		
	wheel_power_level = config.get_value("upgrades", "wheel_power_level", 0)
	double_bullet_unlocked = config.get_value("upgrades", "double_bullet_unlocked", false)

func update_coin_label():
	$Label2.text = "Coins: " + str(coins)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_fuel_tank_button_pressed():
	if fuel_tank_level < 10:
		if coins >= FUEL_UPGRADE_COST:
			coins -= FUEL_UPGRADE_COST
			fuel_tank_level += 1
			save_data()
			update_coin_label()
			update_fuel_button_label()
			print("Upgraded Fuel Tank to Level:", fuel_tank_level)
		else:
			print("Not enough coins!")
	else:
		print("Fuel tank is already maxed out!")

func update_fuel_button_label():
	if fuel_tank_level >= 10:
		$FuelTankButton.text = "Fuel Tank MAXED (Level 10)"
	else:
		$FuelTankButton.text = "Upgrade Fuel Tank (Level " + str(fuel_tank_level) + ") - " + str(FUEL_UPGRADE_COST) + " coins"


func _on_wheel_power_button_pressed():
	if wheel_power_level < 10:
		if coins >= WHEEL_UPGRADE_COST:
			coins -= WHEEL_UPGRADE_COST
			wheel_power_level += 1
			save_data()
			update_coin_label()
			update_wheel_button_label()
			print("Upgraded Wheel Power to Level:", wheel_power_level)
		else:
			print("Not enough coins for Wheel Power Upgrade!")
	else:
		print("Wheel power is already maxed out!")

func update_wheel_button_label():
	if wheel_power_level >= 10:
		$WheelPowerButton.text = "Wheel Power MAXED (Level 10)"
	else:
		$WheelPowerButton.text = "Upgrade Wheel Power (Level " + str(wheel_power_level) + ") - " + str(WHEEL_UPGRADE_COST) + " coins"

func _on_double_bullet_button_pressed():
	if double_bullet_unlocked:
		print("Double Bullets already unlocked!")
		return

	if coins >= DOUBLE_BULLET_COST:
		coins -= DOUBLE_BULLET_COST
		double_bullet_unlocked = true
		save_data()
		update_coin_label()
		update_double_bullet_button_label()
		print("Double Bullets Unlocked!")
	else:
		print("Not enough coins for Double Bullets!")


func update_double_bullet_button_label():
	if double_bullet_unlocked:
		$DoubleBulletButton.text = "Double Bullets UNLOCKED!"
		$DoubleBulletButton.disabled = true
	else:
		$DoubleBulletButton.text = "Unlock Double Bullets - " + str(DOUBLE_BULLET_COST) + " Coins"
		$DoubleBulletButton.disabled = false
