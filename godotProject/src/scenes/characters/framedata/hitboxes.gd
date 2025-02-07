extends Area2D
class_name Hitboxes

### --- Nodes ---
@onready var player : Player
@onready var hurtboxes: Area2D = $"../Hurtboxes"
@onready var hit_audio: AudioStreamPlayer = $"../HitAudio"

### --- Consts ---
const SOUND_EFFECTS = {
	"light_attack": preload("res://assets/sounds/combat/light_attack.ogg")
}

### --- Vars ---

var framedata : Dictionary
var damage := 0.0
var knockback := 0.0
var scale_start := 100.0 # in %
var hard_knockdown := false

# Used when an attack is active more than 1 frame. 
# It should ignore the others if one of them hits.
var ignore_same_hitbox := false 


### --- Logic ---

func _ready():
	"""Separate between Frame Data Customization and actual game"""
	var possible_player = get_parent().get_parent()
	if possible_player is Player:
		player = get_parent().get_parent()

func setup_attack(fd: Dictionary) -> void:
	"""Given a framedata, change the global variables."""
	assert("hitboxes" in fd.collision, "Setup attack for a framedata without hitboxes.")
	framedata = fd
	damage = framedata.damage[0] # TODO
	knockback = framedata.knockback
	scale_start = framedata.scale_start
	hard_knockdown = framedata.hard_knockdown

func apply_hitboxes() -> void:
	"""Detect if hurtboxes of ANOTHER player intersected the hitboxes"""
	var enemy_player = player.enemy
	var enemy_collider = enemy_player.get_node("FrameCollider")
	var enemy_hurtboxes = enemy_collider.get_node("Hurtboxes")
	var enemy_hitboxes = enemy_collider.get_node("Hitboxes") # TODO: Clash shenanigans if not hurt anything
	
	# See if any hitbox intersects with other player's hurtboxes
	for hurtbox in enemy_hurtboxes.get_children():
		for hitbox in get_children():
			if are_intersecting(hitbox as CollisionShape2D, hurtbox as CollisionShape2D):
				# Play sound effect
				hit_audio.stream = SOUND_EFFECTS[framedata.hit_sound_effect]
				hit_audio.pitch_scale = randf_range(0.8, 1.2)
				hit_audio.play()
				
				# Apply hit
				enemy_player.take_damage(damage, knockback, scale_start)
				ignore_same_hitbox = true
				
				# Add cancels
				player.hit_cancels = framedata.cancels.hit
				return # Avoid multiple hits in a single frame
	
	for e_hitbox in enemy_hitboxes.get_children():
		for hitbox in get_children():
			if are_intersecting(hitbox as CollisionShape2D, e_hitbox as CollisionShape2D):
				return # Avoid multiple hits in a single frame
		

func are_intersecting(colA: CollisionShape2D, colB: CollisionShape2D) -> bool:
	"""Determines if two collision shapes (rectangles) are intersecting."""
	var boxA = colA.shape as RectangleShape2D
	var boxB = colB.shape as RectangleShape2D
	
	var offset_a = boxA.extents
	var offset_b = boxB.extents
	
	var a_right = colA.global_position.x + offset_a.x
	var a_left = colA.global_position.x - offset_a.x
	var a_top = colA.global_position.y - offset_a.y
	var a_bottom = colA.global_position.y + offset_a.y
	
	var b_right = colB.global_position.x + offset_b.x
	var b_left = colB.global_position.x - offset_b.x
	var b_top = colB.global_position.y - offset_b.y
	var b_bottom = colB.global_position.y + offset_b.y
	
	return (a_right > b_left and a_left < b_right and
			a_bottom > b_top and a_top < b_bottom)

func process(_delta: float) -> void:
	"""Works as the '_process()', however called by the CollisionUpdater."""
	
	# Shouldn't detect collisions on the customization scene
	if player == null: return
	
	# If hitboxes spends 1 frame without an attack, remove the "ignore_same_hitbox"
	if get_child_count() == 0: ignore_same_hitbox = false
	
	# Only detect collisions if is to ignore the same hitbox
	if not ignore_same_hitbox:
		apply_hitboxes()
