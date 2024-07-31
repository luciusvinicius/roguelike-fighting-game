extends PlayerState

## --- Vars ---
var dash_holded := true
var animation_phase := "startup"

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.FOWARDDASH

func enter(args):
	frame_data = player.get_frame_data_by_name("fdash_startup")
	super.enter(args)
	animation_phase = "startup"
	dash_holded = true
	frame_collider.setup(frame_data)
	player.play_animation("fdash_startup", 0)
	frame_collider.setup_collisions(frame_data, curr_frame)


func update(_delta):
	var direction = Input.get_axis("left", "right")
	
	# Ignore other inputs if jumping
	if vertical_state_machine.curr_state.enum_name in [CharacterStates.VERTICAL_STATES.JUMP]:
		return
	
	# Keep moving foward
	if dash_holded and animation_phase != "break":
		player.velocity.x = player.FOWARD_DASH_SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.FOWARD_BREAK_SPEED)
		animation_phase = "break"
		player.sprite_animation.play("fdash_break")
		
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
			if animation_phase == "startup":
				curr_frame = 0
				frame_data = player.play_animation("fdash_loop", 1)
				n_frames = frame_collider.get_number_of_frames(frame_data)
		"fdash_break":
			go_to_state(CharacterStates.HORIZONTAL_STATES.IDLE)
			player.reset_animation_priority()
			player.play_animation("idle", 0)
	

func _on_animation_frame_changed():
	match player.sprite_animation.animation:
		"fdash_startup":
			#print("frame changed")
			update_frame_data()
		"fdash_loop":
			update_frame_data()
		"fdash_break":
			#print("thing 2")
			pass
