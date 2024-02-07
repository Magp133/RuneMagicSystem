extends Control

@onready var rune_draw_space = %RuneDrawSpace
@onready var rune_container = $HBoxContainer/RuneContainer
@onready var material_container = $HBoxContainer/MaterialContainer
@export var crafting_slot: PackedScene
@onready var spacer = $HBoxContainer/MaterialContainer/Spacer

#rune parameters
@onready var shape_names: Dictionary = {}
@onready var material_names: Dictionary = {}
@onready var base_position: Vector2 = Vector2(rune_draw_space.size.x / 2, rune_draw_space.size.y / 2)
@onready var base_craft_slot = %BaseCraftSlot

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
	base_craft_slot.slot_type = "base"
	base_craft_slot.grid_position = -1
	base_craft_slot.draw_shape.connect(handle_craft_slots)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()


"""
Drawing Logic
"""
func _draw():
	count_shapes()
	
	if shape_names.size() > 0:
		var colour = Color("Black")
		var triangles: int = 0
		var squares: int = 0
		var pentagons: int = 0
	
		for key in shape_names:
			if key.slot_type == "base":
				if shape_names[key]["Name"] == "Circle":
					draw_rune_circle("base", colour)
				elif shape_names[key]["Name"] == "Triangle":
					draw_triangle("base", start_angle + triangle_angle, colour)
				elif shape_names[key]["Name"] == "Square":
					draw_square("base", start_angle + square_angle, colour)
				elif shape_names[key]["Name"] == "Pentagon":
					draw_pentagon("base", start_angle + pentagon_angle, colour)
			else:
				if shape_names[key]["Name"] == "Circle":
					if shape_names[key].has("Material"):
						draw_rune_circle("aux", shape_names[key]["Material"]["Colour"])
					else:
						draw_rune_circle("aux", colour)
						
				elif shape_names[key]["Name"] == "Triangle":
					draw_triangle("base", start_angle + (triangle_angle * triangles / number_of_triangles), shape_names[key]["Material"]["Colour"])
					triangles += 1
				elif shape_names[key]["Name"] == "Square":
					draw_square("base", start_angle + (square_angle * squares / number_of_squares), shape_names[key]["Material"]["Colour"])
					squares += 1
				elif shape_names[key]["Name"] == "Pentagon":
					draw_pentagon("base", start_angle + (pentagon_angle * pentagons / number_of_pentagons), shape_names[key]["Material"]["Colour"])
					pentagons += 1

"""Draw a circle taking the rune type and changing the colour and size"""
func draw_rune_circle(rune_type: String, colour: Color):
	if rune_type == "base":
		draw_arc(base_position, base_rune_size, 0, TAU, number_of_points, colour, base_rune_width)
	else:
		draw_arc(base_position, aux_rune_size, 0, TAU, number_of_points, colour, aux_rune_width)
		

func draw_triangle(rune_type: String, angle: float, colour: Color):
	# draws a triangle from a start angle 
	#triangle points used in the draw_polyline method
	var triangle_points: PackedVector2Array = []
	#appended to triangle points once it has being calculated
	var points: Vector2
	
	#determine the size of the rune by slot type
	var rune_width
	var rune_size

	if rune_type == "base":
		rune_width = base_rune_width
		rune_size = base_rune_size
	else:
		rune_width = aux_rune_width
		rune_size = aux_rune_size
	
	#iterate over 3 to generate the points.
	for i in range(4):
		points = Vector2.from_angle(angle + i * triangle_angle) * rune_size + base_position
		triangle_points.append(points)
	
	draw_polyline(triangle_points, colour, rune_width, true)
	
func draw_square(rune_type: String, angle: float, colour: Color):
	#draws a square from the start angle
	var square_points: PackedVector2Array = []
	var points: Vector2
	#determine the size of the rune by slot type
	var rune_width
	var rune_size

	if rune_type == "base":
		rune_width = base_rune_width
		rune_size = base_rune_size
	else:
		rune_width = aux_rune_width
		rune_size = aux_rune_size
	
	for i in range(5):
		points = Vector2.from_angle(angle + i * square_angle) * rune_size + base_position
		square_points.append(points)
		
	draw_polyline(square_points, colour, rune_width, true)

func draw_pentagon(rune_type: String, angle: float, colour: Color):
	#draws a square from the start angle
	var pentagon_points: PackedVector2Array = []
	var points: Vector2
	#determine the size of the rune by slot type
	var rune_width
	var rune_size
	if rune_type == "base":
		rune_width = base_rune_width
		rune_size = base_rune_size
	else:
		rune_width = aux_rune_width
		rune_size = aux_rune_size
	
	for i in range(6):
		points = Vector2.from_angle(angle + i * pentagon_angle) * rune_size + base_position
		pentagon_points.append(points)
		
	draw_polyline(pentagon_points, colour, rune_width, true)

"""
Craft slot logic
"""

func handle_craft_slots(craft_slot, item: Dictionary):
	#connects to the crafting_slots
	#moves new item to the front
	
	if item["Type"] == "rune":

		shape_names[craft_slot] = item
		#check if craft_slot is a base
		#if so add more slots
		if craft_slot.slot_type == "base":
			add_craft_slots()
			
	if item["Type"] == "material":
		for key in shape_names:
			if key.grid_position == craft_slot.grid_position:
				shape_names[key]["Material"] = item
				material_names[craft_slot] = item
				material_names[craft_slot]["Rune"] = key
	
	
	
func remove_shape(craft_slot):
	#connects to the material and rune slots
	#removes the key: item where craft_slot is the key
	shape_names.erase(craft_slot)
	material_names.erase(craft_slot)

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
		

func count_shapes():
	number_of_circles = 0
	number_of_squares = 0
	number_of_triangles = 0
	number_of_pentagons = 0
	
	for shape in shape_names:
		if shape_names[shape]["Name"] == "Circle":
			number_of_circles += 1
		
		if shape_names[shape]["Name"] == "Triangle":
			number_of_triangles += 1

		if shape_names[shape]["Name"] == "Square":
			number_of_squares += 1

		if shape_names[shape]["Name"] == "Pentagon":
			number_of_pentagons += 1


