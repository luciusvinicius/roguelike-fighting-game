extends Node
class_name CharacterPhysics

### --- Nodes ---
@onready var player: Player = $".."

### --- Consts ---
const MOMENTUM_SLOWDOWN_RATE = 200

### --- Vars ---
var velocity_momentum := Vector2.ZERO
var momentum_slowdown_rate := 0.0 # Equal 4 times the initial intensity

### --- Logics ---
func apply_knockback(intensity: float, direction: Vector2): 
	# TODO: not sure if direction is needed.
	velocity_momentum += intensity * direction * 2.5
	momentum_slowdown_rate = velocity_momentum.x * 4
	player.velocity += velocity_momentum
	var pre_velocity = player.velocity # Used when in the corner.
	player.move_and_slide()
	var post_velocity = player.velocity
	
	# If in corner, apply knockback on enemy
	if pre_velocity != post_velocity:
		player.enemy.character_physics.apply_knockback(intensity, direction * -1)

func _physics_process(delta: float) -> void:
	var player_direction = player.get_facing_direction() * -1
	velocity_momentum = velocity_momentum.move_toward(Vector2.ZERO, delta * momentum_slowdown_rate * player_direction)
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * momentum_slowdown_rate * player_direction)
