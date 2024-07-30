extends Node2D

## --- Nodes ---
@onready var hurtboxes = $Hurtboxes
@onready var hitboxes = $Hitboxes

## --- Logic ----
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
