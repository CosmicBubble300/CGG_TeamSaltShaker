extends KinematicBody2D

# Defines constants for movement speed 
const CROUCH = 50
const WALK = 125
const RUN = 150

# Defines constants for health and oxygen consumption
const O2MAX = 100
const O2CONSBASE = 1     # rate of O2 consumption while walking
const O2CONSRUN = 3      # rate of O2 consumption while running 

# Variables for health and oxygen consumption 
var alive = true
var O2 = 100                # Max O2
var O2_change = O2CONSBASE  # regular rate of O2 depletion
var overtime = 10


# Signals 
signal game_over    # Player has been killed


# Define Movements Variables 
# How fast a character is going 
var velocity : Vector2 = Vector2()
# What direction a character is looking in 
var direction : Vector2 = Vector2()

# Defines Player Movement 
func read_input():
	# refidines velocity as an empty vector 
	velocity = Vector2()
	
	if Input.is_action_pressed("UP"):
		velocity.y -= 1
		direction = Vector2(0,-1)
		
	if Input.is_action_pressed("DOWN"):
		velocity.y += 1
		direction = Vector2(0, 1)
		
	if Input.is_action_pressed("L"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		
	if Input.is_action_pressed("R"):
		velocity.x += 1
		direction = Vector2(1, 0)
		
	# prevents you moving twice as fast on the diagonals 
	velocity = velocity.normalized()
	
	# Applies walking, running and crouching speed to the character
	if Input.is_action_pressed("SPRINT"):
		# checks for collision and makes movement smooth
		velocity = move_and_slide(velocity * RUN)
		# Increases oxygen consumption while runing 
		O2_change = O2CONSRUN
	elif Input.is_action_pressed("CROUCH"):
		velocity = move_and_slide(velocity * CROUCH)
		# Sets oxygen consumption to normal
		O2_change = O2CONSBASE
	else:
		velocity = move_and_slide(velocity * WALK)
		# Sets oxygen consumption to normal
		O2_change = O2CONSBASE
		
# calls the movement function that defines the player movement
func _physics_process(delta):
	# reads imput around 60 times per second 
	read_input()
	
	

# Recieves signal from timer to decrease Oxygen 
func _on_OxygenTimer_timeout():
	#Decreases the amount of oxygen in the bar as a function of time 
	$OxygenBar.value -= O2_change
	if $OxygenBar.value <= 0:
		overtime -= 1
		if overtime == 0:
			alive = false 

# Allows Character to refill oxygen from oxygen canisters 
func _on_OxygenCanister_O2_updated():
	$OxygenBar.value += 10

