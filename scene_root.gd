extends Node3D

@onready var player = $Player

var spawnCounter = 0
var burgerSpawner
var randomNum


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	$NavigationRegion3D/terrain.set_meta("is_player", false)
	burgerSpawner = preload("res://cheeseburger.tscn")
	$HUD.show()
	$DeathScreen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_tree().call_group("burgers", "update_target_location", player.global_transform.origin)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
		
	spawnCounter += 1
	if(spawnCounter > 500):
		spawnCounter = 0
		var burgerInstance = burgerSpawner.instantiate()
		var playerYPos = $Player.position.y
		var playerXPos = $Player.position.x
		var playerZPos = $Player.position.z
		burgerInstance.position = Vector3(playerXPos + randf_range(-50, 50), playerYPos, playerZPos + randf_range(-50, 50))
		$NavigationRegion3D/terrain.add_child(burgerInstance)
