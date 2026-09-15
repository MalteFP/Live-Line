extends Node2D

var mapWidth = 256
var mapHeight = 256
var noiseScale = 0.1

var deepwaterThreshold = 0.3
var waterThreshold = 0.4
var beachThreshold = 0.45
var grondThreshold = 0.7
var snowThreshold = 0.9


@onready var tilemap = $TileMaps/Ground

func _ready():
	generateMap()

func generateMap():
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.frequency = noiseScale
	
	tilemap.clear()
	
	for x in range(mapWidth):
		for y in range(mapHeight):
			var noiseValue = noise.get_noise_2d(x, y)
			noiseValue = (noiseValue + 1) / 2
			
			var tilePos = Vector2i(x,y)
			var atlasCoords = Vector2i(0,0)
			
			if noiseValue < deepwaterThreshold:
				atlasCoords = Vector2i(3,0)
			elif noiseValue < waterThreshold:
				atlasCoords = Vector2i(2,0)
			elif noiseValue < beachThreshold:
				atlasCoords = Vector2i(5,0)
			elif noiseValue < grondThreshold:
				atlasCoords = Vector2i(1,0)
			else:
				atlasCoords = Vector2i(0,0)
				
			tilemap.set_cell(tilePos,0, atlasCoords)
