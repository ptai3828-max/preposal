extends Node2D

@onready var player= $Player
@export var powerup_scene := load("res://PowerUp.tscn")
var powerup_timer := 0

@onready var health_container = $UI/HealthContainer  # adjust path if needed
@export var player_icon := preload("res://images/player.png")

func update_health_ui():
	health_container.clear()

	for i in range(player.health):
		var icon = TextureRect.new()
		icon.texture = player_icon
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		health_container.add_child(icon)

# 1. load the scene
var meteor_scene: PackedScene = load("res://scene/meteor.tscn")
var laser_scene: PackedScene = load("res://scene/laser.tscn")

var health: int = 3

func _ready():
	# Set up health ui
	get_tree().call_group( 'ui', 'set_health', health)

func _on_meteor_timer_timeout() -> void:
	# 2. create an instance
	var meteor = meteor_scene.instantiate()
	
	# 3. attach the node to the scene tree
	$Meteors.add_child(meteor) 
	
	#connect the signal
	meteor.connect('collision', _on_meteor_collision)
	
func _on_meteor_collision():
	health -= 1
	get_tree().call_group( 'ui', 'set_health', health)
	if health <= 0: 
		get_tree().change_scene_to_file("res://scene/game_over.tscn")
	
	
func _on_player_laser(pos) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
	print(pos)

@export var PowerupScene: PackedScene

func spawn_powerup():
	var powerup = powerup_scene.instantiate()
	add_child(powerup)
	# random position
	var screen_size = get_viewport_rect().size
	var margin := 32  # half size of your sprite
	powerup.position = Vector2(
	randf_range(margin, screen_size.x - margin),
	randf_range(margin, screen_size.y - margin)
)
func _on_powerup_timer_timeout() -> void:
	spawn_powerup()

	#powerup.position = Vector2(randi_range(100, screen_size.x - 100), -50)


	
