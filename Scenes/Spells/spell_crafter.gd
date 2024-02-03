extends Control

@onready var rune_draw_space = %RuneDrawSpace
@onready var rune_container = $HBoxContainer/RuneContainer
@export var crafting_slot: PackedScene

#rune parameters
@onready var shape_names: Dictionary = {}
@onready var base_position: Vector2 = Vector2(rune_draw_space.size.x / 2, rune_draw_space.size.y / 2)
var base_rune_width: int = 4
var base_rune_size: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	%BaseCraftSlot.slot_type = "base"
	%BaseCraftSlot.draw_shape.connect(draw_shape)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _draw():
	for shape in shape_names:
		if shape_names[shape] == "Circle":
			draw_arc(base_position, base_rune_size, 0, TAU, 32, Color.RED, base_rune_width)

func draw_shape(craft_slot, item_name: String):
	#connects to the crafting_slots
	#moves new item to the front
	shape_names[craft_slot] = item_name
	
	#check if craft_slot is a base
	#if so add more slots
	if craft_slot.slot_type == "base":
		add_craft_slots()
	
	queue_redraw()
	
func remove_shape(craft_slot):
	#connects to the material and rune slots
	#removes the key: item where craft_slot is the key
	shape_names.erase(craft_slot)
	
	if craft_slot.slot_type == "base":
		remove_craft_slots()
	queue_redraw()
	
func add_craft_slots():
	#have an input rank.
	#add slots equal to the rank
	var rank: int = 2
	for i in range(rank):
		var new_craft_slot = crafting_slot.instantiate()
		new_craft_slot.draw_shape.connect(draw_shape)
		new_craft_slot.slot_type = "aux"
		rune_container.add_child(new_craft_slot, true)
		
func remove_craft_slots():
	#have an input rank
	#remove slots equal to the rank
	#should end up with one slot left as the intit slot
	var children = rune_container.get_children()
	children.erase(%BaseCraftSlot)
	
	for child in children:
		child.queue_free()


