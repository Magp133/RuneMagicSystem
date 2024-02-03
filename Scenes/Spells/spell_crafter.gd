extends Control

@onready var rune_draw_space = %RuneDrawSpace
#rune parameters
@onready var shape_names: Dictionary = {"Base" : null}
@onready var base_position: Vector2 = Vector2(rune_draw_space.size.x / 2, rune_draw_space.size.y / 2)
var base_rune_width: int = 4
var base_rune_size: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	%BaseCraftSlot.slot_type = "base"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()

func _draw():
	if shape_names["Base"] == "Circle":
		draw_arc(base_position, base_rune_size, 0, TAU, 32, Color.RED, base_rune_width)

