extends Area2D

@export var speed: float = 800
@export var lifetime: float = 2.0 

var velocity = Vector2.ZERO
var has_hit = false

func _ready():
	add_to_group("bullet")
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	connect("area_entered", _on_area_entered)
	connect("body_entered", _on_body_entered) 

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity 

func _physics_process(delta):
	if not has_hit:
		global_position += velocity * delta 
	
func _on_area_entered(area):
	if has_hit:
		return
		
	if area.is_in_group("enemies"):
		has_hit = true
		print("Bullet hit flocking enemy!")
		
		# Disable collision to prevent hitting more
		$CollisionShape2D.disabled = true
		
		area.queue_free()  # Destroy the enemy
		queue_free()       # Destroy the bullet
		return
	
	if area.is_in_group("energy_leech"):
		has_hit = true
		print("Bullet hit leech!")
		
		# Disable collision to prevent hitting more
		$CollisionShape2D.disabled = true
		
		if area.has_method("take_damage"):
			area.take_damage()
		
		queue_free()
		
func _on_body_entered(body):
	if has_hit:
		return
	
	if body.is_in_group("enemies"):
		has_hit = true
		print("Bullet hit flocking enemy")
		
		$CollisionShape2D.call_deferred("set", "disabled", true)


		if body.has_method("take_damage"):
			body.take_damage()

		queue_free()
