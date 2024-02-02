extends TextureRect
class_name MaterialSlot

#gets the parent of the slot.
@onready var parent = get_parent().get_parent().get_parent()
#the item that is being stored.
var item: Dictionary = {}

func set_item_data(input_item: Dictionary):
	item = input_item
	%Symbol.text = item["Symbol"]
	
func _get_drag_data(_at_position):
	#the preview to display the materials symbol
	var slot_preview = Label.new()
	
	#store all of the data to trasfer it to another slot.
	var data: Dictionary = {}
	data["origin"] = self
	data["item"] = item
	
	#preview showed
	slot_preview.text = item["Symbol"]
	slot_preview.expand_mode = 1
	slot_preview.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(slot_preview)
	
	set_drag_preview(preview)
	
	return data
	

func _can_drop_data(_at_position, _data):
	#get the node being pointed to.
	var target = get_node(".")
	var target_symbol = target.get_node("Symbol")
	if target is CraftingSlot:
		#make sure that only the correct items are stored within the crafting slot.
		if target.type != "rune" or "base" and !target.texture:
			return true
		else:
			return false
			
	elif target is MaterialSlot:
		#check texture is empty. if so no item stored.
		if !target_symbol.text:
			return true
		else:
			return false
	
func _drop_data(_at_position, data):
	#set the item
	item = data["item"]
	#remove the origin item
	data["origin"].item = {}
	#set the symbol to show
	%Symbol.text = item["Symbol"]
	#remove the orign symbol
	data["origin"].get_node("Symbol").text = ""
