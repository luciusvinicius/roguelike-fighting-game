extends State

### --- Nodes ---
@onready var player: Player = owner
@onready var vertical_state_machine = player.get_node("StateMachines").get_node("VerticalMovement")
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
	
	# Process Attack inputs
	var attack = input_buffer.get_attack()
	if attack != "":
		# If jumping, instead perform jA, jB, ... 
		if vertical_state_machine.curr_state.enum_name == CharacterStates.VERTICAL_STATES.JUMP:
			# TODO: fazer algo do tipo adicionar um "j" no início. Tomar cuidado pois pode haver "2A"
			pass
		# TODO: Mudar estado para "Attacking"
		player.play_animation(attack, 1) # TODO: Bug. Aparentemente as colisões só funfam se tiver spamando o botão. Acredito que seja porque o "play" não acontece a cada frame.

	

func exit():
	#player.default_frame_collider.disable()
	pass


func _on_player_animation_looped():
	# After landing start idle
	if "5A" in player.sprite_animation.animation:
		player.reset_animation_priority()
