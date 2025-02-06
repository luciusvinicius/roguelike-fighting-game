extends Node2D

### --- Nodes ---
@onready var camera: Camera2D = $Camera2D

@onready var left_limit_wall: CollisionShape2D = $LimitWalls/LeftLimit/LeftLimitWall
@onready var right_limit_wall: CollisionShape2D = $LimitWalls/RightLimit/RightLimitWall

@onready var player1: Player = $Player1
@onready var player2: Player = $Player2

### --- Consts ---
const MAXIMUM_ZOOM = 2.5
const MINIMUM_ZOOM = 2

const HORIZONTAL_DISTANCE_LIMIT = 424.0 # Maximum distance to the walls. Aka "canto" do mapa

### --- Vars ---


### --- Logic ---

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_camera()


## -- Camera --
func update_camera():
	"""Change camera's zoom, position and the wall limit."""
	# Change Camera zoom
	var player_distance = abs(player1.position - player2.position)
	player_distance = normalize_distance(player_distance, MAXIMUM_ZOOM, MINIMUM_ZOOM)
	var new_zoom = clamp(player_distance.x, MINIMUM_ZOOM, MAXIMUM_ZOOM)
	camera.zoom = Vector2.ONE * new_zoom
	
	# Move Camera to the middle
	var new_position = (player1.position + player2.position)/2
	camera.position = new_position
	

func normalize_distance(distance: Vector2, mi:float, ma:float, mi_old := 0.0, ma_old := HORIZONTAL_DISTANCE_LIMIT) -> Vector2:
	"""Given a distance, normalize between the values to the camera limits."""
	var new_x = mi + ((distance.x - mi_old) * (ma - mi)) / (ma_old - mi_old)
	return Vector2(new_x, distance.y)
	
	
