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
	print("-------entered attack-----")

func update(_delta):
	player.play_animation(attack_animation, 2)


func _on_player_animation_looped() -> void:
	# Only reset if is attacking lol
	if _is_current_state():
		# TODO: Maybe not apply no moves like sex kicks?
		print("------- WHERE LOOP -------")
		player.reset_animation_priority()
		go_to_state(CharacterStates.CONDITIONS.NOTHING)
