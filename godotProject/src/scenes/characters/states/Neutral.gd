extends State

## --- Vars ---
@onready var player: Player = owner
@onready var horizontal_state_machine = player.get_node("StateMachines").get_node("HorizontalMovement")
@onready var condition_state_machine: StateMachine = player.get_node("StateMachines").get_node("Conditions")
var blocking_direction = ["high"]

func _ready():
	enum_name = CharacterStates.VERTICAL_STATES.NEUTRAL

func enter(_args):
	pass

func update(_delta):
	
	# Cannot change while attacking
	if condition_state_machine.curr_state.enum_name in [CharacterStates.CONDITIONS.ATTACKING]:
		return
	
	# Cannot jump or crouch while backdashing
	if horizontal_state_machine.curr_state.enum_name in [CharacterStates.HORIZONTAL_STATES.BACKDASH]:
		return
	
	if Input.is_action_pressed(player.id + "jump"):
		go_to_state(CharacterStates.VERTICAL_STATES.JUMP)
	elif Input.is_action_pressed(player.id + "crouch"):
		go_to_state(CharacterStates.VERTICAL_STATES.CROUCH)

func exit():
	pass

func _on_player_animation_looped():
	if _is_current_state():
		# After getting up from crouch start idle
		match player.sprite_animation.animation:
			"get_up":
				player.reset_animation_priority()
				player.play_animation("idle", 0)
