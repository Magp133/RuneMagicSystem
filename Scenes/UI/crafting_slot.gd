extends TextureRect
class_name CraftingSlot

#gets the parent of the slot.
@onready var rune_container = get_parent()
#the item that is being stored.
var item: Dictionary = {}
var grid_position: int = -1


#type of crafting slot the slot is.
#base is the first slot available and has to be a rune
#aux is for secondary runes
#material is for materials
var slot_type: String
@onready var spell_crafter = $"../../.."

#signals
signal draw_shape

func _process(_delta):
	var event = Input.is_action_just_pressed("right_click")
	var distance: float
	var mouse_position: Vector2 = get_global_mouse_position()
	
	distance = sqrt((global_position.x - mouse_position.x + size.x / 2) ** 2 + (global_position.y - mouse_position.y + size.y / 2) ** 2)
	
	if event and distance < 25:
		item = {}
		texture = null
		%Symbol.text = ""
		spell_crafter.remove_shape(grid_position, self)



#dont think ill need this as it wont be initialised with item data
#func set_item_data(input_item: Dictionary):
	##input item is a any data item
	#item = input_item
	#if item["Type"] == "material":
		#%Symbol.text = item["Symbol"]
	#elif item["Type"] == "rune":
		#texture = load("res://Textures/" + item["Name"] + ".png")
	
func _get_drag_data(_at_position):
	if item.size() > 0:
		#check if the aux slots have an item. 
		#if so. cant drag base item
		if slot_type == "base":
			var children = rune_container.get_children()
			children.remove_at(0)
			
			for child in children:
				if child.item:
					return
			
		#the preview to display the item
		var slot_preview
		
		#store all of the data to trasfer it to another slot.
		var data: Dictionary = {}
		data["origin"] = self
		data["item"] = item
		
		
		if slot_type == "base" or "aux":
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

func _can_drop_data(_at_position, data):
	var target = get_node(".")
	var target_symbol = get_node("Symbol")

	if slot_type == "base" and data["item"]["Type"] == "rune" and !target.texture:
		return true
	elif slot_type == "aux" and data["item"]["Type"] == "rune" and !target.texture:
		return true
	elif slot_type == "material" and data["item"]["Type"] == "material" and !target_symbol.text:
		return true
	
func _drop_data(_at_position, data):
	if data["item"]["Type"] == "material":
		#set the item
		item = data["item"]
		#remove the origin item
		#data["origin"].item = {}
		#set the symbol to show
		%Symbol.text = item["Symbol"]
		#remove the orign symbol
		#data["origin"].get_node("Symbol").text = ""
		
	else:
		#set the item
		item = data["item"]
		#remove the origin item
		#data["origin"].item = {}
		#set the texture
		texture = data["texture"]
		#remove origin texture
		#data["origin"].texture = null
		
	#emit the draw signal to draw the shape held within the slot
	draw_shape.emit(self, item)

