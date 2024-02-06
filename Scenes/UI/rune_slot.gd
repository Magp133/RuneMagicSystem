extends TextureRect
class_name RuneSlot

#signals
signal remove_shape_from_craft

#gets the parent of the slot.
@onready var parent = get_parent().get_parent().get_parent()

#the item that is being stored.
var item: Dictionary = {}

func set_item_data(input_item: Dictionary):
	#input item is a rune data item
	item = input_item
	texture = load("res://Textures/" + item["Name"] + ".png")
	
func _get_drag_data(_at_position):
	if item.size() > 0:
		#the preview to display the materials symbol
		var slot_preview = TextureRect.new()
		
		#store all of the data to trasfer it to another slot.
		var data: Dictionary = {}
		data["origin"] = self
		data["item"] = item
		data["texture"] = texture
		
		slot_preview.texture = texture
		slot_preview.expand_mode = 1
		slot_preview.size = Vector2(30,30)
		
		var preview = Control.new()
		preview.add_child(slot_preview)
		
		set_drag_preview(preview)
		
		return data
		

func _can_drop_data(_at_position, data):
	if data:
		var target = get_node(".")
		if data["item"]["Type"] == 'rune' and !target.texture:
			return true
	
func _drop_data(_at_position, data):
	#set the item
	item = data["item"]
	#remove the origin item
	data["origin"].item = {}
	#set the texture
	texture = data["texture"]
	#remove origin texture
	data["origin"].texture = null
	
	
	if data["origin"] is CraftingSlot:
		remove_shape_from_craft.emit(data["origin"])
	
	
