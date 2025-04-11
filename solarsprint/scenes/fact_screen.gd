extends CanvasLayer

@export var fact_manager: Node  # assign manually when instantiating

@onready var fact_label = $Control/FactLabel
@onready var next_button = $Control/NextButton

signal next_pressed

func _ready():
	if fact_manager:
		fact_label.text = fact_manager.get_random_fact()
	else:
		fact_label.text = "No fact manager assigned."
	next_button.pressed.connect(_on_next_pressed)

func _on_next_pressed():
	if fact_manager:
		fact_label.text = fact_manager.get_random_fact()
