extends CanvasLayer

@onready var material_inventory = %MaterialInventory
@onready var rune_inventory = %RuneInventory
@onready var spell_crafter = %SpellCrafter
@onready var spell_inventory = %SpellInventory




func _on_button_pressed():
	material_inventory.visible = !material_inventory.visible

func _on_button_2_pressed():
	rune_inventory.visible = !rune_inventory.visible

func _on_button_4_pressed():
	spell_crafter.visible = !spell_crafter.visible


func _on_button_3_pressed():
	spell_inventory.visible = !spell_inventory.visible
