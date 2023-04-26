extends CharacterBody3D


const JUMP_VELOCITY = 20
const ROTATION_SPEED = 0.05

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 10
var fistToggle = 0
var isAttacking = false
var health = 100


func _ready():
	health = 100
	$head/Gooch_Left_Hand/AnimationPlayer.play_backwards("Left Hand Fist")
	$head/Gooch_Spatula_Hand/AnimationPlayer.play_backwards("Spatula Hit")
	$head/Gooch_Spatula_Hand/AnimationPlayer.seek(0)
	$head/Gooch_Spatula_Hand/AnimationPlayer.set_speed_scale(2)
	set_meta("is_player", true)	
	get_parent().get_node("HUD").get_node("Health").text = str("Health: " + str(health))

func _unhandled_input(event):
	# Mouse Controls
	if event is InputEventMouseMotion:
		#Horizontal Rotation
		rotate_y(ROTATION_SPEED * -event.relative.x / 10)
		
		#Vertical Rotation
		var rotation_amount = ROTATION_SPEED * -event.relative.y / 10
	
		# Don't let head rotate vertically outside of -90 and 90 degrees
		if($head.rotation_degrees.x < 90):
			$head.rotate_x(rotation_amount)
		else:
			$head.rotation_degrees.x = 89.9
		
		if($head.rotation_degrees.x > -90):
			$head.rotate_x(rotation_amount)
		else:
			$head.rotation_degrees.x = -89.9


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint
	if Input.is_action_pressed("sprint"):
		speed = 40
		$Gooch_Legs/AnimationPlayer.speed_scale = 6
	else:
		speed = 20
		$Gooch_Legs/AnimationPlayer.speed_scale = 4
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "fwd", "back")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if(is_on_floor()):
			$Gooch_Legs/AnimationPlayer.play("Run")
			if(fistToggle == 0):
				$head/Gooch_Left_Hand/AnimationPlayer.play("Left Hand Fist")
				fistToggle = 1
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		$Gooch_Legs/AnimationPlayer.stop()
		if(fistToggle == 1):
			$head/Gooch_Left_Hand/AnimationPlayer.play_backwards("Left Hand Fist")
			fistToggle = 0
		if(is_on_floor()):
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	
	#Play Spatula Hit
	if Input.is_action_just_pressed("Attack"):
		if(!$head/Gooch_Spatula_Hand/AnimationPlayer.is_playing()):
			$head/Gooch_Spatula_Hand/AnimationPlayer.play_backwards("Spatula Hit")
		
	if($head/Gooch_Spatula_Hand/AnimationPlayer.is_playing()):
		isAttacking = true
	else:
		isAttacking = false
	
	if(health <= 0):
		get_parent().get_node("HUD").hide()
		get_tree().paused = true
		get_parent().get_node("DeathScreen").show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	move_and_slide()
