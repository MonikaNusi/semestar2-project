extends RigidBody2D

var wheels = []
var base_speed = 60000
var speed = base_speed 
var max_speed = 50

var fuel = 100
var max_fuel = 100
var dead = false

var wheel_power_factor = 1.0
var base_wheel_power = 1.0

@onready var level_manager = get_parent()

func _ready():
	wheels = get_tree().get_nodes_in_group("wheel")
	
	var config = ConfigFile.new()
	if config.load("user://player_data.cfg") == OK:
		var level = config.get_value("upgrades", "fuel_tank_level", 0)
		upgrade_fuel_tank(level * 20)
		#print("Applied Fuel Tank Upgrade: Level", level)
		
		var wheel_level = config.get_value("upgrades", "wheel_power_level", 0)
		wheel_power_factor = base_wheel_power + wheel_level * 0.2
		speed = base_speed * (1.0 + wheel_level * 0.1)

		# Stability scaling
		angular_damp = 0.1 + wheel_level * 0.5  # very low at level 0, high later
		linear_damp = 0.05 + wheel_level * 0.3  # air resistance
		print("Applied Wheel Power Upgrade: Level", wheel_level)
	
	fuel = max_fuel  # fill up
	
	get_parent().update_fuel_UI(fuel)
	level_manager.update_fuel_UI(fuel)

func _physics_process(delta):
	if fuel > 0 and !dead:
		$gameOverTimer.stop()

		if Input.is_action_pressed("ui_right"):
			use_fuel(delta)
			for wheel in wheels:
				if wheel.angular_velocity < max_speed:
					wheel.apply_torque_impulse(speed * delta * 60 * wheel_power_factor)

		if Input.is_action_pressed("ui_left"):
			use_fuel(delta)
			for wheel in wheels:
				if wheel.angular_velocity > -max_speed:
					wheel.apply_torque_impulse(-speed * delta * 60 * wheel_power_factor)

		# --- Downforce only applies as upgrades increase ---
		if wheel_power_factor > 1.0:
			var angle_force = abs(rotation_degrees) / 90.0
			var downforce = 1000 * angle_force * (wheel_power_factor - 1.0)
			apply_central_force(Vector2(0, downforce))

		# --- Mid-air stabilisation grows with level ---
		if linear_velocity.y > 0 and wheel_power_factor > 1.0:
			var correction_torque = -rotation_degrees * 10.0 * (wheel_power_factor - 1.0)
			apply_torque_impulse(correction_torque * delta)
	else:
		if $gameOverTimer.is_stopped():
			$gameOverTimer.start()
			show_game_over_screen()

var pause_menu = null
func _input(event):
	if event is InputEventKey:
		#print("Key event detected!")
		if event.pressed and event.keycode == KEY_ESCAPE:
			print("ESC pressed!")
			toggle_pause()

func toggle_pause():
	if get_tree().paused:
		print("Resuming game...")
		get_tree().paused = false
		if pause_menu:
			pause_menu.queue_free()
			pause_menu = null
	else:
		print("Pausing game...")
		get_tree().paused = true
		if pause_menu == null:
			pause_menu = load("res://scenes/pause_menu.tscn").instantiate()
			get_tree().get_root().add_child(pause_menu)

func reFuel():
	fuel =  max_fuel
	get_parent().update_fuel_UI(fuel)
	
func use_fuel(delta):
	fuel -= 10 * delta
	fuel = clamp(fuel, 0, max_fuel)
	get_parent().update_fuel_UI(fuel)
	


func _on_game_over_timer_timeout() -> void:
	get_tree().paused = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Mud"):  # provjeri prvo jel Mud u grupi Mud MOLIMTE
		print("in mud- from car")

func set_max_speed(new_speed: float) -> void:
	max_speed = new_speed

func reduce_wheel_power(factor: float) -> void:
	wheel_power_factor = factor  # Adjust wheel force


var game_win_screen = null

func show_game_win_screen():
	print("Game Won!")

	# Save progress directly (no GameState needed)
	var config = ConfigFile.new()
	var err = config.load("user://progress.cfg")
	if err != OK:
		print("Creating new progress config")

	config.set_value("progress", "level_1_completed", true)
	config.save("user://progress.cfg")

	if game_win_screen == null:
		game_win_screen = load("res://scenes/game_win.tscn").instantiate()
		game_win_screen.name = "GameWinScreen"
		get_tree().get_root().add_child(game_win_screen)
		get_tree().paused = true

var game_over_screen = null

func show_game_over_screen():
	print("Loading Game Over screen...")
	if game_over_screen == null:  # Prevent duplicates
		game_over_screen = load("res://scenes/game_over.tscn").instantiate()
		if game_over_screen:
			game_over_screen.name = "GameOverScreen"  # Give it a unique name
			get_tree().get_root().add_child(game_over_screen)
			print("Game Over screen added!")
			game_over_screen.update_scores(level_manager.distance_travelled, level_manager.high_score)
		else:
			print("Failed to load Game Over scene!")
			get_tree().paused = true
			
func upgrade_fuel_tank(amount: int):
	max_fuel += amount
	fuel = max_fuel
	get_parent().update_fuel_UI(fuel)
	
func use_fuel_for_shooting():
	var fuel_cost = 5.0
	fuel -= fuel_cost
	fuel = clamp(fuel, 0, max_fuel)
	get_parent().update_fuel_UI(fuel)
