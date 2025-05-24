extends Node2D

@export var ini_wave = 1

var enemy = preload("res://Scanes/enemy.tscn")

@export var zombie_pool_ini = 11

@onready var zombie_pool = zombie_pool_ini

func _on_timer_timeout() -> void:
	
	
	
	if zombie_pool >= 1 and Global.wave >= ini_wave:
	
		var new_enemy = enemy.instantiate()
		new_enemy.global_position = global_position
		get_tree().current_scene.add_child(new_enemy)
		
		randomize()
		$Timer.wait_time =randf_range(0.5, 2.0)
		
		zombie_pool -= 1
		
		print(zombie_pool)
		print(zombie_pool_ini)
	
	
	pass 


func waves():
	
	if Global.wave >= ini_wave:
		zombie_pool = zombie_pool_ini * 2
		print(zombie_pool)
	
	pass
