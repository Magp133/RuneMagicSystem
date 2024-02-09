extends TextureRect
class_name MaterialSlot

signal remove_shape_from_craft

#gets the parent of the slot.
@onready var parent = get_parent().get_parent().get_parent()
#the item that is being stored.
var item: Dictionary = {}

func set_item_data(input_item: Dictionary):
	item = input_item
	%Symbol.text = item["Symbol"]
	
func _get_drag_data(_at_position):
	if item.size() > 0:
		#the preview to display the materials symbol
		var slot_preview = Label.new()
		
		#store all of the data to trasfer it to another slot.
		var data: Dictionary = {}
		data["origin"] = self
		data["item"] = item
		
		#preview showed
		slot_preview.text = item["Symbol"]
		slot_preview.size = Vector2(30,30)
		
		var preview = Control.new()
		preview.add_child(slot_preview)
		
		set_drag_preview(preview)
		
		return data
	

func _can_drop_data(_at_position, data):
	var target_symbol = get_node("Symbol")
	if data:
		if data["item"]["Type"] == "material" and !target_symbol.text:
			return true
		
func _drop_data(_at_position, data):
	#set the item
	item = data["item"]
	#remove the origin item
	data["origin"].item = {}
	#set the symbol to show
	%Symbol.text = item["Symbol"]
	#remove the orign symbol
	data["origin"].get_node("Symbol").text = ""
