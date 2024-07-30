extends State

## --- Vars ---
@onready var player: Player = owner
@onready var vertical_state_machine = player.get_node("StateMachines").get_node("VerticalMovement")

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.MOVEFOWARD

func enter():
	player.default_frame_collider.enable()
	#var vertical_state = vertical_state_machine.curr_state
	#if vertical_state and vertical_state.enum_name == CharacterStates.VERTICAL_STATES.NEUTRAL:
		#player.sprite_animation.play("move_foward")

func update(_delta):
	
	player.play_animation("move_foward", 1)
	
	# Check dash
	if Input.is_action_pressed("dash"):
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.FOWARDDASH)
		return
	
	# Ignore other inputs if crouching
	if vertical_state_machine.curr_state.enum_name == CharacterStates.VERTICAL_STATES.CROUCH:
		return
	
	var direction = Input.get_axis("left", "right")
	
	# Check move backwards
	if direction != 0 and direction != player.get_facing_direction():	
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)
		return
	
	player.velocity.x = player.FOWARD_SPEED
	
	player.move_and_slide()
	
	if direction == 0:
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
		return
	
func exit():
	player.stop_animation()


