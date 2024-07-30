@tool
extends Node

## --- Vars ---
var curr_state : State # Starts with first child node
var running := false

const DEBUG := false

## --- Logic ---

func _ready():
	if Engine.is_editor_hint():
		update_configuration_warnings()
	else:
		# Connect every state exit signals to handler
		for state in get_children():
			state.state_exited_to.connect(exit_state)

func start():
	curr_state = get_child(0)
	curr_state.enter()
	running = true

func _physics_process(delta):
	if not Engine.is_editor_hint() and running:
		curr_state.update(delta)

func exit_state(new_state : int) -> void:
	if not Engine.is_editor_hint():
		if DEBUG:
			print("DEBUG - Exiting State: ", curr_state)
		curr_state.exit()
		
		# Get correct node based on enum
		var new_curr_state
		for state in get_children():
			if state.enum_name == new_state:
				new_curr_state = state
				break
				
		curr_state = new_curr_state
		if DEBUG:
			print("DEBUG - Entering State: ", new_curr_state)
		new_curr_state.enter()


# --- Editor ---
func _get_configuration_warnings() -> PackedStringArray:
	if get_child_count() == 0:
		return ["StateMachine needs 'State' children to work properly."]
	
	for child in get_children():
		if not child is State:
			return ["Every StateMachine's child needs to be a 'State' scene."]
			
	return []
