extends State

@onready var player: Player = owner

func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.IDLE

func enter():
	player.sprite_animation.play("idle")
	player.default_frame_collider.enable()

func update(_delta):
	# Check dash
	if Input.is_action_pressed("dash"):
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.FOWARDDASH)
		return
	
	# Check walking
	var direction = Input.get_axis("left", "right")
	if direction == 0: return
	if direction == player.get_facing_direction():
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
	else:
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)

func exit():
	player.default_frame_collider.disable()
