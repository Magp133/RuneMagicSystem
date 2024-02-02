extends TextureRect
class_name CraftingSlot

#gets the parent of the slot.
@onready var parent = get_parent().get_parent().get_parent()
#the item that is being stored.
var item: Dictionary
#type of crafting slot the slot is.
#base is the first slot available and has to be a rune
#aux is for secondary runes
#material is for materials
var type: String

#signals

#dont think ill need this as it wont be initialised with item data
#func set_item_data(input_item: Dictionary):
	#input item is a any data item
	#item = input_item
	#if item["Type"] == "material":
		#%Symbol.text = item["Symbol"]
	#elif item["Type"] == "rune":
		#texture = load("res://Textures/" + item["Name"] + ".png")
	
func _get_drag_data(at_position):
	#the preview to display the item
	var slot_preview
	
	#store all of the data to trasfer it to another slot.
	var data: Dictionary = {}
	data["origin"] = self
	data["item"] = item
	if type == "base" or "aux":
		#it is only storing runes.
		#which is a texture
		data["texture"] = texture
		slot_preview = TextureRect.new()
		slot_preview.texture = texture
	
	else:
		slot_preview = Label.new()
		slot_preview.text = item["Symbol"]
		
	
	slot_preview.expand_mode = 1
	slot_preview.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(slot_preview)
	
	set_drag_preview(preview)
	
	return data
	#otherwise it stores materials so no further stuff is required
	

func _can_drop_data(at_position, data):
	var target = get_node(".")
	var target_symbol = target.get_node("Symbol")
	
	#target is a material slot trying to put material item into the material slot
	if target is MaterialSlot and data["item"]["Type"] == "material":
		if !target_symbol.text:
			data["target"] = "material"
			return true
		else:
			return false
	#target is a crafting slot
	elif target is CraftingSlot:
		#target stores material and if item is a material type then can move item
		if target.type == "material" and data["item"]["Type"] == "material":
			if !target_symbol.text:
				data["target"] = "material"
				return true
			else:
				return false
				
		#target stores spells and runes
		elif data["item"]["Type"] != "material":
			if !target.texture:
				data["target"] = "rune"
				return true
			else:
				return false
	
	return data
	
func _drop_data(at_position, data):
	if data["target"] == "material":
		#set the item
		item = data["item"]
		#remove the origin item
		data["origin"].item = {}
		#set the symbol to show
		%Symbol.text = item["Symbol"]
		#remove the orign symbol
		data["origin"].get_node("Symbol").text = ""
		
	else:
		#set the item
		item = data["item"]
		#remove the origin item
		data["origin"].item = {}
		#set the texture
		texture = data["texture"]
		#remove origin texture
		data["origin"].texture = null
