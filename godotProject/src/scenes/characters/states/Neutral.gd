extends State

## --- Vars ---
@onready var player: Player = owner
var blocking_direction = "high"

func _ready():
	enum_name = CharacterStates.VERTICAL_STATES.NEUTRAL

func enter():
	pass

func update(_delta):
	if Input.is_action_pressed("jump"):
		state_exited_to.emit(CharacterStates.VERTICAL_STATES.JUMP)
	elif Input.is_action_pressed("crouch"):
		state_exited_to.emit(CharacterStates.VERTICAL_STATES.CROUCH)

func exit():
	pass
