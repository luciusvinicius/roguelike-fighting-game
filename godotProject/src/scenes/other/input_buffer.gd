extends Node
class_name InputBuffer

### --- Consts ---
const MOTION_FRAME_BUFFER = 20
const ACTION_FRAME_BUFFER = 10
const PRIORITY = [["jump", "dash"], [""]] # 623 should have priority if related to 236
const ATTACK_ACTIONS = ["a", "b", "c"]
const SPECIAL_INPUTS = [
	{
		"key": "236",
		"actions": [["crouch"], ["crouch", "right"], ["right"]]
	},
	{
		"key": "623",
		"actions": [["right"], ["crouch"], ["crouch", "right"]]
	},
	{
		"key": "214",
		"actions": [["crouch"], ["crouch", "left"], ["left"]]
	},
	{
		"key": "632146",
		"actions": [["right"], ["crouch", "right"], ["crouch"], ["crouch", "left"], ["left"], ["right"]]
	}
] # TODO: add charge moves

### --- Vars ---
var motion_buffer := [] # Used to detect special moves.
var action_buffer := [] # Used to apply action on the first frame possible.
# [{"actions": ["jump/5A/etc..."], "frame": INTEGER}, {...}, {...}]. 
# If they were made MOTION_FRAME_BUFFER frames before, they are removed

var curr_frame := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#print("Motion Buffer: ", motion_buffer)
	#print("Action Buffer: ", action_buffer)
	
	var current_input = _get_pressed_input()
	_add_to_buffer(current_input, motion_buffer)
	_add_to_buffer(current_input, action_buffer)
	_delete_previous_buffers(motion_buffer, MOTION_FRAME_BUFFER)
	_delete_previous_buffers(action_buffer, ACTION_FRAME_BUFFER)
	_detect_specials()
	curr_frame += 1



## --- Export Functions ---
func is_action_pressed(action: String) -> bool:
	"""Returns if determined action is pressed in the Buffer."""
	# Previously it would remove it. But I don't think it is necessary anymore.
	# TODO: what to do when blockstun for instance. Should remove it after done? idk
	for input in action_buffer:
		if action in input.actions: return true
	return false

func get_axis(action1: String, action2: String, remove_from_buffer := true) -> int:
	"""Returns -1 if only action1, 1 if only action 2 or 0 if both or neither."""
	var total_axis := 0
	
	var action_buffer_idx = 0
	for input in action_buffer:
		if action1 in input.actions:
			total_axis -= 1
			if remove_from_buffer:
				# Should only remove if they are the only input (eg. ["left"] instead of ["left", "dash"])
				if [action1] == input.actions:
					action_buffer.remove_at(action_buffer_idx)
			break
		action_buffer_idx += 1
	
	action_buffer_idx = 0
	for input in action_buffer:
		if action2 in input.actions:
			total_axis += 1
			if remove_from_buffer:
				# Should only remove if they are the only input (eg. ["left"] instead of ["left", "dash"])
				if [action2] == input.actions:
					action_buffer.remove_at(action_buffer_idx)
			break
		action_buffer_idx += 1
	
	return total_axis

func get_attack() -> String:
	"""Based on Action Buffer, return attack animation to be performed as String.
	Returns empty String if there are no attacks."""
	# TODO: Acredito que aqui tenha prioridade. Also adicionar lógica para specials.
	
	# Identify the FIRST attack that appears.
	var selected_attack_action = ""
	var selected_action = []
	for input in action_buffer:
		var attack_action = input.actions.filter(func(act): return act in ATTACK_ACTIONS)
		if attack_action.size() > 0:
			selected_attack_action = attack_action[0].to_upper()
			selected_action = input.actions
	
	# If there are no attacks, then it doesn't matter if the player is crouched or not.
	if selected_attack_action == "": return ""
	
	# Identify if it is crouch.
	if "crouch" in selected_action:
		return "2%s" % selected_attack_action
	return "5%s" % selected_attack_action


## --- Internal Logic ---
func _delete_previous_buffers(buffer: Array, frame_limit: int) -> void:
	"""Delete previous inputs in motion_buffer if before FRAME BUFFER"""
	var input_idx = 0
	for input in buffer:
		if input.frame < curr_frame - frame_limit:
			print("removed ", input)
			buffer.pop_at(input_idx)
		else:
			input_idx += 1

func _detect_specials() -> void:
	"""Given SPECIAL_INPUTS, add an special to the motion_buffer if detected."""
	for special_input in SPECIAL_INPUTS:
		var special_actions = special_input.actions
		
		# If special action is already in motion_buffer, skip it.
		var should_continue = false
		for input in motion_buffer:
			if special_input.key in input.actions: should_continue = true
		if should_continue: continue
		
		# See if the sequence happens in the motion_buffer
		if motion_buffer.size() < special_actions.size(): continue
		
		var correct_actions = 0	
		for input in motion_buffer:
			if input.actions == special_actions[correct_actions]:
				correct_actions += 1
			
			if correct_actions == special_actions.size():
				# Insert at beginning to not repeat the last input in the motion_buffer.
				motion_buffer.insert(0, {"actions": [special_input.key], "frame": curr_frame}) 
				action_buffer.append({"actions": [special_input.key], "frame": curr_frame}) 
				break
				
		

func _get_pressed_input() -> Array:
	"""Iterate every possible input action and returned the pressed, if any."""
	# God, imagine having the method Input.get_actions_pressed()
	var pressed_inputs = []
	
	if Input.is_action_just_pressed("dash"):
		pressed_inputs.append("dash")
	
	var direction = Input.get_axis("jump", "crouch")
	if direction < 0: pressed_inputs.append("jump")
	elif direction > 0: pressed_inputs.append("crouch")
	
	direction = Input.get_axis("left", "right")
	if direction < 0: pressed_inputs.append("left")
	elif direction > 0: pressed_inputs.append("right")
	
	if Input.is_action_just_pressed("a"):
		pressed_inputs.append("a")
	if Input.is_action_just_pressed("b"):
		pressed_inputs.append("b")
	if Input.is_action_just_pressed("c"):
		pressed_inputs.append("c")
	return pressed_inputs

func _add_to_buffer(actions: Array, buffer: Array) -> void:
	"""Adds input to motion_buffer, if they exist. If it is the same input as before, increase its frame (holding inputs)."""
	if actions.size() == 0: return
	if buffer == action_buffer:
		pass
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
