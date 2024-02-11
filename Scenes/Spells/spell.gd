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

var speed: int = 500
var size: int = 40

var direction = Vector2.ZERO


@onready var hitbox_shape = $HitboxComponent/HitboxShape
@onready var effect = $Effect
@onready var life_time = $LifeTime

#particles
@export var explosion: ParticleProcessMaterial
@export var burning: ParticleProcessMaterial
@export var line: ParticleProcessMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	
	effect.trail_enabled = false
	
	#area base effect
	if spell_data["Base"] == "Circle":
		"""
		spell type is a stationary aoe that spawns on the cursor
		"""
		spell_type = "aoe"
		var new_shape = CircleShape2D.new()
		duration  = 2
		life_time.wait_time = duration
		new_shape.radius = size
		hitbox_shape.shape = new_shape
		effect.process_material = explosion
		effect.set_lifetime(duration)
		effect.amount = 200
		effect.explosiveness = 1
		
		life_time.start()
	
	if spell_data["Base"] == "Triangle":
		"""
		spell type is a projectile that shoots towards the cursor.
		"""
		
		spell_type = "projectile"
		duration  = 4
		life_time.wait_time = duration
		effect.set_lifetime(0.5)
		effect.amount = 150
		effect.process_material = burning
		
		var new_shape = ConvexPolygonShape2D.new()
		var triangle_points: PackedVector2Array = []
		
		var start_point = Vector2.from_angle(0) * size / 2
		var end_point = Vector2.from_angle(TAU / 2) * size / 2
		var mid_point = Vector2.from_angle(-TAU / 4) * size 
		
		
		#define hitbox of triangle
		triangle_points = [start_point, end_point, mid_point,]
		
		
		new_shape.set_point_cloud(triangle_points)
		hitbox_shape.shape = new_shape

		
		life_time.start()
	
	if spell_data["Base"] == "Square":
		"""
		spell type is a line that spawns from the player towards the mouse
		"""
		spell_type = "line"
		duration = 3
		life_time.wait_time = duration
		effect.trail_enabled = true
		effect.process_material = line
		effect.set_lifetime(duration)
		effect.amount = 50
		
		var new_shape = RectangleShape2D.new()
		new_shape.size.y = 300
		
		
		hitbox_shape.shape = new_shape
		hitbox_shape.position.y = -150
		
		life_time.start()
		
		
		
		
func _process(delta):
	#pass
	if spell_type == "projectile":
		position += direction * speed * delta

func _on_hitbox_component_area_entered(area):
	var attack = Attack.new()
	attack.damage = power
	attack.attack_position = global_position 
	area.damage(attack)
	


func _on_life_time_timeout():
	queue_free()
