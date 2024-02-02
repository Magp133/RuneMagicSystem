extends Node2D
class_name HealthComponent

@export var max_health: int
var health: int

func _ready():
	health = max_health

func damage(attack: Attack):
	health -= attack.damage
	
	if health <= 0:
		get_parent().queue_free()