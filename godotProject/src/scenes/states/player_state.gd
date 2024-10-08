class_name PlayerState
extends State

## --- Vars ---
@onready var player: Player = owner
@onready var horizontal_state_machine = player.get_node("StateMachines").get_node("HorizontalMovement")
@onready var vertical_state_machine = player.get_node("StateMachines").get_node("VerticalMovement")

var frame_data : Variant
@onready var frame_collider = player.frame_collider
#var curr_frame := 0
#var n_frames := 0

var animations_to_update = []

func enter(args):
	super.enter(args)
	#curr_frame = 0
	#n_frames = frame_data.collision["hurtboxes"].size()
	#frame_collider = player.frame_collider

#func update_frame_data() -> void:
	#"""Increases the current_frames and setup the correct collision"""
	#pass
	##curr_frame += 1
	##curr_frame %= n_frames
	##frame_collider.setup_collisions(frame_data, curr_frame)
#
#func _on_animation_frame_changed():
	## If a frame in the animation changes, update its frame
	#if player.sprite_animation.animation in animations_to_update:
		#update_frame_data()
