extends Camera2D

### --- Nodes ---
@onready var left_limit_wall: CollisionShape2D = $"../LimitWalls/LeftLimit/LeftLimitWall"
@onready var right_limit_wall: CollisionShape2D = $"../LimitWalls/RightLimit/RightLimitWall"

@onready var player1: Player = $"../Player1"
@onready var player2: Player = $"../Player2"

### --- Consts ---
const MAXIMUM_ZOOM = 2.5
const MINIMUM_ZOOM = 2

const HORIZONTAL_MIMINUM_DISTANCE_LIMIT = 00.0 # Maximum distance to the walls. Aka "canto" do mapa
const HORIZONTAL_MAXIMUM_DISTANCE_LIMIT = 1120.0 # Maximum distance to the walls. Aka "canto" do mapa
const HORIZONTAL_MAXIMUM_CAMERA_DISTANCE = 424.0 # Used to the maximum camera distance


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
	#new_zoom = 2
	zoom = Vector2.ONE * new_zoom
	
	# Move Camera to the middle
	# (not applied yet, bc this is for the walls calculation mas a camera muda quando é no canto)
	var new_position = (player1.position + player2.position)/2
	
	# Move Walls to camera limit
	var viewport_size = get_viewport_rect().size
	# Ratio the viewport to the zoom and adapt positions
	var adjusted_viewport_size = viewport_size / new_zoom
	var left_wall_pos = new_position.x - adjusted_viewport_size.x + 275
	var right_wall_pos = new_position.x + adjusted_viewport_size.x - 275
	left_limit_wall.position.x = clamp(left_wall_pos, HORIZONTAL_MIMINUM_DISTANCE_LIMIT, HORIZONTAL_MAXIMUM_DISTANCE_LIMIT)
	right_limit_wall.position.x = clamp(right_wall_pos, HORIZONTAL_MIMINUM_DISTANCE_LIMIT, HORIZONTAL_MAXIMUM_DISTANCE_LIMIT)
	
	# Apply camera's new position
	position = new_position

func normalize_distance(distance: Vector2, mi:float, ma:float, mi_old := 0.0, ma_old := HORIZONTAL_MAXIMUM_CAMERA_DISTANCE) -> Vector2:
	"""Given a distance, normalize between the values to the camera limits."""
	var new_x = mi + ((distance.x - mi_old) * (ma - mi)) / (ma_old - mi_old)
	return Vector2(new_x, distance.y)
	
	
