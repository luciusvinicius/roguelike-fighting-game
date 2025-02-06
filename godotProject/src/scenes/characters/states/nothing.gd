extends State

### --- Nodes ---
@onready var player: Player = owner
@onready var horizontal_state_machine: StateMachine = player.get_node("StateMachines").get_node("HorizontalMovement")
@onready var vertical_state_machine: StateMachine = player.get_node("StateMachines").get_node("VerticalMovement")
@onready var input_buffer: InputBuffer = player.get_node("InputBuffer")

### --- Logic ---
func _ready():
	enum_name = CharacterStates.CONDITIONS.NOTHING
	#input_buffer = player.input_buffer

#func enter(_args):
	#var vertical_state = vertical_state_machine.curr_state
	#if vertical_state and vertical_state.enum_name != CharacterStates.VERTICAL_STATES.NEUTRAL: return
	##player.frame_collider.enable()

func update(_delta):
	
	# Cannot perform attacks while backdashing.
	if horizontal_state_machine.curr_state.enum_name == CharacterStates.HORIZONTAL_STATES.BACKDASH:
		return
		
	# Process Attack inputs
	var attack = input_buffer.get_attack()
	if attack != "":
		# If jumping, instead perform jA, jB, ... 
		if vertical_state_machine.curr_state.enum_name == CharacterStates.VERTICAL_STATES.JUMP:
			# TODO: fazer algo do tipo adicionar um "j" no início. Tomar cuidado pois pode haver "2A"
			pass
		# TODO: Mudar estado para "Attacking"
		# Go to attacking state with given animation
		go_to_state(CharacterStates.CONDITIONS.ATTACKING, [attack])

	

func exit():
	#player.default_frame_collider.disable()
	pass


func _on_player_animation_looped():
	if _is_current_state():
		# After landing start idle
		if "5A" in player.sprite_animation.animation:
			player.reset_animation_priority()
