extends Area2D

@export var value: int = 5
var CorrectSound = preload("res://PhysicsCarGameAssets/Audio/Coin.wav")
@onready var pickup = $AudioStreamPlayer2D
func _ready() -> void:
	pass

	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().get_current_scene().add_coins(value)
		$AnimationPlayer.play("pickup")
		$CollisionShape2D.set_deferred("disabled", true)
		pickup.play()
		print("Coin picked up!")  


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
