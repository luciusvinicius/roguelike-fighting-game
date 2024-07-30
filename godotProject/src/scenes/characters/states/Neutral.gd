extends State

## --- Vars ---
@onready var player: Player = owner
@onready var horizontal_state_machine = player.get_node("StateMachines").get_node("HorizontalMovement")
var blocking_direction = ["high"]

func _ready():
	enum_name = CharacterStates.VERTICAL_STATES.NEUTRAL

func enter(_args):
	pass

func update(_delta):
	# Cannot jump or crouch while backdashing
	if horizontal_state_machine.curr_state.enum_name in [CharacterStates.HORIZONTAL_STATES.BACKDASH]:
		return
	
	if Input.is_action_pressed("jump"):
		go_to_state(CharacterStates.VERTICAL_STATES.JUMP)
	elif Input.is_action_pressed("crouch"):
		go_to_state(CharacterStates.VERTICAL_STATES.CROUCH)

func exit():
	pass
