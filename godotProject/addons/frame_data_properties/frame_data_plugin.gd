@tool
extends EditorPlugin

## --- Nodes ---
const MainPanel = preload("res://addons/frame_data_properties/main_panel.tscn")
var main_panel_instance

## --- Logic ---
func _enter_tree():
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)


func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "Frame Data Properties"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("CharacterBody2D", "EditorIcons")
