extends CharacterBody2D

### SIGNALS ###
signal game_over    # Player has been killed
signal maxed_tanks  # Player can't carry any more tanks 
signal can_carry    # Player can carry more oxygen tanks

### CONSTANTS ###
# Defines constants for movement speed 
const CROUCH = 50
const WALK = 125
const RUN = 150

# Defines constants for health and oxygen consumption
const O2MAX = 100
const O2CONSBASE = 1     # rate of O2 consumption while walking
const O2CONSRUN = 3      # rate of O2 consumption while running 
const TANKMAX = 2        # The maximum numner of O2 tanks you can carry 

### Variables ###
# Variables for health and oxygen consumption 
var alive = true
var O2 = 100                # Max O2
var O2_change = O2CONSBASE  # regular rate of O2 depletion
var overtime = 10           # Amount of time you can live without air 

# Tank Variables 
var tank_spare = 0         # Amount of oxygen tanks the character is carrying 
var tank_full = 100        # How much oxygen is in a full tank

# Define Movements Variables 
# How fast a character is going 
#var velocity : Vector2 = Vector2()
# What direction a character is looking in 
var direction : Vector2 = Vector2()


### MOVEMENT ###
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
		set_velocity(velocity * RUN)
		move_and_slide()
		velocity = velocity
		# Increases oxygen consumption while runing 
		O2_change = O2CONSRUN
	elif Input.is_action_pressed("CROUCH"):
		set_velocity(velocity * CROUCH)
		move_and_slide()
		velocity = velocity
		# Sets oxygen consumption to normal
		O2_change = O2CONSBASE
	else:
		set_velocity(velocity * WALK)
		move_and_slide()
		velocity = velocity
		# Sets oxygen consumption to normal
		O2_change = O2CONSBASE
		
# calls the movement function that defines the player movement
func _physics_process(delta):
	# reads imput around 60 times per second 
	read_input()
	
	
### OXYGEN ###

# Recieves signal from timer to decrease Oxygen 
func _on_OxygenTimer_timeout():
	#Decreases the amount of oxygen in the bar as a function of time 
	$OxygenBar.value -= O2_change
	# Replenishes O2 with spare tank when oxygen is empty
	if $OxygenBar.value <= 0 and tank_spare != 0:
		$OxygenBar.value = tank_full
		# Removes one spare tank
		tank_spare -= 1 
	else:
		# This code gives the player a window while their character suffocates 
		overtime -= O2_change
		# Kills the character when overtime runs out. 
		if overtime == 0:
			alive = false 

# Allows Character to refill oxygen from oxygen canisters 
func _on_OxygenCanister_O2_updated():
	tank_spare += 1 
	print(tank_spare)
	if tank_spare >= TANKMAX:
		# sends signal to oxygen canister to set can_carry to false 
		emit_signal("maxed_tanks")
		print("MAX")
	else:
		# Increases spare tank by one 
		emit_signal("can_carry")

