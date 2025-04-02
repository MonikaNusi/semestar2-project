extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2
@export var player: RigidBody2D

var can_shoot: bool = true

func _ready():
	player = get_parent()

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
		var bullet = bullet_scene.instantiate()
		bullet.global_position = $muzzle.global_position 
		bullet.rotation = rotation 

		var bullet_direction = Vector2.RIGHT.rotated(rotation) * bullet.speed

		var player_velocity = Vector2.ZERO
		player_velocity = player.linear_velocity 

		if bullet_direction.dot(player_velocity) > 0:
			bullet_direction += player_velocity

		bullet.set_velocity(bullet_direction)
		get_tree().current_scene.add_child(bullet)

		player.use_fuel_for_shooting()  # Deduct fuel here

		if $gunShot.playing:
			$gunShot.stop()
		$gunShot.play()
	else:
		print("Not enough fuel to shoot!")
