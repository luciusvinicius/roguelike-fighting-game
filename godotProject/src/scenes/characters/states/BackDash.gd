extends State

## --- Vars ---
@onready var player: Player = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.BACKDASH

func enter(_args):
	pass
	#player.sprite_animation.play("backdash")

func update(_delta):
	player.play_animation("backdash", 0)
	player.velocity.x = -player.BACK_DASH_SPEED
	player.move_and_slide()

func exit():
	player.velocity.x = 0

func _on_player_animation_looped():
	if _is_current_state():
		match player.sprite_animation.animation:
			"backdash":
				player.play_animation("idle", 0)
				go_to_state(CharacterStates.HORIZONTAL_STATES.IDLE)
