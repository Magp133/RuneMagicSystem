extends TextureRect

var item = null
@onready var parent = get_parent().get_parent().get_parent()

#stores the type of the slot and if its used for crafting.
var slot_type: String

func _ready():
	if parent.get_name() == "SpellCrafter":
		slot_type = "craft"
		%Type.text = "Base Rune"
		%Type.size = Vector2(20,20)

func _process(_delta):
	if slot_type == "craft":
		if item:
			if item["Type"] == "rune":
				parent.shape_names["Base"] = item["Name"]
				#self.hide()
		else:
			parent.shape_names["Base"] = null

func set_item_data(input_item: Dictionary, key: String):
	"""Take a dictionary database of an item that is being stored within the slot.
	   The item being stored is of different types; material or a rune."""
	item = input_item
	if key == "material":
		%Symbol.text = item["Symbol"]
	if key == "rune":
		var rune_texture = TextureRect.new()
		rune_texture.texture = load("res://Textures/" + item["Name"] + ".png")
		texture = rune_texture.texture

func _get_drag_data(_at_position):
	#get preview of texture to see it while dragging.
	var texture_preview = TextureRect.new()
	
	
	var data_dict: Dictionary = {}	
	data_dict["symbol_origin"] = %Symbol
	data_dict["origin"] = self
	data_dict["item"] = item
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
		if !target_label.text and !target.texture:
			return true
		else:
			return false
	else:
		return false

func _drop_data(_at_position, data):
	
	%Symbol.text = data["text"]
	data["origin"].texture = texture
	texture = data["texture"]
	data["symbol_origin"].text = ""
	item = data["item"]
	data["origin"].item = null
