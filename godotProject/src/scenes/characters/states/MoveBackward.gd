extends State

## --- Vars ---
@onready var player: Player = owner
@onready var vertical_state_machine = player.get_node("StateMachines").get_node("VerticalMovement")
@onready var condition_state_machine: StateMachine = player.get_node("StateMachines").get_node("Conditions")
@onready var input_buffer: InputBuffer = player.get_node("InputBuffer")

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD

func enter(_args):
	#player.default_frame_collider.enable()
	pass

func update(_delta):
	
	## Ignore horizontal inputs if attacking
	if condition_state_machine.curr_state.enum_name == CharacterStates.CONDITIONS.ATTACKING:
		go_to_state(CharacterStates.HORIZONTAL_STATES.IDLE)
		return
		
	player.play_animation("move_backward", 1)
	
	# Ignore other inputs if crouching or jumping
	if vertical_state_machine.curr_state.enum_name in [CharacterStates.VERTICAL_STATES.CROUCH,\
	CharacterStates.VERTICAL_STATES.JUMP]:
		return
	
	# Check dash
	if input_buffer.is_action_pressed(player.id + "dash"):
		go_to_state(CharacterStates.HORIZONTAL_STATES.BACKDASH)
		return
	
	
	# Check move foward
	var direction = input_buffer.get_axis(player.id + "left", player.id + "right")	
	if direction != 0 and direction == player.get_facing_direction():
		go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
		return
	
	player.velocity.x = -player.BACKWARDS_SPEED * player.get_facing_direction()
	
	player.move_and_slide()
	
	# Check idle
	if direction == 0:
		go_to_state(CharacterStates.HORIZONTAL_STATES.IDLE)
		return

func exit():
	if vertical_state_machine.curr_state.enum_name == CharacterStates.VERTICAL_STATES.NEUTRAL:
		player.stop_animation()
		player.velocity.x = 0
