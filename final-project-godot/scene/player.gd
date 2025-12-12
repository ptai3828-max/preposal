extends CharacterBody2D

@export var speed := 500
var can_shoot: bool = true
var level

signal laser(pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(100,500)
	level = get_tree().get_first_node_in_group("level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):          
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed 
	move_and_slide()
	
	# Speed boost timer
	if boost_timer > 0:
		boost_timer -= _delta
	if boost_timer <= 0:
		boosted_speed = 0
		print("Speed boost ended")

# Invincibility timer
	if invincible_timer > 0:
		invincible_timer -= _delta
	if invincible_timer <= 0:
		invincible = false
		print("Invincibility ended")

	
	# shoot input
	if Input.is_action_pressed("shoot") and can_shoot:
		laser.emit($LaserStartPos.global_position)
		can_shoot = false
		$LaserTimer.start()
		$Lasersound.play()
		
func _on_laser_timer_timeout() -> void:
	can_shoot = true
		
		

@export var health := 3
@export var max_health := 3

@export var normal_speed := 500
@export var boosted_speed := 1000
@export var boost_timer := 3


var invincible := false
var invincible_timer := 0

func apply_speed_boost():
	speed = boosted_speed
	reset_speed_after_delay()
	
func reset_speed_after_delay():
	await get_tree().create_timer(boost_timer).timeout
	speed = normal_speed

func apply_powerup(type):
	print("POWERUP ACTIVATED:",type)
	match type:
		0:  # healing
			if health < max_health:
				health += 1
			print("Healed! HP =", health)

		1:  # speed boost
			boosted_speed = 1000   # extra speed
			boost_timer = 3       # lasts 4 seconds
			print("Speed Boost!")

		2:  # invincible
			invincible = true
			invincible_timer = 5   # lasts 3 seconds
			print("Invincible!")

func take_damage(amount):
	if invincible:
		return  # ignore damage

	health -= amount
	print("Health:", health)

	if health <= 0:
		queue_free()
		
func add_health(amount):
	health = min(health + amount, max_health)
	print("HEALTH:", health)		
	level.update_health_ui()


'''print(direction)
	if Input.is_action_pressed("ui_down"):
		position += Vector2(1,0) * 50 * delta
		get_node("PlayerImage").rotation += 0.1 * delta
	#Shortcut: $PlayerImage.rotation += 0.1 * delta'''
	
