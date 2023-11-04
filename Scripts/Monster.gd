extends CharacterBody2D

### SIGNALS ###


## Animation ##
#func _ready():
#	var frames = $RigidBody2D/AnimatedSprite2D.sprite_frames.get_animation_named()
	

### CONSTANTS ###
# Defines constants for movement speed 
const regspeed = 120
const run = 145



### Variables ###


# Define Movements Variables 
var mcpos
var targetpos
@onready var mc = get_parent().get_node("Character")

### MOVEMENT ###



### OXYGEN ###



