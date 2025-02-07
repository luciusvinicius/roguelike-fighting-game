extends Node2D
class_name FrameCollider

## --- Signal ---
signal counter_hit
signal punish

## --- Nodes ---
@onready var hurtboxes = $Hurtboxes
@onready var hitboxes : Hitboxes = $Hitboxes

## --- Consts ---
const HURTBOX_COLOR = "3ca1406b"
const HITBOX_COLOR = "f530346b"

## --- Vars ---
var hit_type : String


## --- Logic ----

func setup(_framedata: Variant) -> void:
	"""Applies logic of punish, counterhit, etc..."""
	#if framedata.get("counter_hittable"):
		#hit_type
	reset_collision()

func setup_collisions(fd: Variant, idx: int, direction := 1):
	# Direction = -1 (left/flipped) or 1 (right)
	reset_collision()
	var collision = fd.collision
	if "hurtboxes" in collision:
		create_hurtboxes(collision["hurtboxes"][idx], direction)
	if "hitboxes" in collision:
		create_hitboxes(collision["hitboxes"][idx], direction)
		# Setup attack properties
		hitboxes.setup_attack(fd)
		

func reset_collision() -> void:
	"""Remove all hitboxes and hurtboxes."""
	for hitbox in hitboxes.get_children():
		hitbox.queue_free()
	for hurtbox in hurtboxes.get_children():
		hurtbox.queue_free()

func create_hurtboxes(hboxes: Array, direction: int) -> void:
	"""Create the hurtboxes of a specific frame given by [pos_x, pos_y, width, height]"""
	create_collisions(hboxes, "hurtbox", direction)

func create_hitboxes(hboxes: Array, direction: int) -> void:
	"""Create the hitboxes of a specific frame given by [pos_x, pos_y, width, height]"""
	create_collisions(hboxes, "hitbox", direction)

func create_collisions(collisions: Array, type, direction) -> void:
	"""Create associated hitboxes or hurtboxes, given by type ("hurtbox"; "hitbox")"""
	for collision in collisions:
		var pos_x: float =  collision[0] * direction
		var pos_y: float =  collision[1]
		var width: float =  collision[2]
		var height: float = collision[3]
		var collision_node := CollisionShape2D.new()
		collision_node.shape = RectangleShape2D.new()
		collision_node.position = Vector2(pos_x, pos_y)
		collision_node.shape.size = Vector2(width, height)
		
		# Add new created node
		match type:
			"hurtbox":
				collision_node.debug_color = HURTBOX_COLOR
				hurtboxes.add_child(collision_node)
			"hitbox":
				collision_node.debug_color = HITBOX_COLOR
				hitboxes.add_child(collision_node)

## --- Others ---
func get_number_of_frames(frame_data) -> int: 
	var collision = frame_data.collision
	if "hurtboxes" in collision:
		return collision.hurtboxes.size()
	if "hitboxes" in collision:
		return collision.hitboxes.size()
	# No boxes?
	return 0

func enable():
	for collision : CollisionShape2D in hurtboxes.get_children():
		collision.disabled = false
	for collision : CollisionShape2D in hitboxes.get_children():
		collision.disabled = false

func disable():
	for collision : CollisionShape2D in hurtboxes.get_children():
		collision.disabled = true
	for collision : CollisionShape2D in hitboxes.get_children():
		collision.disabled = true
