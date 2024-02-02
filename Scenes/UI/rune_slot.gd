extends TextureRect
class_name RuneSlot

#gets the parent of the slot.
@onready var parent = get_parent().get_parent().get_parent()
#the item that is being stored.
var item: Dictionary

func set_item_data(input_item: Dictionary):
	#input item is a rune data item
	item = input_item
	texture = load("res://Textures/" + item["Name"] + ".png")
	
func _get_drag_data(at_position):
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
	

func _can_drop_data(_at_position, _data):
	var target = get_node(".")
	if target is CraftingSlot:
		#make sure that only the correct items are stored within the crafting slot.
		if target.type != "material" or "base" and !target.texture:
			return true
		else:
			return false
	if target is RuneSlot:
		if !target.texture:
			return true
		else:
			return false
	
func _drop_data(_at_position, data):
	#set the item
	item = data["item"]
	#remove the origin item
	data["origin"].item = {}
	#set the texture
	texture = data["texture"]
	#remove origin texture
	data["origin"].texture = null
	
	
