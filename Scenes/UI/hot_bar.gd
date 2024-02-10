extends Control

@export var player: Player
@export var spell_slot: PackedScene
@onready var hot_bar_container = $HBoxContainer/PC/HotBarContainer

var keys: Array = ["one", "two", "three", "four", "five"]
# Called when the node enters the scene tree for the first time.
func _ready():
	add_hotbar_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_hotbar_slots():
	for i in range(5):
		var new_hotbar_slot = spell_slot.instantiate()
		new_hotbar_slot.key = keys[i]
		new_hotbar_slot.player = player
		hot_bar_container.add_child(new_hotbar_slot, true)
		
