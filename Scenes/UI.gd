extends CanvasLayer

@onready var texture_rect_1 = $GridContainer/VBoxContainer/InventoryDefault
@onready var texture_rect_2 = $GridContainer/VBoxContainer2/InventoryDefault2
@onready var texture_rect_3 = $GridContainer/VBoxContainer3/InventoryDefault3


func _on_button_pressed():
	texture_rect_1.visible = !texture_rect_1.visible

func _on_button_2_pressed():
	texture_rect_2.visible = !texture_rect_2.visible

func _on_button_3_pressed():
	texture_rect_3.visible = !texture_rect_3.visible
