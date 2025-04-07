extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2
@export var player: RigidBody2D

var double_bullet_unlocked: bool = false

var can_shoot: bool = true

func _ready():
	player = get_parent()
	
	var config = ConfigFile.new()
	if config.load("user://player_data.cfg") == OK:
		double_bullet_unlocked = config.get_value("upgrades", "double_bullet_unlocked", false)

func _process(delta):
	rotate_towards_mouse()

func rotate_towards_mouse():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	rotation = direction.angle()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_shoot:
			shoot()
			can_shoot = false
			get_tree().create_timer(fire_rate).timeout.connect(func(): can_shoot = true)

func shoot():
	if bullet_scene and player and player.fuel >= 5.0:
		# Fire first bullet immediately
		_spawn_bullet($muzzle.global_position, rotation)

		player.use_fuel_for_shooting()

		if double_bullet_unlocked:
			# Fire second bullet after a short delay (e.g. 0.08 seconds)
			var delay = 0.08
			var offset = Vector2(0, 10).rotated(rotation)
			get_tree().create_timer(delay).timeout.connect(func():
				if player.fuel >= 5.0:
					_spawn_bullet($muzzle.global_position + offset, rotation)
					player.use_fuel_for_shooting()
			)

		# Play gunshot sound
		if $gunShot.playing:
			$gunShot.stop()
		$gunShot.play()
	else:
		print("Not enough fuel to shoot!")
		
func _spawn_bullet(pos: Vector2, angle: float):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = pos
	bullet.rotation = angle

	var bullet_direction = Vector2.RIGHT.rotated(angle) * bullet.speed
	var player_velocity = player.linear_velocity

	if bullet_direction.dot(player_velocity) > 0:
		bullet_direction += player_velocity

	bullet.set_velocity(bullet_direction)
	get_tree().current_scene.add_child(bullet)
