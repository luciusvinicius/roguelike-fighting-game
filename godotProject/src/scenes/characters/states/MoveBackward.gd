extends State

## --- Vars ---
@onready var player: Player = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD

func enter():
	player.default_frame_collider.enable()

func update(_delta):
	# Check dash
	if Input.is_action_just_pressed("dash"):
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.BACKDASH)
		return
	
	# Check move foward
	var direction = Input.get_axis("left", "right")	
	if direction != 0 and direction == player.get_facing_direction():
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
		return
	
	player.velocity.x = -player.BACKWARDS_SPEED
	player.sprite_animation.play("move_backward")
	
	player.move_and_slide()
	
	# Check idle
	if direction == 0:
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
		return

