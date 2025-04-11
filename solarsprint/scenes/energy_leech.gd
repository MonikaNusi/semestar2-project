extends CharacterBody2D

@export var speed: float = 400.0
@export var gravity: float = 800.0
@export var drain_amount: float = 1.0
@export var drain_duration: float = 1.0

@onready var animation = $AnimationPlayer

var player = null
var draining = false
var is_hit = false
var follow_offset = Vector2.ZERO

func _ready():
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player") else null
	add_to_group("energy_leech")
	$DetectionArea.connect("area_entered", _on_area_entered)
	$DetectionArea.connect("body_entered", _on_body_entered)

func _physics_process(delta):
	if not player or draining or is_hit:
		return

	animation.play("run")

	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * speed

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = -20
	
	move_and_slide()

	if global_position.distance_to(player.global_position) < 30:
		start_draining()

func _process(delta):
	if draining and player:
		global_position = player.global_position + follow_offset

func _on_area_entered(area):
	if is_hit:
		return
	if area.is_in_group("bullet"):
		print("Leech hit by bullet!")
		take_damage()
		area.queue_free()

func _on_body_entered(body):
	if is_hit:
		return
	print("Collided with:", body.name)
	if body.is_in_group("bullet"):
		print("Leech hit by bullet (body)!")
		take_damage()
		body.queue_free()
	elif body.is_in_group("player") and not draining:
		print("Latching onto player now!")
		start_draining()


func start_draining():
	if not player or draining or is_hit:
		return

	print("Leech latched onto player!")
	draining = true
	velocity = Vector2.ZERO
	set_physics_process(false)

	await get_tree().process_frame
	$DetectionArea.monitoring = false
	set_collision_layer(0)
	set_collision_mask(0)

	follow_offset = Vector2(0, -10)
	set_process(true)

	var timer = get_tree().create_timer(drain_duration)
	timer.connect("timeout", Callable(self, "_on_drain_finished"))

func _on_drain_finished():
	if player and player.fuel > 0:
		var amount = min(drain_amount, player.fuel)
		player.use_fuel(amount)
		print("Leech drained fuel! Remaining:", player.fuel)

	set_process(false)
	queue_free()

func take_damage():
	if is_hit:
		return
	is_hit = true
	draining = false
	set_physics_process(false)
	set_process(false)

	set_collision_layer(0)
	set_collision_mask(0)
	#$DetectionArea.monitoring = false

	print("Leech took damage!")
	queue_free()
