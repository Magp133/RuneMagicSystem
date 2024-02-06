extends Control

@onready var rune_draw_space = %RuneDrawSpace
@onready var rune_container = $HBoxContainer/RuneContainer
@onready var material_container = $HBoxContainer/MaterialContainer
@export var crafting_slot: PackedScene
@onready var spacer = $HBoxContainer/MaterialContainer/Spacer

#rune parameters
@onready var shape_names: Dictionary = {}
@onready var material_names: Array = []
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
	base_craft_slot.draw_shape.connect(handle_craft_slots)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()


"""
Drawing Logic
"""
func _draw():
	count_shapes()
	if base_craft_slot.item.size() > 0:
		#draw the base shape
		var keys = shape_names.keys()
		var base_rune = keys[0]
		var base
		var colour: Color = Color("Black")
		
		#assign the base 
		if shape_names[base_rune][0] == "Circle":
			base = "circle"
			draw_rune_circle("base", colour)

		if shape_names[base_rune][0] == "Triangle":
			base = "triangle"
			draw_triangle("base", start_angle, colour)

		if shape_names[base_rune][0] == "Square":
			base = "square"
			draw_square("base", start_angle, colour)
			
		if shape_names[base_rune][0] == "Pentagon":
			base = "pentagon"
			draw_pentagon("base", start_angle, colour)
		
		
		#draw the auxillary shapes
		for i in range(number_of_circles):
			colour = Color("Black")
			if base == "circle":
				base = ""
			else:
				if material_names.size() > 0 and material_names.size() >= 1:
					colour = Color(material_names[i - 1]["Colour"])
				draw_rune_circle("aux", colour)
			
			
		for i in range(number_of_triangles):
			colour = Color("Black")
			if base == "triangle":
				base = ""
			else:
				if material_names.size() > 0 and material_names.size() >= 1:
					colour = Color(material_names[i - 1]["Colour"])
				draw_triangle("aux", start_angle + (triangle_angle * i / number_of_triangles), colour)
			

		for i in range(number_of_squares):
			colour = Color("Black")
			if base == "square":
				base = ""
			else:
				if material_names.size() > 0 and material_names.size() >= 1:
					colour = Color(material_names[i - 1]["Colour"])
				draw_square("aux", start_angle + (square_angle * i / number_of_squares), colour)
			

		for i in range(number_of_pentagons):
			colour = Color("Black")
			if base == "pentagon":
				base = ""
			else:
				if material_names.size() > 0 and material_names.size() >= 1:
					colour = Color(material_names[i - 1]["Colour"])
				draw_pentagon("aux", start_angle + (pentagon_angle * i / number_of_pentagons), colour)
			


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

		shape_names[craft_slot] = [item["Name"], craft_slot.slot_type]
		#check if craft_slot is a base
		#if so add more slots
		if craft_slot.slot_type == "base":
			add_craft_slots()
			
	if item["Type"] == "material":

		material_names.append(item)
	

	
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
		rune_container.add_child(new_craft_slot, true)
		
		var new_material_slot = crafting_slot.instantiate()
		new_material_slot.slot_type = "material"
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
		if shape_names[shape][0] == "Circle":
			number_of_circles += 1
		
		if shape_names[shape][0] == "Triangle":
			number_of_triangles += 1

		if shape_names[shape][0] == "Square":
			number_of_squares += 1

		if shape_names[shape][0] == "Pentagon":
			number_of_pentagons += 1

