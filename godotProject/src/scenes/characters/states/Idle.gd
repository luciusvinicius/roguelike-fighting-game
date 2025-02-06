extends State

@onready var player: Player = owner
@onready var vertical_state_machine: StateMachine = player.get_node("StateMachines").get_node("VerticalMovement")
@onready var condition_state_machine: StateMachine = player.get_node("StateMachines").get_node("Conditions")
@onready var input_buffer: InputBuffer = player.get_node("InputBuffer")

func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.IDLE
	#input_buffer = player.input_buffer

func enter(_args):
	var vertical_state = vertical_state_machine.curr_state
	if vertical_state and vertical_state.enum_name != CharacterStates.VERTICAL_STATES.NEUTRAL: return
	#player.frame_collider.enable()

func update(_delta):
	
	player.play_animation("idle", 0)
	
	# Ignore horizontal inputs if crouching
	if vertical_state_machine.curr_state.enum_name == CharacterStates.VERTICAL_STATES.CROUCH:
		return
	
	# Ignore horizontal inputs if attacking
	if condition_state_machine.curr_state.enum_name == CharacterStates.CONDITIONS.ATTACKING:
		return

	# Check dash
	if input_buffer.is_action_pressed("dash"):
		go_to_state(CharacterStates.HORIZONTAL_STATES.FOWARDDASH)
		return
	
	# Check walking
	var direction = Input.get_axis("left", "right")
	if direction == 0: return
	if direction == player.get_facing_direction():
		go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
	else:
		go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)
	
	# Check attacks
	

func exit():
	#player.default_frame_collider.disable()
	pass


func _on_player_animation_looped():
	if _is_current_state():
		# After landing start idle
		if "landing" in player.sprite_animation.animation: # neutral_landing, foward, etc...
			player.reset_animation_priority()
		
		match player.sprite_animation.animation:
			"landing":
				player.reset_animation_priority()
			"get_up":
				player.reset_animation_priority()
