extends Node
class_name CollisionUpdater

### --- Vars ---
@export var player1: Player
@export var player2: Player

### --- Logics ---

# Used to detect collisions AFTER players changing them
func _process(delta: float) -> void:
	player1.frame_collider.hitboxes.process(delta)
	player2.frame_collider.hitboxes.process(delta)
	
