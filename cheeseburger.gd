extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var damageTimeOut = 0
	

func _ready():
	set_meta("is_player", false)
	set_meta("is_burger", true)
	$AnimationPlayer.speed_scale = 4

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	
	velocity = velocity.move_toward(new_velocity, 0.25)
	
	if(not $AnimationPlayer.is_playing()):
		$AnimationPlayer.play("Walk")
		
	move_and_slide()
	
	if(position.y < 0):
		queue_free()
	
func update_target_location(target_location):
	nav_agent.set_target_position(target_location)
	#if(_angleBetween(get_parent().get_parent().get_parent().get_node("Player")) < 25):
	look_at(target_location, Vector3.UP)
	rotate_object_local(Vector3.UP, PI + PI/2)
	
func _angleBetween(node):
	var hypotenuse = global_transform.origin.distance_to(node.global_transform.origin)
	var opposite = node.global_transform.origin.y
	var angle = asin(opposite/hypotenuse)
	return rad_to_deg(angle)

func _death():
	print("bleh")
	queue_free()
	
func _on_navigation_agent_3d_target_reached():
	if get_parent().get_parent().get_parent().get_node("Player").isAttacking:
		_death()
	else:
		damageTimeOut -= 1
		if(damageTimeOut < 0):
			damageTimeOut +=20
			get_parent().get_parent().get_parent().get_node("Player").health -= 5
			get_parent().get_parent().get_parent().get_node("HUD").get_node("Health").text = "Health: " + str(get_parent().get_parent().get_parent().get_node("Player").health)
			#print(get_parent().get_parent().get_parent().get_node("Player").health)
		
