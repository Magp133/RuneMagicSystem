extends Control

@onready var menu_name = get_name()
@onready var grid_container = %GridContainer
#var item_slot = preload("res://Scenes/slot.tscn")
@export var item_slot: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#set the menu name to decide which cache is used.
	var data: Dictionary
	var item_key: String
	if menu_name == "MaterialInventory":
		data = Database.material_cache
		item_key = "material"
	elif menu_name == "RuneInventory":
		data = Database.rune_base_cache
		item_key = "rune"
	elif menu_name == "SigilInventory":
		data = Database.sigil_cache
	else:
		for i in range(5):
			var new_item_slot = item_slot.instantiate()
			grid_container.add_child(new_item_slot)
		return

	#input the data into the slot and add as a child to grid_container
	for key in data:
		var new_item_slot = item_slot.instantiate()
		new_item_slot.set_item_data(data[key], item_key)
		grid_container.add_child(new_item_slot)
