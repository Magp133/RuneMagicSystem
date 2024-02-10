extends Control

@onready var rune_container = $HB/RuneContainer
@onready var material_container = $HB/MaterialContainer
@export var crafting_slot: PackedScene
@onready var spacer = $HB/MaterialContainer/Spacer
@onready var spell_inventory = get_node("/root/Main/UI/GC/V3/SpellInventory")

#player stuff
@export var player: Player

#rune parameters
@onready var rune_storage: Dictionary = {}
@onready var base_craft_slot = %BaseCraftSlot
@onready var draw_area = %DrawSpace/SVC/SV/Draw

var number_of_circles: int
var number_of_triangles: int
var number_of_squares: int
var number_of_pentagons: int

# Called when the node enters the scene tree for the first time.
func _ready():
	base_craft_slot.slot_type = "base"
	base_craft_slot.grid_position = -1
	base_craft_slot.draw_shape.connect(handle_craft_slots)
	draw_area.rune_storage = rune_storage
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	draw_area.rune_storage = rune_storage
	
	number_of_circles = draw_area.number_of_circles
	number_of_triangles = draw_area.number_of_triangles
	number_of_squares = draw_area.number_of_squares
	number_of_pentagons = draw_area.number_of_pentagons
		
	
	queue_redraw()


"""
################################################################################
Craft slot logic
################################################################################
"""

func handle_craft_slots(craft_slot, item: Dictionary):
	#connects to the crafting_slots
	#moves new item to the front
	var ID = craft_slot.grid_position
	
	if craft_slot.slot_type == "base":
		add_craft_slots()
	
	if rune_storage.has(ID):
		if craft_slot.slot_type == "material":
			rune_storage[ID]["Material"] = [item["Colour"]]
		else:
			rune_storage[ID]["Rune"] = [item["Name"], craft_slot.slot_type]
	else:
		if craft_slot.slot_type == "material":
			rune_storage[ID] = {"Material": [item["Colour"]]}
		else:
			rune_storage[ID] = {"Rune" : [item["Name"], craft_slot.slot_type]}
	
	
func remove_shape(grid_position: int, craft_slot):
	#connects to the material and rune slots
	#removes the key: item where craft_slot is the key

	if craft_slot.slot_type == "base":
		rune_storage = {}
		remove_craft_slots()
	else:
		if rune_storage.has(grid_position):
			if craft_slot.slot_type == "material":
				rune_storage[grid_position].erase("Material")
			else:
				rune_storage[grid_position].erase("Rune")
		
	#count_shapes()
	queue_redraw()
	
func add_craft_slots():
	#have an input rank.
	#add slots equal to the rank
	var rank: int = 5
	for i in range(rank):
		var new_craft_slot = crafting_slot.instantiate()
		new_craft_slot.draw_shape.connect(handle_craft_slots)
		new_craft_slot.slot_type = "aux"
		new_craft_slot.grid_position = i
		rune_container.add_child(new_craft_slot, true)
		
		var new_material_slot = crafting_slot.instantiate()
		new_material_slot.slot_type = "material"
		new_material_slot.grid_position = i
		new_material_slot.draw_shape.connect(handle_craft_slots)
		material_container.add_child(new_material_slot, true)
		
		
func remove_craft_slots():
	#have an input rank
	#remove slots equal to the rank
	#should end up with one slot left as the intit slot
	var craft_children = rune_container.get_children()
	craft_children.erase(base_craft_slot)
	var material_children = material_container.get_children()
	material_children.erase(spacer)
	
	var children = craft_children + material_children
	
	for child in children:
		child.queue_free()
		

"""
################################################################################
Spell Logic
################################################################################
"""

func _on_save_pressed():
	save_spell()

func save_spell():
	if !%SpellName.text:
		%Warning.show()
		return
	
	var spell: Dictionary = {}
	
	if rune_storage.has(-1):
		# Retrieve the captured image.
		await get_tree().process_frame
		var img = %DrawSpace/SVC/SV.get_viewport().get_texture().get_image()
		#img.save_png("test_img.png")
		
		var image_texture = ImageTexture.create_from_image(img)
		
		spell["Texture"] = image_texture
		spell["Name"] = %SpellName.text
		spell["Type"] = "spell"
		spell["Base"] = rune_storage[-1]["Rune"][0]
		
		var shapes: Dictionary = {}
		shapes["Circles"] = number_of_circles
		shapes["Triangles"] = number_of_triangles
		shapes["Squares"] = number_of_squares
		shapes["Pentagons"] = number_of_pentagons
		
		spell["Shapes"] = shapes
		
		Database.saved_rune_cache[spell["Name"]] = spell
		spell_inventory.refresh()
