extends State

## --- Vars ---
@onready var player: Player = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.MOVEFOWARD

func enter():
	player.default_frame_collider.enable()

func update(_delta):
	# Check dash
	if Input.is_action_pressed("dash"):
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.FOWARDDASH)
		return
	
	var direction = Input.get_axis("left", "right")
	
	# Check move backwards
	if direction != 0 and direction != player.get_facing_direction():	
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)
		return
	
	player.velocity.x = player.FOWARD_SPEED
	player.sprite_animation.play("move_foward")
	
	player.move_and_slide()
	
	if direction == 0:
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
		return
	
	# Keep moving foward
	#if direction:
		#player.velocity.x = player.FOWARD_SPEED
		#player.sprite_animation.play("move_foward")
		# TODO: play move_foward animation
	#else:
		#player.velocity.x = move_toward(player.velocity.x, 0, player.FOWARD_BREAK_SPEED)
		# TODO: This break should happen with dash, not with walk
		# TODO 2: play breaking animation
	#player.move_and_slide()
	
	# Check should return to idle
	
	#if player.velocity.x == 0:
		#state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
		#return


