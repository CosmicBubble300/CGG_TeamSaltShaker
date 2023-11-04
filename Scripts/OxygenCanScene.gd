extends Node2D

### SIGNALS ###
signal O2_updated

### VARIABLES ###
var can_carry = false 

func _on_InArea_body_entered(body):
	if can_carry == true:
		# Signals O2 to update 
		emit_signal("O2_updated")
		# Hides oxygen canister 
		hide()
	else:
		pass

# Prevents a character from picking up more oxygen tanks 
func _on_Character_maxed_tanks():
	can_carry = false

# Allows a character to pick up more oxygen tanks 
func _on_Character_can_carry():
	can_carry = true
