extends State

## --- Vars ---
@onready var player: Player = owner
var blocking_direction = "low"

func _ready():
	enum_name = CharacterStates.VERTICAL_STATES.CROUCH

func enter():
	pass

func update(_delta):
	# Force Horizontal lock.
	# TODO: See what about blocking...
	owner.state_machines.get_node("HorizontalMovement").curr_state.state_exited_to\
	.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
	if Input.is_action_just_released("crouch") or Input.is_action_pressed("jump"):
		state_exited_to.emit(CharacterStates.VERTICAL_STATES.NEUTRAL)

func exit():
	pass
