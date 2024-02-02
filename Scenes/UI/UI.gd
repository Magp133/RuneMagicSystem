extends CanvasLayer

@onready var material_inventory = %MaterialInventory
@onready var rune_inventory = %RuneInventory
@onready var inventory_default_3 = %InventoryDefault3
@onready var spell_crafter = %SpellCrafter




func _on_button_pressed():
	material_inventory.visible = !material_inventory.visible

func _on_button_2_pressed():
	rune_inventory.visible = !rune_inventory.visible

func _on_button_3_pressed():
	inventory_default_3.visible = !inventory_default_3.visible


func _on_button_4_pressed():
	spell_crafter.visible = !spell_crafter.visible