extends Node2D
class_name antSpawner

@onready var terrain = $"../TileMap"
@onready var ant_scene = preload("res://Scenes/Entity/black_ant.tscn")

var spawnNeedCount : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnAnts()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SpawnAnts():
	var tunnelTile = Vector2i(1, 0)

	for x in range(terrain.mapWidth):
		for y in range(terrain.mapHeight):
			var tile_pos = Vector2i(x,y)
			var currentTile = terrain.get_cell_atlas_coords(0, tile_pos)

			if currentTile != Vector2i(-1, -1) and currentTile == tunnelTile:
				print("Spawning at", tile_pos)
				
				var ant = ant_scene.instantiate()
				ant.position = Vector2((tile_pos.x + 0.5) * 16, (tile_pos.y + 0.5) * 16)
				add_child(ant)
				
				spawnNeedCount -= 1
				if spawnNeedCount <= 0:
					return
