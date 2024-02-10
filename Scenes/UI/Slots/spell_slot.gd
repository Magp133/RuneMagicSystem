class_name SpellSlot
extends TextureRect

var player: Player


#signals
signal remove_shape_from_craft

#gets the parent of the slot.
@onready var parent = get_parent().get_parent().get_parent()
var key: String

#the item that is being stored.
var item: Dictionary = {}

func _process(_delta):
	var event = Input.is_action_just_pressed("right_click")
	var distance: float
	var mouse_position: Vector2 = get_global_mouse_position()
	
	distance = sqrt((global_position.x - mouse_position.x + size.x / 2) ** 2 + (global_position.y - mouse_position.y + size.y / 2) ** 2)
	
	
	if event and distance < 25:
		item = {}
		texture = null
		%Symbol.text = ""
		if get_parent().get_name() == "HotBarContainer":
			player.spells.erase(key)
		
	if key:
		%Symbol.text = key

func set_item_data(input_item: Dictionary):
	#input item is a rune data item
	item = input_item
	texture = input_item["Texture"]
	
func _get_drag_data(_at_position):
	if item.size() > 0:
		#the preview to display the materials symbol
		var slot_preview = TextureRect.new()
		
		#store all of the data to trasfer it to another slot.
		var data: Dictionary = {}
		data["origin"] = self
		data["item"] = item
		
		
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
		if !target.texture and data["item"]["Type"] == "spell":
			return true
	
func _drop_data(_at_position, data):
	#set the item
	item = data["item"]
	#set the texture
	texture = data["item"]["Texture"]
	player.spells[key] = item
	
	
	if data["origin"] is CraftingSlot:
		remove_shape_from_craft.emit(data["origin"])
	


	
	
