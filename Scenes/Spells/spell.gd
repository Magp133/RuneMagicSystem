extends Node2D
class_name Spell

var spell_data: Dictionary = {}
var spell_type: String

var power: int = 10
var rank: int
var cast_time: float
var spell_range: int
var duration: float
var complexity

var speed: int = 10
var size: int = 40

var direction = Vector2.ZERO


@onready var hitbox_shape = $HitboxComponent/HitboxShape
@onready var effect = $Effect
@onready var life_time = $LifeTime

@export var explosion: ParticleProcessMaterial
@export var burning: ParticleProcessMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	#area base effect
	if spell_data["Base"] == "Circle":
		spell_type = "aoe"
		var new_shape = CircleShape2D.new()
		duration  = 2
		life_time.wait_time = duration
		new_shape.radius = size
		hitbox_shape.shape = new_shape
		effect.process_material = explosion
		effect.set_lifetime(life_time.wait_time)
		effect.explosiveness = 1
	
	if spell_data["Base"] == "Triangle":
		spell_type = "projectile"
		duration  = 4
		life_time.wait_time = duration
		var new_shape = ConvexPolygonShape2D.new()
		var triangle_points: PackedVector2Array = []
		
		var start_point = Vector2.from_angle(0) * size / 2
		var end_point = Vector2.from_angle(TAU / 2) * size / 2
		var mid_point = Vector2.from_angle(-TAU / 4) * size 
		
		#define hitbox of triangle
		triangle_points = [start_point, end_point, mid_point,]
		new_shape.set_point_cloud(triangle_points)
		hitbox_shape.shape = new_shape
		effect.set_lifetime(0.5)
		effect.process_material = burning
		
		
		
func _process(delta):
	if spell_type == "projectile":
		position += (position + direction) * speed * delta

func _on_hitbox_component_area_entered(area):
	var attack = Attack.new()
	attack.damage = power
	attack.attack_position = global_position 
	area.damage(attack)


func _on_life_time_timeout():
	queue_free()
