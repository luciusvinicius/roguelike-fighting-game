extends Node

### --- Consts ---
const FRAME_BUFFER = 20
const PRIORITY = [["jump", "dash"], [""]]
const IGNORED_EVENTS = ["ui_text_skip_selection_for_next_occurrence"] # Events that still trigger for some reason even without the InputMap there.
const SPECIAL_INPUTS = [
	{
		"key": "236",
		"actions": [["crouch"], ["crouch", "right"], ["right"]]
	},
	{
		"key": "623",
		"actions": [["right"], ["crouch"], ["crouch", "right"]]
	}
]

### --- Vars ---
var buffer := [] 
# [{"actions": ["jump/5A/etc..."], "frame": INTEGER}, {...}, {...}]. 
# If they were made FRAME_BUFFER frames before, they are removed

var curr_frame := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print("Buffer: ", buffer)
	
	var current_input = get_pressed_input()
	add_to_buffer(current_input)
	delete_previous_buffers()
	detect_specials()
	curr_frame += 1

func is_action_pressed(action: String) -> bool:
	"""Returns if determined action is pressed in the Buffer and remove it."""
	return false

func delete_previous_buffers() -> void:
	"""Delete previous inputs in buffer if before FRAME BUFFER"""
	var input_idx = 0
	for input in buffer:
		if input.frame < curr_frame - FRAME_BUFFER:
			buffer.pop_at(input_idx)
		else:
			input_idx += 1

func detect_specials() -> void:
	"""Given SPECIAL_INPUTS, add an special to the buffer if detected."""
	for special_input in SPECIAL_INPUTS:
		var special_actions = special_input.actions
		
		# If special action is already in buffer, skip it.
		var should_continue = false
		for input in buffer:
			if special_input.key in input.actions: should_continue = true
		if should_continue: continue
		
		# See if the sequence happens in the buffer
		if buffer.size() < special_actions.size(): continue
		
		var correct_actions = 0	
		for input in buffer:
			if input.actions == special_actions[correct_actions]:
				correct_actions += 1
			#else: # Not sure if it is needed
				#correct_actions = 0
			
			if correct_actions == special_actions.size():
				buffer.insert(0, {"actions": [special_input.key], "frame": curr_frame}) # insert at beginning to not repeat the last input in the buffer.
				break
				
			
			
			#for special_idx in range(special_actions.size()):
				#if input.actions[special_idx] == special_actions[special_idx][correct_actions]:
					#correct_actions += 1
				#else:
					#correct_actions = 0
			#if correct_actions == special_actions.size():
				#buffer.append({"action": ["236"], "frame": curr_frame})
				#break
		

func get_pressed_input() -> Array:
	"""Iterate every possible input action and returned the pressed, if any."""
	# God, imagine having the method Input.get_actions_pressed()
	var pressed_inputs = []
	
	var direction = Input.get_axis("jump", "crouch")
	if direction < 0: pressed_inputs.append("jump")
	elif direction > 0: pressed_inputs.append("crouch")
	
	direction = Input.get_axis("left", "right")
	if direction < 0: pressed_inputs.append("left")
	elif direction > 0: pressed_inputs.append("right")
	
	if Input.is_action_pressed("a"):
		pressed_inputs.append("a")
	if Input.is_action_pressed("b"):
		pressed_inputs.append("b")
	if Input.is_action_pressed("c"):
		pressed_inputs.append("c")
	return pressed_inputs

func add_to_buffer(actions: Array) -> void:
	"""Adds input to buffer, if they exist. If it is the same input as before, increase its frame (holding inputs)."""
	if actions.size() == 0: return
	var previous_buffer_input = buffer[-1] if buffer.size() != 0 else {"actions": []}
	# Check if the inputs pressed now are equal to the previous (hold)
	var new_buffer_input = {
		"actions": actions,
		"frame": curr_frame
	}
	if previous_buffer_input.actions.size() != actions.size():
		buffer.append(new_buffer_input)
	
	else: # Same size of actions. Check if they are equal.
		for action_idx in range(actions.size()):
			if actions[action_idx] != previous_buffer_input.actions[action_idx]:
				buffer.append(new_buffer_input)
				return
		
		# They are literally the same (holding input)
		previous_buffer_input.frame = curr_frame











#func _unhandled_input(event: InputEvent) -> void:
	#for action in InputMap.get_actions():
		#if action in IGNORED_EVENTS: continue
		#if event.is_action(action):
			#print(action)
			## Check if the previous buffer action was the same input. If true, then it should overwrite.
			#
			#var previous_buffer_input = buffer[-1] if buffer.size() != 0 else {"action": ""}
			#if previous_buffer_input.action == action:
				#previous_buffer_input.frame = curr_frame
			#else:
				#var buffer_input = {
					#"action": action,
					#"frame": curr_frame
					#}
				#buffer.append(buffer_input)
