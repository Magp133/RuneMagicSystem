extends TextureRect

func _get_drag_data(at_position):
	#get preview of texture to see it while dragging.
	var texture_preview = TextureRect.new()
	
	texture_preview.texture = texture
	texture_preview.expand_mode = 1
	texture_preview.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(texture_preview)
	
	set_drag_preview(preview)
	#make the data empty if desired
	texture = null
	
	return texture_preview.texture

func _can_drop_data(at_position, data):
	return data is Texture2D

func _drop_data(at_position, data):
	texture = data
