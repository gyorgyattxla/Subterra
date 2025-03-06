extends TileMap
class_name mapFog

@onready var terrain = $"../TileMap"

var spawnArray = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitFogLayer()


func InitFogLayer():
	var width = terrain.mapWidth
	var height = terrain.mapHeight
	
	SetSpawnArray()
	
	for x in range(width):
		for y in range(height):
			if (!IsTileInSpawnArray(Vector2i(x,y))):
				set_cell(0, Vector2i(x,y),0,Vector2i(0,0))

func IsTileInSpawnArray(coords : Vector2i) -> bool:
	
	for i in range(len(spawnArray)):
		if coords == spawnArray[i]:
			return true

	return false

func SetSpawnArray():
	
	var spawnpoint = terrain.getSpawnPoint()
	var initialSpawnpoint = Vector2i(spawnpoint.x-1, spawnpoint.y-6)
	
	for x in range(7):
		for y in range(7):
			spawnArray.append(Vector2i(initialSpawnpoint.x + x,initialSpawnpoint.y + y))

#On mining task complete, revoke the fog on and nearby the tile
	#	#	#
	#	x	#
	#	#	#
func UpdateFogLayer(coords : Vector2i):
	pass
