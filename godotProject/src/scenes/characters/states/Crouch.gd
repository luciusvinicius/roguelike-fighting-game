extends State

## --- Vars ---
@onready var player: Player = owner
var blocking_direction = ["low"]

func _ready():
	enum_name = CharacterStates.VERTICAL_STATES.CROUCH

func enter(_args):
	player.play_animation("crouch_startup", 2)

func update(_delta):
	if Input.is_action_just_released("crouch") or Input.is_action_pressed("jump"):
		go_to_state(CharacterStates.VERTICAL_STATES.NEUTRAL)

func exit():
	player.reset_animation_priority()
	player.play_animation("get_up", 1)


func _on_player_animation_looped():
	match player.sprite_animation.animation:
		"crouch_startup":
			player.play_animation("crouch_loop", 2)
		"get_up":
			player.reset_animation_priority()
			player.play_animation("idle", 0)
