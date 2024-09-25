extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -1000.0

@onready var ANIM : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var anim_ended := true

func anim_end():
	anim_ended = true 

func _process(delta):
	if is_on_floor():
		if ANIM.animation == "falling":
			ANIM.play("landing")
			anim_ended = false
		if (ANIM.animation == "landing" and anim_ended == true) or not ANIM.animation == "landing":
			if velocity.x == 0:
				ANIM.play("idling")
			else:
				ANIM.play("running")
	else: 
		if velocity.y < JUMP_VELOCITY * 0.1 and not ANIM.animation == "jumping":
			ANIM.play("jumping")
		elif velocity.y > JUMP_VELOCITY * 0.1 and velocity.y < -JUMP_VELOCITY * 0.1 and not ANIM.animation == "floating":
			ANIM.play("floating")
		elif velocity.y > - JUMP_VELOCITY * 0.1 and not ANIM.animation == "falling":
			ANIM.play("falling")
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > JUMP_VELOCITY * 0.1 and velocity.y < -JUMP_VELOCITY * 0.1:
			velocity.y += gravity * delta * 0.6
		else:
			velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			ANIM.flip_h = true
		else: 
			ANIM.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
