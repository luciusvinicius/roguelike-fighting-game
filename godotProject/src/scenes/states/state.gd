class_name State
extends Node

## --- Vars ---
var enum_name

## --- Signals ---
signal state_exited_to(new_state, args)

## --- Logic ---
func update(_delta):
	pass # Replace with function body.

func enter(_args):
	pass

func exit():
	pass

func go_to_state(new_state, args = []):
	state_exited_to.emit(new_state, args)
	
func _is_current_state() -> bool:
	return get_parent().curr_state.enum_name == enum_name
