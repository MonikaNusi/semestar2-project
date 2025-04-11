extends CharacterBody2D

@export var max_speed = 400.0
@export var neighbour_radius = 100.0
@export var separation_weight = 1.8
@export var alignment_weight = 1.0
@export var cohesion_weight = 1.0

@export var drain_amount: float = 3.0
@export var drain_duration: float = 1.0


var flock: Array = []
var manager = null

var player = null
var draining = false
var follow_offset = Vector2.ZERO

@onready var animation = $AnimationPlayer



func _ready():
	add_to_group("enemies")
	animation.play("fly")
	$DetectionArea.connect("body_entered", Callable(self, "_on_DetectionArea_body_entered"))
	print("Flocking enemy ready. Player is:", player)
	await get_tree().process_frame
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player") else null
	manager = get_tree().get_current_scene().get_node("FlockingManager")
	if manager:
		manager.register(self)
		set_meta("manager", manager)
	else:
		print("FlockingManager not found!")
		
func _on_DetectionArea_body_entered(body):
	print("Something entered:", body.name)
	if body.is_in_group("player") and not draining:
		print("Flocking enemy hit the player!")
		start_draining()

func _exit_tree():
	if manager:
		manager.unregister(self)

func _process(delta):
	var separation = Vector2.ZERO
	var alignment = Vector2.ZERO
	var cohesion = Vector2.ZERO
	var count = 0

	for other in flock:
		if other == self:
			continue
		var dist = global_position.distance_to(other.global_position)
		if dist < neighbour_radius:
			var diff = (global_position - other.global_position).normalized() / dist
			separation += diff
			alignment += other.velocity
			cohesion += other.global_position
			count += 1

	if count > 0:
		separation /= count
		alignment = (alignment / count).normalized()
		cohesion = ((cohesion / count) - global_position).normalized()

	#Find and chase the player

	var chase = Vector2.ZERO
	if player:
		var direction_to_player = (player.global_position - global_position).normalized()
		var distance_to_player = global_position.distance_to(player.global_position)

		var chase_strength = 4.0
		var chase_boost = 0.0

		if distance_to_player < 150:
			chase_strength = 6.0
			chase_boost = 200.0  # Boost speed when close
		else:
			chase_strength = 4.0

		chase = direction_to_player * chase_strength
		velocity += direction_to_player * chase_boost * delta
	# Combine behaviours
	var steer = (
		separation * separation_weight +
		alignment * alignment_weight +
		cohesion * cohesion_weight +
		chase
	)

	velocity += steer
	velocity = velocity.limit_length(max_speed)
	move_and_slide()

func start_draining():
	if not player or draining:
		return

	print("Flocking enemy started draining fuel!")
	draining = true
	velocity = Vector2.ZERO
	set_physics_process(false)

	follow_offset = Vector2(0, -10)
	set_process(true)

	await get_tree().create_timer(drain_duration).timeout
	_on_drain_finished()

func _on_drain_finished():
	if player and player.fuel > 0:
		var delta = drain_amount / 10.0 
		player.use_fuel(delta)
		print("Drained fuel! Player has:", player.fuel)

	set_process(false)
	queue_free()
	
func take_damage():
	if draining:
		return
	print("Flocking enemy took damage!")
	queue_free()
