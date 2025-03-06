extends Camera2D

@export var speed = 10
@onready var UnderWorld = $"../TileMap"
var velocity

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = (input_direction.normalized() * speed)

func Zoom():
	if Input.is_action_just_pressed("zoom_in"):
		if (zoom.x < 5 && zoom.y < 5):
			zoom = zoom * 1.1
	if Input.is_action_just_pressed("zoom_out"):
		if (zoom.x > 0.35 && zoom.y > 0.35):
			zoom = zoom * 0.9

func _ready() -> void:
	position = UnderWorld.getSpawnPoint() * 16

func _physics_process(delta):
	Zoom()
	get_input()
	position += velocity
	
