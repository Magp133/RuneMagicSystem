extends Node2D

var power
var rank
var cast_time
var range
var duration
var complexity

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_shape = CircleShape2D.new()
	new_shape.radius = 20
	$HitboxComponent/CollisionShape2D.shape = new_shape


func _on_hitbox_component_area_entered(area):
	var attack = Attack.new()
	attack.damage = power
	attack.attack_position = global_position
	area.damage(attack)
	print("bam")
