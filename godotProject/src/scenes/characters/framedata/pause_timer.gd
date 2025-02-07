extends Timer



func _on_timeout() -> void:
	get_tree().paused = false
