@tool
extends TileMap
class_name subWorldGeneration

@export var generateTerrain : bool
@export var clearTerrain : bool

@export var mapWidth : int
@export var mapHeight : int

@export var stoneThreshold : float

var spawnArea : Vector2i
var generatedSpawnArea : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GenerateTerrain()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Debugging tools
	if (generateTerrain):
		generateTerrain = false
		GenerateTerrain()
		generatedSpawnArea = false
	if (clearTerrain):
		clearTerrain = false
		ClearTerrain()

#Generates the terrain. ( Soil / Stone )
func GenerateTerrain():
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.seed = randi()
	
	for x in range(mapWidth):
		for y in range(mapHeight):
			if ( ( x==0 || y==0 ) || ( x==mapWidth-1 || y==mapHeight-1 ) ):
				var variation = randi_range(0,3)
				set_cell(0,Vector2i(x,y),0,Vector2i(2,variation))
			elif ( noise.get_noise_2d(x,y) < stoneThreshold ):
				var variation = randi_range(0,3)
				set_cell(0,Vector2i(x,y),0,Vector2i(2,variation))
			else:
				var variation = randi_range(0,3)
				set_cell(0,Vector2i(x,y),0,Vector2i(0,variation))
	
	while ( generatedSpawnArea == false ):
		GenerateSpawnArea()

#Generates a spawn area. ( 5x5 Tunnel )
func GenerateSpawnArea():
	
	var stoneTileHalfAtlas = Vector2i(2,0)
	
	spawnArea = Vector2i(randi_range(20,mapWidth-20),randi_range(20,mapHeight-20))
	var originX = spawnArea.x
	var originY = spawnArea.y
	
	for x in range(5):
		for y in range(5):
			var currentTile = get_cell_atlas_coords(0,Vector2i(spawnArea.x,spawnArea.y),false)
			if ( currentTile.x == stoneTileHalfAtlas.x ):
				generatedSpawnArea = false
				return
			spawnArea.x += 1
		spawnArea.y += 1
		spawnArea.x = originX
	
	for x in range(5):
		for y in range(5):
			var variation = randi_range(0,3)
			set_cell(0,Vector2i(spawnArea.x,spawnArea.y),0,Vector2i(1,variation))
			spawnArea.x += 1
		spawnArea.y += 1
		spawnArea.x = originX
	generatedSpawnArea = true

func getSpawnPoint():
	return spawnArea

func ClearTerrain():
	clear()
