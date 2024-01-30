extends TextureRect

var data_dict: Dictionary = {}


func set_item_data(item: Dictionary):
	data_dict["item"] = item
	%Symbol.text = item["Symbol"]
	

func _get_drag_data(_at_position):
	#get preview of texture to see it while dragging.
	var texture_preview = TextureRect.new()
	

	data_dict["origin"] = %Symbol
	data_dict["texture"] = texture
	data_dict["text"] = %Symbol.text
	
	texture_preview.texture = texture
	texture_preview.expand_mode = 1
	texture_preview.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(texture_preview)
	
	set_drag_preview(preview)

	
	return data_dict

func _can_drop_data(_at_position, _data):
	var target = get_node(".")
	var target_label = target.get_node("Symbol")
	
	
	
	if target is TextureRect:
		if !target_label.text:
			return true
		else:
			return false
	else:
		return false

func _drop_data(_at_position, data):
	%Symbol.text = data["text"]
	data["origin"].text = ""
