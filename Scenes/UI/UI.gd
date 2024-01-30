extends CanvasLayer

@onready var material_inventory = %MaterialInventory
@onready var inventory_default_2 = %InventoryDefault2
@onready var inventory_default_3 = %InventoryDefault3




func _on_button_pressed():
	material_inventory.visible = !material_inventory.visible

func _on_button_2_pressed():
	inventory_default_2.visible = !inventory_default_2.visible

func _on_button_3_pressed():
	inventory_default_3.visible = !inventory_default_3.visible
