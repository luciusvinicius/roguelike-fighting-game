extends CenterContainer

### --- Imports ---
const COLLISION_PROPERTY_SCENE = preload("res://src/scenes/menus/collision_property.tscn")

## --- Nodes ---
@onready var character_options = $CharacterSelect/Col/CharacterOptions
@onready var character_select = $CharacterSelect
@onready var character_editor = $CharacterEditor
@onready var character_slot = $CharacterEditor/Row/CenterContainer/CharacterSlot

@onready var character_animations = $CharacterEditor/Row/Col/Animations
@onready var character_animation_frame = $CharacterEditor/Row/Col/Frame
@onready var play_animation_button: Button = $CharacterEditor/Row/Col/PlayAnimation

# Collision Tab
@onready var hurtboxes_tab: VBoxContainer = $CharacterEditor/Row/CollisionTabs/Hurtboxes/HurtboxesVBox
@onready var hitboxes_tab: VBoxContainer = $CharacterEditor/Row/CollisionTabs/Hitboxes/HitboxesVBox

## --- Consts ---
const BASE_DIRECTORY := "res://src/scenes/characters/characters/"
const CHARACTER_NAMES := ["Ciel", "SSJ4 Goku"]
const CHARACTER_SCALE := 2

## --- Vars ---
# Char Select
var current_char_idx := 0
var char_frame_data : Variant # Dict
var char_sprite_animation : AnimatedSprite2D
var char_frame_collider

# Editor
var animation_idx := 0

### --- Logic ---

## --- Character Select ---
func _ready():
	# Load characters to select
	character_options.clear()
	for character in CHARACTER_NAMES:
		character_options.add_item(character)

func _on_character_selected(index):
	current_char_idx = index

func load_character():
	var character_dir = BASE_DIRECTORY + CHARACTER_NAMES[current_char_idx].to_lower() + ".tscn"
	var character_scene = load(character_dir)
	var character_node = character_scene.instantiate()
	char_sprite_animation = character_node.get_node("SpriteAnimation")
	char_sprite_animation.scale *= CHARACTER_SCALE
	char_frame_collider = character_node.get_node("FrameCollider")
	char_frame_collider.scale *= CHARACTER_SCALE
	
	# Separate the sprite animation from its character parent
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


## --- Character Editor ---
# Animations
func load_collisions(frame_data : Dictionary, ignore_collision_tab := false):
	var collision = frame_data.collision
	var animation_frame = char_sprite_animation.frame
	char_frame_collider.reset_collision()
	if "hitboxes" in collision:
		char_frame_collider.create_hitboxes(collision.hitboxes[animation_frame])
	if "hurtboxes" in collision:
		char_frame_collider.create_hurtboxes(collision.hurtboxes[animation_frame])
	
	# Setup signal for mouse hover collision (not used)
	var hurtboxes = char_frame_collider.get_node("Hurtboxes")
	var hitboxes = char_frame_collider.get_node("Hitboxes")
	# Load collisions to edit (smal TODO: turn into function for "hitboxes")
	if ignore_collision_tab: return # For some reason it does recursive loop if not.
	# Setup window to edit collisions
	# Remove existing collisions
	remove_children_from_properties(hurtboxes_tab)
	remove_children_from_properties(hitboxes_tab)
	
	if "hurtboxes" in collision:
		create_collision_properties(collision, animation_frame, "hurtboxes")
	if "hitboxes" in collision:
		create_collision_properties(collision, animation_frame, "hitboxes")
	


func load_animations(frame_data_list : Array):
	character_animations.clear()
	for frame_data in frame_data_list:
		character_animations.add_item(frame_data.name)

func load_animation(idx:int):
	var frame_data = char_frame_data[idx]
	char_sprite_animation.animation = frame_data.sprite_animation
	load_animation_frames(char_sprite_animation)

func _on_animations_item_selected(index: int) -> void:
	animation_idx = index
	load_animation_frame(0)
	load_collisions(char_frame_data[index])
	load_animation(index)

func load_animation_frames(character_animation : AnimatedSprite2D):
	character_animation_frame.clear()
	for i in range(0, character_animation.sprite_frames.get_frame_count(character_animation.animation)):
		character_animation_frame.add_item(str(i))

func load_animation_frame(frame_number : int):
	char_sprite_animation.frame = frame_number

func _on_frame_item_selected(index: int) -> void:
	load_animation_frame(index)
	load_collisions(char_frame_data[animation_idx])



## --- Hitboxes / Hurtboxes ---
func create_collision_properties(collision: Dictionary, animation_frame:int, type: String):
	# type = "hurtboxes" or "hitboxes"
	var collision_idx = 0
	var tab = hurtboxes_tab if type == "hurtboxes" else hitboxes_tab
	for box in collision[type][animation_frame]:
		var collision_property_node : CollisionProperty = COLLISION_PROPERTY_SCENE.instantiate()
		tab.add_child(collision_property_node)
		# Connect to receive changes in the input
		collision_property_node.collision_properties_changed.connect(change_collision_properties)
		collision_property_node.delete_collision_property.connect(delete_collision_property)
		collision_property_node.fill_collision_properties(box, collision_idx, type)
		collision_idx += 1

func change_collision_properties(type: String, idx: int, properties: Array):
	# type = "hurtboxes" or "hitboxes"
	var collision = char_frame_data[animation_idx].collision[type]
	var animation_frame = char_sprite_animation.frame
	collision[animation_frame][idx] = properties
	load_collisions(char_frame_data[animation_idx], true) # ignore collision window

func delete_collision_property(type: String, idx: int):
	var collision = char_frame_data[animation_idx].collision[type]
	var animation_frame = char_sprite_animation.frame
	collision[animation_frame][idx] = [0, 0, 0, 0] # if size = 0, collision doesn't exist lmao. TODO: when saving, remove those cursed collisions
	load_collisions(char_frame_data[animation_idx], true) # ignore collision window

func remove_children_from_properties(node):
	var child_idx = 1 # keep the "NEW" button on the collisions
	while child_idx < node.get_child_count():
		# Remove first child until only the first remains
		var child = node.get_child(child_idx)
		node.remove_child(child)
		child.queue_free()

func _on_new_collision_pressed(type: String) -> void:
	var collision = char_frame_data[animation_idx].collision[type]
	var animation_frame = char_sprite_animation.frame
	collision[animation_frame].append([0, 0, 20, 20])
	load_collisions(char_frame_data[animation_idx]) # ignore collision window

func save_frame_data(frame_data: Dictionary):
	var frame_data_file = "res://src/scenes/characters/framedata/%s" % CHARACTER_NAMES[current_char_idx].to_lower() + "_test.json"
	var file = FileAccess.open(frame_data_file, FileAccess.WRITE)
	# TODO: remove collisions with [0, 0, 0, 0]
	file.store_string(JSON.stringify(frame_data))


## --- Extras ---

func _process(delta: float) -> void:
	# Load collision when the animations is being played
	if not char_sprite_animation or not char_sprite_animation.is_playing(): return
	load_collisions(char_frame_data[animation_idx])

func play_animation():
	# Disable/Enable change of inputs and puts the animation to play
	if char_sprite_animation.is_playing():
		character_animations.disabled = false
		character_animation_frame.disabled = false
		char_sprite_animation.pause()
		play_animation_button.text = "Play Animation"
		
	else:
		character_animations.disabled = true
		character_animation_frame.disabled = true
		char_sprite_animation.play()
		play_animation_button.text = "Stop Animation"
		

func _on_play_animation_pressed() -> void:
	play_animation()
