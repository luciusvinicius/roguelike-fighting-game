@tool
extends CenterContainer

## --- Nodes ---
@onready var character_options = $CharacterSelect/Col/CharacterOptions
@onready var character_select = $CharacterSelect
@onready var character_editor = $CharacterEditor
@onready var character_slot = $CharacterEditor/Row/CharacterSlot

@onready var character_animations = $CharacterEditor/Row/Col/Animations
@onready var character_animation_frame = $CharacterEditor/Row/Col/Frame

## --- Consts ---
const BASE_DIRECTORY := "res://src/scenes/characters/characters/"
const CHARACTER_NAMES := ["Ciel", "SSJ4 Goku"]
const CHARACTER_SCALE := 2

## --- Vars ---
# Char Select
var current_char_idx := 0
var char_frame_data : Variant
var char_sprite_animation : AnimatedSprite2D
var char_frame_collider

# Editor
var animation_idx := 0
var animation_frame := 0

### --- Logic ---

## --- Character Select ---
func _ready():
	# Load characters to select
	character_options.clear()
	for character in CHARACTER_NAMES:
		character_options.add_item(character)

func load_character():
	var character_dir = BASE_DIRECTORY + CHARACTER_NAMES[current_char_idx].to_lower() + ".tscn"
	var character_scene = load(character_dir)
	var character_node = character_scene.instantiate()
	char_sprite_animation = character_node.get_node("SpriteAnimation")
	char_sprite_animation.scale *= CHARACTER_SCALE
	char_frame_collider = character_node.get_node("FrameCollider")
	char_frame_collider.scale *= CHARACTER_SCALE
	
	# Separate the sprite animation from its parent
	character_node.remove_child(char_sprite_animation)
	character_node.remove_child(char_frame_collider)
	char_frame_data = character_node.load_frame_data()
	character_node.queue_free()
	character_slot.add_child(char_sprite_animation) #ignore-warnings
	character_slot.add_child(char_frame_collider) #ignore-warnings
	character_editor.show()
	character_select.hide()
	load_collisions(char_frame_data[0])
	load_animations(char_frame_data)
	load_animation_frames(char_sprite_animation)

func _on_character_selected(index):
	current_char_idx = index

## --- Character Editor ---
func load_collisions(frame_data : Dictionary):
	var collision = frame_data.collision
	if "hitboxes" in collision:
		char_frame_collider.create_hitboxes(collision.hitboxes[animation_frame])
	if "hurtboxes" in collision:
		char_frame_collider.create_hurtboxes(collision.hurtboxes[animation_frame])

func load_animations(frame_data_list : Array):
	character_animations.clear()
	for frame_data in frame_data_list:
		character_animations.add_item(frame_data.name)

func load_animation_frames(character_animation : AnimatedSprite2D):
	character_animation_frame.clear()
	for i in range(0, character_animation.sprite_frames.get_frame_count(character_animation.animation)):
		character_animation_frame.add_item(str(i))
