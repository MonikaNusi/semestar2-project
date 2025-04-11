extends Node2D

var coins: int = 0

var fuel_tank_level: int = 0
const FUEL_UPGRADE_AMOUNT = 20
#const FUEL_UPGRADE_COST = 100

var wheel_power_level: int = 0
#const WHEEL_UPGRADE_COST = 150 

var double_bullet_unlocked: bool = false
const DOUBLE_BULLET_COST = 300

var speed_boost_unlocked: bool = false
const SPEED_BOOST_COST = 250

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
	update_speed_boost_button_label() 

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
	config.set_value("upgrades", "double_bullet_unlocked", double_bullet_unlocked)
	
	config.set_value("upgrades", "speed_boost_unlocked", speed_boost_unlocked)
	
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
	speed_boost_unlocked = config.get_value("upgrades", "speed_boost_unlocked", false)

func update_coin_label():
	$Label2.text = "Coins: " + str(coins)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_fuel_tank_button_pressed():
	if fuel_tank_level < 10:
		var cost = get_fuel_upgrade_cost(fuel_tank_level)
		if coins >= cost:
			coins -= cost
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
		$FuelTankButton.text = "solar panel MAXED (Level 10)"
		$FuelTankButton.disabled = true 
	else:
		var cost = get_fuel_upgrade_cost(fuel_tank_level)
		$FuelTankButton.text = "Upgrade solar panel (Level " + str(fuel_tank_level) + ") - " + str(cost) + " coins"
		$FuelTankButton.disabled = false
func get_fuel_upgrade_cost(level: int) -> int:
	return 100 + level * 50

func _on_wheel_power_button_pressed():
	if wheel_power_level < 10:
		var cost = get_wheel_upgrade_cost(wheel_power_level)
		if coins >= cost:
			coins -= cost
			wheel_power_level += 1
			save_data()
			update_coin_label()
			update_wheel_button_label()
			print("Upgraded Wheel Power to Level:", wheel_power_level)
		else:
			print("Not enough coins for Wheel Power Upgrade!")
	else:
		print("Wheel power is already maxed out!")

func get_wheel_upgrade_cost(level: int) -> int:
	# Level 1 upgrade = 150, increases by 50 each level
	return 100 + level * 50

func update_wheel_button_label():
	if wheel_power_level >= 10:
		$WheelPowerButton.text = "Wheel Power MAXED (Level 10)"
		$WheelPowerButton.disabled = true
	else:
		var cost = get_wheel_upgrade_cost(wheel_power_level)
		$WheelPowerButton.text = "Upgrade Wheel Power (Level " + str(wheel_power_level) + ") - " + str(cost) + " coins"
		$WheelPowerButton.disabled = false

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


func _on_speed_boost_button_pressed() -> void:
	if speed_boost_unlocked:
		print("Speed Boost already unlocked!")
		return

	if coins >= SPEED_BOOST_COST:
		coins -= SPEED_BOOST_COST
		speed_boost_unlocked = true
		save_data()
		update_coin_label()
		update_speed_boost_button_label()
		print("Speed Boost Unlocked!")
	else:
		print("Not enough coins for Speed Boost!")

func update_speed_boost_button_label():
	if speed_boost_unlocked:
		$SpeedBoostButton.text = "Speed Boost UNLOCKED!"
		$SpeedBoostButton.disabled = true
	else:
		$SpeedBoostButton.text = "Unlock Speed Boost - " + str(SPEED_BOOST_COST) + " Coins"
		$SpeedBoostButton.disabled = false
