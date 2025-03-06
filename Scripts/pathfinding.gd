@tool
extends Node2D
class_name Pathfinding

@onready var terrain = $"../TileMap"

@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

var astar_grid = AStarGrid2D.new()

var path = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitPathfinding()

func _draw():
	if( len(path) > 0 ):
		for i in range(len(path) - 1):
			draw_line(path[i], path[i+1], Color.PURPLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(calculate == true):
		InitPathfinding()
		calculate = false
		FindPath()
		RequestPath(start,end)

func FindPath():
	path = astar_grid.get_point_path(start, end)
	queue_redraw()
	
func RequestPath(start : Vector2i, end : Vector2i):
	path = astar_grid.get_point_path(start, end)
	
	for i in range(len(path)):
		path[i] += Vector2(8,8)
	
	queue_redraw()
	return path

func InitPathfinding():
	astar_grid.region = Rect2i(0,0,terrain.mapWidth,terrain.mapHeight)
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.update()
	
	for x in range(terrain.mapWidth):
		for y in range(terrain.mapHeight):
			var pathValue = GetIsTileWalkable(Vector2i(x,y))
			if ( pathValue != 0 ):
				astar_grid.set_point_solid(Vector2i(x,y), true)
			else:
				astar_grid.set_point_weight_scale(Vector2i(x,y), pathValue)


func GetIsTileWalkable(coords : Vector2i):
	var layer = 0
	var source_id = terrain.get_cell_source_id(layer, coords, false)
	var source : TileSetAtlasSource = terrain.tile_set.get_source(source_id)
	var atlas_coords = terrain.get_cell_atlas_coords(layer, coords, false)
	var tile_data = source.get_tile_data(atlas_coords, 0)
	
	return tile_data.get_custom_data("walkable")
