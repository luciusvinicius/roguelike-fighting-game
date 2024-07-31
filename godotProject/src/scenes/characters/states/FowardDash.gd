extends PlayerState

## --- Vars ---
var dash_holded := true
var animation_phase := "startup"

## --- Logic ---

func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.FOWARDDASH
	animations_to_update = ["fdash_startup", "fdash_loop", "fdash_break"]

func enter(args):
	super.enter(args)
	animation_phase = "startup"
	dash_holded = true

func update(_delta):
	var direction = Input.get_axis("left", "right")
	
	# Play correct animation
	if animation_phase == "startup":
		player.play_animation("fdash_startup", 0)
	elif animation_phase == "loop":
		player.play_animation("fdash_loop", 1)
	
	# Ignore other inputs if jumping
	if vertical_state_machine.curr_state.enum_name in [CharacterStates.VERTICAL_STATES.JUMP]:
		return
	
	# Keep moving foward
	if dash_holded and animation_phase != "break":
		player.velocity.x = player.FOWARD_DASH_SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.FOWARD_BREAK_SPEED)
		animation_phase = "break"
		player.reset_animation_priority()
		player.play_animation("fdash_break", 0)
		
		
	player.move_and_slide()
	
	# Check cancel break to walk foward
	# Not sure if this should exist. Verify with another games?
	# if animation_phase == "break" and direction == player.get_facing_direction():
		#go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
		#return
	
	# Check dash cancel to back
	if direction != 0 and direction != player.get_facing_direction():
		go_to_state(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)
	
	dash_holded = Input.is_action_pressed("dash")

func _on_player_animation_looped():
	match player.sprite_animation.animation:
		"fdash_startup":
			print("finish startup")
			animation_phase = "loop"
			frame_data = player.play_animation("fdash_loop", 1)
	
		"fdash_break":
			animation_phase = "break"
			go_to_state(CharacterStates.HORIZONTAL_STATES.IDLE)
			player.reset_animation_priority()
			player.play_animation("idle", 0)
	


