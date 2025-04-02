extends Area2D

@onready var pickup = $AudioStreamPlayer2D

func _on_audio_stream_player_2d_ready() -> void:
	pass 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().get_current_scene().get_node("player").reFuel()
		$AnimationPlayer.play("pickup")
		pickup.play()
		$CollisionShape2D.set_deferred("disabled", true)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
