extends CharacterBody2D
class_name Player

@export var spell_scene: PackedScene
var spells: Dictionary = {}

#need to have player stats to change attributes of spells and movement etc.

const SPEED = 300.01



func _physics_process(_delta):
	var keys = spells.keys()
	
	
	for key in keys:
		if Input.is_action_just_pressed(key):
			var new_spell = spell_scene.instantiate()
			new_spell.spell_data = spells[key]
			if spells[key]["Base"] == "Triangle":
				new_spell.direction = global_position.direction_to(get_global_mouse_position())
				new_spell.look_at(get_global_mouse_position())
			else:
				new_spell.position = get_global_mouse_position()
			
			
			get_parent().add_child(new_spell)
	
	velocity = Vector2.ZERO
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
		
	if direction.x > 0:
		$Sprite2D.flip_h = true
	
	if direction.x < 0:
		$Sprite2D.flip_h = false

	if velocity == Vector2.ZERO:
		$PlayerAnimation.play("idle")
	else:
		$PlayerAnimation.play("walk")

	move_and_slide()
