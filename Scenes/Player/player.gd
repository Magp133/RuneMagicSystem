extends CharacterBody2D
class_name Player


#need to have player stats to change attributes of spells and movement etc.

const SPEED = 300.0

func _physics_process(_delta):

	
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
