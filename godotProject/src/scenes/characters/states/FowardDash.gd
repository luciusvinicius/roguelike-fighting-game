extends State

## --- Vars ---
@onready var player: Player = owner
var animation_phase := "startup"
var dash_holded := true

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.FOWARDDASH

func enter():
	player.sprite_animation.play("fdash_startup")
	animation_phase = "startup"
	dash_holded = true

func update(_delta):
	var direction = Input.get_axis("left", "right")
	
	# Keep moving foward
	if dash_holded and animation_phase != "break":
		player.velocity.x = player.FOWARD_DASH_SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.FOWARD_BREAK_SPEED)
		animation_phase = "break"
		player.sprite_animation.play("fdash_break")
		
	player.move_and_slide()
	
	# Check cancel brak to walk foward
	# Not sure if this should exist. Verify with another games?
	# if animation_phase == "break" and direction == player.get_facing_direction():
		#state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEFOWARD)
		#return
	
	# Check dash cancel to back
	if direction != 0 and direction != player.get_facing_direction():
		state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.MOVEBACKWARD)
	
	dash_holded = Input.is_action_pressed("dash")

func _on_player_animation_looped():
	match player.sprite_animation.animation:
		"fdash_startup":
			if animation_phase == "startup":
				player.sprite_animation.play("fdash_loop")
		"fdash_break":
			state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
	