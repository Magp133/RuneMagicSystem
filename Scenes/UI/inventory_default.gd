extends Control

@onready var menu_name = get_name()
@export var material_item_slot: PackedScene
@export var rune_item_slot: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var spell_crafter = get_node("/root/Main/UI/GC/V3/SpellCrafter")
	#set the menu name to decide which cache is used.
	var data: Dictionary
	#item slot that will be determined based on 
	var item_slot
	
	if menu_name == "MaterialInventory":
		data = Database.material_cache
		item_slot = material_item_slot
		
	elif menu_name == "RuneInventory":
		data = Database.rune_base_cache
		item_slot = rune_item_slot
		
	elif menu_name == "SpellInventory":
		data = Database.saved_rune_cache

	if item_slot:
		#input the data into the slot and add as a child to grid_container
		for key in data:
			var new_item_slot = item_slot.instantiate()
			new_item_slot.set_item_data(data[key])
			new_item_slot.remove_shape_from_craft.connect(spell_crafter.remove_shape)
			%SlotContainer.add_child(new_item_slot, true)
	
