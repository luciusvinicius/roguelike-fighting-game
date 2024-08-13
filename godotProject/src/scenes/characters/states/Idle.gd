extends State

@onready var player: Player = owner
@onready var vertical_state_machine = player.get_node("StateMachines").get_node("VerticalMovement")

func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.IDLE

func enter(_args):
	var vertical_state = vertical_state_machine.curr_state
	if vertical_state and vertical_state.enum_name != CharacterStates.VERTICAL_STATES.NEUTRAL: return
	#player.frame_collider.enable()

func update(_delta):
	
	player.play_animation("idle", 0)
	
	# Ignore horizontal inputs if crouching
	if vertical_state_machine.curr_state.enum_name == CharacterStates.VERTICAL_STATES.CROUCH:
		return
	
	# Check dash
	if Input.is_action_pressed("dash"):
		go_to_state(CharacterStates.HORIZONTAL_STATES.FOWARDDASH)
		return
	
	# Check walking
	var direction = Input.get_axis("left", "right")
	if direction == 0: return
	if direction == player.get_facing_direction():
		go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
	else:
		go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)

func exit():
	#player.default_frame_collider.disable()
	pass


func _on_player_animation_looped():
	# After landing start idle
	if "landing" in player.sprite_animation.animation:
		player.reset_animation_priority()
