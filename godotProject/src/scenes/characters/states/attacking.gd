extends State

### --- Nodes ---
@onready var player: Player = owner
@onready var input_buffer: InputBuffer = player.get_node("InputBuffer")
@onready var horizontal_state_machine: StateMachine = player.get_node("StateMachines").get_node("HorizontalMovement")

### --- Vars ---
var attack_animation := ""

### --- Logic ---
func _ready():
	enum_name = CharacterStates.CONDITIONS.ATTACKING

func enter(args):
	attack_animation = args[0]

func update(_delta):
	## Check for cancels
	var hit_cancels := player.hit_cancels
	
	# Attack cancels
	var attack = input_buffer.get_attack()
	if input_buffer.get_attack() in hit_cancels:
		# If cancelled, restart animation and reset cancels
		player.reset_animation()
		attack_animation = attack
		input_buffer.remove_attack()
		player.reset_cancels()
		
	# Play regular animation if not canceled
	player.play_animation(attack_animation, 2)


func _on_player_animation_looped() -> void:
	# Only reset if is attacking lol
	if _is_current_state():
		# TODO: Maybe not apply no moves like sex kicks?
		pass
		player.reset_animation_priority()
		go_to_state(CharacterStates.CONDITIONS.NOTHING)
