extends Area2D 

func _ready():

	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and body.has_method("show_game_win_screen"):
		body.show_game_win_screen()
