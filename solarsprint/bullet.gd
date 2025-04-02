extends Area2D

@export var speed: float = 800
@export var lifetime: float = 2.0 

var velocity = Vector2.ZERO
var has_hit = false

func _ready():
	add_to_group("bullet")
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	connect("area_entered", _on_area_entered)

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity 

func _physics_process(delta):
	if not has_hit:
		global_position += velocity * delta 
	
func _on_area_entered(area):
	if has_hit:
		return
	
	if area.is_in_group("energy_leech"):
		has_hit = true
		print("Bullet hit leech!")
		
		# Disable collision to prevent hitting more
		$CollisionShape2D.disabled = true
		
		if area.has_method("take_damage"):
			area.take_damage()
		
		# Optionally delay slightly to let hit effect show
		await get_tree().create_timer(0.01).timeout
		queue_free()
