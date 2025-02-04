extends VBoxContainer
class_name CollisionProperty


### --- Signals

signal collision_properties_changed(type, idx, properties)
signal delete_collision_property(type, idx)

### --- Nodes
@onready var collision_number: Label = $CenterContainer/HBoxContainer/CollisionNumber
@onready var pos_x: SpinBox = $GridContainer/PosX
@onready var pos_y: SpinBox = $GridContainer/PosY
@onready var size_x: SpinBox = $GridContainer/SizeX
@onready var size_y: SpinBox = $GridContainer/SizeY

### --- Logic
var index: int # Used to signal parent that THIS collision had changes
var type: String

func fill_collision_properties(collision: Array, idx: int, type_str: String):
	# type = "hurtboxes" or "hitboxes"
	index = idx
	type = type_str
	collision_number.text = str(idx)
	# Attribute collision values to inputs
	pos_x.value = collision[0]
	pos_y.value = collision[1]
	size_x.value = collision[2]
	size_y.value = collision[3]
	
	# If collision is deleted (temporary = [0, 0, 0, 0]), hide it.
	if collision == [0, 0, 0, 0]:
		hide()


func generate_properties(value):
	# Send signal of inputs to a usable form. Sent everytime they change.
	var collision_properties = [pos_x.value, pos_y.value, size_x.value, size_y.value]
	collision_properties_changed.emit(type, index, collision_properties)

func _on_delete_button_pressed() -> void:
	delete_collision_property.emit(type, index)
	hide()
