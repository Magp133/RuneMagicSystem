extends TextureRect

func _get_drag_data(at_position):
	#get preview of texture to see it while dragging.
	var texture_preview = TextureRect.new()
	
	var data: Dictionary = {}
	data["origin"] = self
	data["texture"] = texture
	
	texture_preview.texture = texture
	texture_preview.expand_mode = 1
	texture_preview.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(texture_preview)
	
	set_drag_preview(preview)

	
	return data

func _can_drop_data(at_position, data):
	var target = get_node(".")
	if target is TextureRect:
		if target.texture == null:
			return true
		else:
			return false
	else:
		return false

func _drop_data(at_position, data):
	texture = data["texture"]
	data["origin"].texture = null
