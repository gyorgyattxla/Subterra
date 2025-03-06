extends CharacterBody2D

@onready var terrain = $"../../TileMap"
@onready var pathfinding = $"../../Pathfinding"


const SPEED = 100.0
const TILE_SIZE = 16  # Define tile size for clarity

var path = []

func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		var pos = (position / TILE_SIZE).floor()  # Convert to tile grid coordinates
		var targetPos = (get_global_mouse_position() / TILE_SIZE).floor()
		
		
		path = pathfinding.RequestPath(pos, targetPos)

	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		var terrainDifficulty = pathfinding.GetIsTileWalkable(position / TILE_SIZE)
		velocity = direction * SPEED

		# Check if close enough to remove the path node
		if global_position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
	else:
		velocity = Vector2.ZERO

	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("default")
	
	move_and_slide()
