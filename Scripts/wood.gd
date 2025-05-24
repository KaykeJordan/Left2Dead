extends StaticBody2D

var zombie_in = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Zombie"):
		damage()
		
	pass



func damage():
	
	if zombie_in == false:
		$TimerDamage.start()
		zombie_in = true
		print("MADEIRAAAAAAAAAAAAAAAAAAAAAAAAAA")
	pass


func break_wood():
	$Sprite2D.hide()
	$Icon.show()
	$CollisionShape2D.disabled = true
	
	pass

func fix_wood():
	$Sprite2D.show()
	$Icon.hide()
	$CollisionShape2D.disabled = false
	zombie_in = false
	pass


func _on_timer_damage_timeout() -> void:
	
	break_wood()
	
	pass 


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.name == "Player" or body.name == "Player2":
		$TimerFix.start()
		
		
	
	pass


func _on_timer_fix_timeout() -> void:
	fix_wood()
	
	
	pass
