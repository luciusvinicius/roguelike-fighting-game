extends State

## --- Vars ---
@onready var player: Player = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	enum_name = CharacterStates.HORIZONTAL_STATES.BACKDASH

func enter():
	player.sprite_animation.play("backdash")

func update(_delta):
	player.velocity.x = -player.BACK_DASH_SPEED
	player.move_and_slide()

func _on_player_animation_looped():
	match player.sprite_animation.animation:
		"backdash":
			state_exited_to.emit(CharacterStates.HORIZONTAL_STATES.IDLE)
