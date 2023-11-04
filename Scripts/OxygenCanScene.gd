extends Node2D

signal O2_updated

func _on_InArea_body_entered(body):
	# Signals O2 to update 
	emit_signal("O2_updated")
	
	# Hides oxygen canister 
	hide()
	pass # Replace with function body.
