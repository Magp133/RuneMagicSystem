extends Control

@onready var rune_draw_space = %RuneDrawSpace
@onready var rune_container = $HBoxContainer/RuneContainer
@export var crafting_slot: PackedScene

#rune parameters
@onready var shape_names: Dictionary = {}
@onready var base_position: Vector2 = Vector2(rune_draw_space.size.x / 2, rune_draw_space.size.y / 2)

# sizes
#base
var base_rune_width: int = 6
var base_rune_size: int = 100
var secondary_width: int = 3	#for layering runes on top of each other.

#auxillary 
var aux_rune_width: int = 2
var aux_rune_size: int = 100
var aux_secondary_width: int = 2

var start_angle: float = -TAU / 4

#shape specific
#circle
var number_of_points: int = 64
var number_of_circles: int = 0
#triangle
var triangle_angle = TAU / 3
var number_of_triangles: int = 0
#square
var square_angle = TAU / 4
var number_of_squares: int = 0
#pentagon
var pentagon_angle = TAU / 5
var number_of_pentagons: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	%BaseCraftSlot.slot_type = "base"
	%BaseCraftSlot.draw_shape.connect(handle_craft_slots)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(number_of_triangles)
	queue_redraw()


"""
Drawing Logic
"""
func _draw():
	for shape in shape_names:
		if shape_names[shape][0] == "Circle":
			if shape_names[shape][1] == "base":
				draw_arc(base_position, base_rune_size, 0, TAU, number_of_points, Color.BLACK, base_rune_width)
			else:
				draw_arc(base_position, aux_rune_size, 0, TAU, number_of_points, Color.GOLD, aux_rune_width)
				
		if shape_names[shape][0] == "Triangle":
			draw_triangle(shape_names[shape][1])
			
		if shape_names[shape][0] == "Square":
			draw_square(shape_names[shape][1])
		
		if shape_names[shape][0] == "Pentagon":
			draw_pentagon(shape_names[shape][1])

func draw_triangle(rune_type: String):
	# draws a triangle from a start angle 
	#triangle points used in the draw_polyline method
	var triangle_points: PackedVector2Array = []
	#appended to triangle points once it has being calculated
	var points: Vector2
	
	#determine the size of the rune by slot type
	var rune_width
	var rune_size
	var colour
	if rune_type == "base":
		rune_width = base_rune_width
		rune_size = base_rune_size
		colour = Color.BLACK
	else:
		rune_width = aux_rune_width
		rune_size = aux_rune_size
		colour = Color.GOLD
	
	#iterate over 3 to generate the points.
	for i in range(4):
		points = Vector2.from_angle(start_angle + i * triangle_angle) * rune_size + base_position
		triangle_points.append(points)
	
	draw_polyline(triangle_points, colour, rune_width, true)
	
func draw_square(rune_type: String):
	#draws a square from the start angle
	var square_points: PackedVector2Array = []
	var points: Vector2
	#determine the size of the rune by slot type
	var rune_width
	var rune_size
	var colour
	if rune_type == "base":
		rune_width = base_rune_width
		rune_size = base_rune_size
		colour = Color.BLACK
	else:
		rune_width = aux_rune_width
		rune_size = aux_rune_size
		colour = Color.GOLD
	
	for i in range(5):
		points = Vector2.from_angle(start_angle + i * square_angle) * rune_size + base_position
		square_points.append(points)
		
	draw_polyline(square_points, colour, rune_width, true)

func draw_pentagon(rune_type: String):
	#draws a square from the start angle
	var pentagon_points: PackedVector2Array = []
	var points: Vector2
	#determine the size of the rune by slot type
	var rune_width
	var rune_size
	var colour
	if rune_type == "base":
		rune_width = base_rune_width
		rune_size = base_rune_size
		colour = Color.BLACK
	else:
		rune_width = aux_rune_width
		rune_size = aux_rune_size
		colour = Color.GOLD
	
	for i in range(6):
		points = Vector2.from_angle(start_angle + i * pentagon_angle) * rune_size + base_position
		pentagon_points.append(points)
		
	draw_polyline(pentagon_points, colour, rune_width, true)

"""
Craft slot logic
"""

func handle_craft_slots(craft_slot, item_name: String):
	#connects to the crafting_slots
	#moves new item to the front
	shape_names[craft_slot] = [item_name, craft_slot.slot_type]
	count_shapes()
	#check if craft_slot is a base
	#if so add more slots
	if craft_slot.slot_type == "base":
		add_craft_slots()

	
func remove_shape(craft_slot):
	#connects to the material and rune slots
	#removes the key: item where craft_slot is the key
	shape_names.erase(craft_slot)
	count_shapes()
	
	if craft_slot.slot_type == "base":
		remove_craft_slots()
	queue_redraw()
	
func add_craft_slots():
	#have an input rank.
	#add slots equal to the rank
	var rank: int = 5
	for i in range(rank):
		var new_craft_slot = crafting_slot.instantiate()
		new_craft_slot.draw_shape.connect(handle_craft_slots)
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

func count_shapes():
	number_of_circles = 0
	number_of_squares = 0
	number_of_triangles = 0
	number_of_pentagons = 0
	
	for shape in shape_names:
		if shape_names[shape][0] == "Circle":
			number_of_circles += 1
		
		if shape_names[shape][0] == "Triangle":
			number_of_triangles += 1

		if shape_names[shape][0] == "Square":
			number_of_squares += 1

		if shape_names[shape][0] == "Pentagon":
			number_of_pentagons += 1

