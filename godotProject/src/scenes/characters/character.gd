extends CharacterBody2D
class_name Player

### --- Nodes ---
@onready var sprite_animation = $SpriteAnimation
@onready var frame_collider = $FrameCollider
@onready var state_machines = $StateMachines
@onready var input_buffer: InputBuffer = $InputBuffer

### --- Consts ---
const FOWARD_SPEED := 150.0
const BACKWARDS_SPEED := 100.0
const BACKWARDS_BREAK_SPEED := 50.0
const FOWARD_DASH_SPEED := 450.0
const FOWARD_BREAK_SPEED := 25.0
const BACK_DASH_SPEED := 250.0

const JUMP_VELOCITY := 450.0
const GRAVITY := 980.0


## --- Vars ---
@export_enum("Left:-1", "Right:1") var start_facing_direction = 1

var char_name = "Ciel"
var blocking = [] # ["low"], ["high"], ["low", "high"]?
var frame_data

var current_animation_priority = 0

## --- Logic ---

func _ready():
	# Run state machines
	for state_machine in state_machines.get_children():
		state_machine.start()
	
	# Turn to the correct side initially
	sprite_animation.flip_h = start_facing_direction < 0
	
	# Get Framedata file
	frame_data = load_frame_data()
	move_and_slide() # Fix initial "not on floor"

# Separated function because it is used in the plugin
func load_frame_data() -> Variant:
	var frame_data_file = "res://src/scenes/characters/framedata/%s.json" % char_name.to_lower()
	return JSON.parse_string(FileAccess.get_file_as_string(frame_data_file))

## --- Auxiliar Functions ---
# Animations
func play_animation(animation_name: String, priority: int) -> Dictionary:
	"""Given a certain priority, play animation. Returns the framedata, if used."""
	#print("Play animation: ", animation_name, " / Priority: ", priority)
	if priority < current_animation_priority: return {}
	#print("Animation Played")
	sprite_animation.play(animation_name)
	current_animation_priority = priority
	
	# Setup framedata
	var animation_frame_data = get_frame_data_by_name(animation_name)
	frame_collider.setup_collisions(animation_frame_data, sprite_animation.frame, get_facing_direction())
	return animation_frame_data

func stop_animation() -> void:
	"""Resets animation and the current priority"""
	current_animation_priority = 0
	var current_frame = sprite_animation.get_frame()
	sprite_animation.stop()
	sprite_animation.frame = current_frame

func reset_animation_priority() -> void:
	current_animation_priority = 0

func _on_sprite_animation_frame_changed() -> void:
	# Setup framedata
	var animation_name = sprite_animation.animation
	var animation_frame_data = get_frame_data_by_name(animation_name)
	frame_collider.setup_collisions(animation_frame_data, sprite_animation.frame, get_facing_direction())

# Other
func get_facing_direction() -> int:
	return -1 if sprite_animation.flip_h else 1
	
func get_frame_data_by_name(frame_data_name: String) -> Dictionary:
	var frame_data_filter: Array = frame_data.filter(func(fd): return fd.name == frame_data_name)
	assert(frame_data_filter.size() != 0, "ERROR: Frame Data '%s' does not exist for %s" % [frame_data_name, char_name])
	return frame_data_filter[0]
	
