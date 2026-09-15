extends Node2D

var mapWidth = 256
var mapHeight = 256
var noiseScale = 0.03

var deepwaterThreshold = 0.3
var waterThreshold = 0.4
var beachThreshold = 0.5
var grondThreshold = 0.95
var snowThreshold = 0.95


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
			var nx = float(x) / mapWidth * 2.0 - 1.0
			var ny = float(y) / mapHeight * 2.0 - 1.0

			# Distance from center (0 = center, 1 = edge)
			var distance = sqrt(nx * nx + ny * ny)

			# Falloff curve (controls island shape)
			var falloff = clamp(1.0 - distance, 0.0, 1.0) * 3

			# Noise
			var noiseValue = noise.get_noise_2d(x, y)
			noiseValue = (noiseValue + 1.0) / 2.0

			# Combine noise + falloff
			var height = noiseValue * falloff

			
			var tilePos = Vector2i(x,y)
			var atlasCoords = Vector2i(0,0)
			
			if height < deepwaterThreshold:
				atlasCoords = Vector2i(3,0)
			elif height < waterThreshold:
				atlasCoords = Vector2i(2,0)
			elif height < beachThreshold:
				atlasCoords = Vector2i(5,0)
			elif height < grondThreshold:
				atlasCoords = Vector2i(1,0)
			else:
				atlasCoords = Vector2i(0,0)
				
			tilemap.set_cell(tilePos,0, atlasCoords)
