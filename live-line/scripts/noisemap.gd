extends Node2D

var mapWidth = 512
var mapHeight = 512
var groundNoiseScale = 0.03
var objectNoiseScale = 0.01

var bushTreshold = 0.65
var deadBushTreshold = 0.35


var deepwaterThreshold = 0.3
var waterThreshold = 0.4
var beachThreshold = 0.5
var grondThreshold = 0.95
var snowThreshold = 0.95


@onready var ground = $TileMaps/Ground
@onready var object = $TileMaps/Collision

func _ready():
	generateMap()

func generateMap():
	var groundNoise = FastNoiseLite.new()
	groundNoise.seed = randi()
	groundNoise.noise_type = FastNoiseLite.TYPE_VALUE
	groundNoise.frequency = groundNoiseScale
	
	
	var objectNoise = FastNoiseLite.new()
	objectNoise.seed = randi()
	objectNoise.noise_type = FastNoiseLite.TYPE_PERLIN
	objectNoise.frequency = objectNoiseScale
	
	ground.clear()
	object.clear()
	
	for x in range(mapWidth):
		for y in range(mapHeight):
			
			var nx = float(x) / mapWidth * 2.0 - 1.0
			var ny = float(y) / mapHeight * 2.0 - 1.0
			var distance = sqrt(nx * nx + ny * ny)
			var falloff = clamp(1.0 - distance, 0.0, 1.0) * 3
			var groundNoiseValue = groundNoise.get_noise_2d(x, y)
			groundNoiseValue = (groundNoiseValue + 1.0) / 2.0
			var height = groundNoiseValue * falloff
			
			var objectNoisevalue = objectNoise.get_noise_2d(x,y)
			objectNoisevalue = (objectNoisevalue + 1)/2
			
			var groundPos = Vector2i(x,y)
			var groundAtlasCoords = Vector2i(0,0)
			
			var objectPos = Vector2i(x,y)
			var objectAtlasCoords = Vector2i(-1,-1)
			
			if height < deepwaterThreshold:
				groundAtlasCoords = Vector2i(3,0)
			elif height < waterThreshold:
				groundAtlasCoords = Vector2i(2,0)
			elif height < beachThreshold:
				groundAtlasCoords = Vector2i(5,0)
			elif height < grondThreshold:
				groundAtlasCoords = Vector2i(1,0)
				var chance = randf()
				if objectNoisevalue > bushTreshold:
					if chance > 0.9:
						objectAtlasCoords = Vector2i(2,0)
					elif chance < 0.3:
						objectAtlasCoords = Vector2i(3,0)
				elif objectNoisevalue < deadBushTreshold:
					if chance > 0.9:
						objectAtlasCoords = Vector2i(4,0)
					elif chance < 0.3:
						objectAtlasCoords = Vector2i(5,0)
				if chance > 0.99:
					objectAtlasCoords = Vector2i(0,0)
			else:
				groundAtlasCoords = Vector2i(0,0)
				var chance = randf()
				if chance > 0.97:
					objectAtlasCoords = Vector2i(1,0)
				
			ground.set_cell(groundPos,0, groundAtlasCoords)
			if objectAtlasCoords != Vector2i(-1,-1):
				object.set_cell(objectPos,1, objectAtlasCoords)
