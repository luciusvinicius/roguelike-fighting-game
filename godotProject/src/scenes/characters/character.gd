class_name Player
extends CharacterBody2D


## --- Nodes ---
@onready var sprite_animation = $SpriteAnimation
@onready var default_frame_collider = $DefaultFrameCollider
@onready var state_machines = $StateMachines

## --- Consts ---
const FOWARD_SPEED := 150.0
const BACKWARDS_SPEED := 100.0
const BACKWARDS_BREAK_SPEED := 50.0
const FOWARD_DASH_SPEED := 450.0
const FOWARD_BREAK_SPEED := 25.0
const BACK_DASH_SPEED := 250.0

const JUMP_VELOCITY = -400.0


## --- Vars ---
var blocking = [] # ["low"], ["high"], ["low", "high"]?

## --- Logic ---

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Run state machines
	for state_machine in state_machines.get_children():
		state_machine.start()

#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

## --- Auxiliar Functions ---
func get_facing_direction() -> int:
	return -1 if sprite_animation.flip_h else 1
