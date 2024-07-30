extends State

## --- Vars ---
@onready var player: Player = owner
@onready var horizontal_state_machine = player.get_node("StateMachines").get_node("HorizontalMovement")

var blocking_direction = ["high", "low"]
var jump_direction : String # "neutral", "foward" or "backward"
var jumping := false
var falling := false

var starting_velocity : Vector2

func _ready():
	enum_name = CharacterStates.VERTICAL_STATES.JUMP

func enter(_args):
	var horizontal_state = horizontal_state_machine.curr_state.enum_name
	starting_velocity = player.velocity
	jumping = false
	falling = false
	if horizontal_state == CharacterStates.HORIZONTAL_STATES.IDLE:
		jump_direction = "neutral"
	if horizontal_state in [CharacterStates.HORIZONTAL_STATES.MOVEFOWARD,\
	 CharacterStates.HORIZONTAL_STATES.FOWARDDASH]:
		jump_direction = "foward"
	if horizontal_state == CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD:
		jump_direction = "backward"
	jump_direction = "neutral"
	player.velocity.x = 0
	player.play_animation("%s_jump_start" % jump_direction, 2)

func update(delta):
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += player.GRAVITY * delta
	
	# Falling animation
	if player.velocity.y > 0 and not falling:
		player.play_animation("%s_falling_start" % jump_direction, 2)
		falling = true

	
	# TODO: double jump
	#if Input.is_action_pressed("jump"):
		#go_to_state(CharacterStates.VERTICAL_STATES.JUMP)
		
	player.move_and_slide()
	
	if player.is_on_floor() and jumping:
		player.reset_animation_priority()
		player.play_animation("%s_landing" % jump_direction, 1)
		go_to_state(CharacterStates.VERTICAL_STATES.NEUTRAL)

func exit():
	pass


func _on_player_animation_looped():
	if "jump_start" in player.sprite_animation.animation:
		# Jumps
		player.play_animation("%s_jump_loop" % jump_direction, 2)
		player.velocity.y = - player.JUMP_VELOCITY
		player.velocity.x = starting_velocity.x
		jumping = true
	elif "falling_start" in player.sprite_animation.animation:
		# Falls
		player.play_animation("%s_falling_loop" % jump_direction, 2)
