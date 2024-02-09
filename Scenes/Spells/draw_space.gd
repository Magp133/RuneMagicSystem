extends Node2D

@onready var rune_storage: Dictionary = {}
@onready var base_position: Vector2 = Vector2($"..".size.x / 2, $"..".size.y / 2)

var base_rune_width: int = 6
var base_rune_size: int = 100
var secondary_width: int = 4	#for layering runes on top of each other.

#auxillary 
var aux_rune_width: int = 4
var secondary_aux_rune_width: int = 2
var aux_rune_size: int = 100

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	count_shapes()
	queue_redraw()


"""
################################################################################
Drawing Logic
################################################################################
"""
func _draw():
	count_shapes()
	var circles: int = 0
	var triangles: int = 0
	var squares: int = 0
	var pentagons: int = 0
	var circle_radius: int  = base_rune_size 
	var circle_width: int = base_rune_width
	
	for key in rune_storage:
		var colour = Color("Black")
		
		if rune_storage[key].has("Material"):
			colour = Color(rune_storage[key]["Material"][0])

		if rune_storage[key].has("Rune"):
			#circles
			if rune_storage[key]["Rune"][0] == "Circle":
				if circles % 2 == 0:
					circle_radius = circle_radius - circles * 5
					circle_width = aux_rune_width
				else:
					circle_width = secondary_aux_rune_width
				draw_rune_circle(rune_storage[key]["Rune"][1], circle_radius, circle_width, colour)
				circles += 1
			
			#triangles
			elif rune_storage[key]["Rune"][0] == "Triangle":
				draw_triangle(rune_storage[key]["Rune"][1], start_angle + (triangle_angle * triangles / number_of_triangles), colour)
				triangles += 1
			
			#squares
			elif rune_storage[key]["Rune"][0] == "Square":
				draw_square(rune_storage[key]["Rune"][1], start_angle + (square_angle * squares / number_of_squares), colour)
				squares += 1
			
			#pentagons
			elif rune_storage[key]["Rune"][0] == "Pentagon":
				draw_pentagon(rune_storage[key]["Rune"][1], start_angle + (pentagon_angle * pentagons / number_of_pentagons), colour)
				pentagons += 1


"""Draw a circle taking the rune type and changing the colour and size"""
func draw_rune_circle(rune_type: String, radius: int, circle_width: int, colour: Color):
	if rune_type == "base":
		draw_arc(base_position, radius, 0, TAU, number_of_points, colour, base_rune_width)
	else:
		draw_arc(base_position, radius, 0, TAU, number_of_points, colour, circle_width)
		

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
	
func count_shapes():
	number_of_circles = 0
	number_of_squares = 0
	number_of_triangles = 0
	number_of_pentagons = 0
	
	for shape in rune_storage:
		if rune_storage[shape].has("Rune"):
			if rune_storage[shape]["Rune"][0] == "Circle":
				number_of_circles += 1
			
			if rune_storage[shape]["Rune"][0] == "Triangle":
				number_of_triangles += 1

			if rune_storage[shape]["Rune"][0] == "Square":
				number_of_squares += 1

			if rune_storage[shape]["Rune"][0] == "Pentagon":
				number_of_pentagons += 1
