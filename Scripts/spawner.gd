extends Node2D

@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var enemy_types : Array[Enemy]

@onready var spawn_points_container: Node = $SpawnPoints
var spawn_points_list: Array[Node2D]
var current_enemies := 0
var minute : int:
	set(value):
		minute = value
		if is_instance_valid(%Minute):
			%Minute.text = str(value)

var second : int:
	set(value):   
		second = value
		if second >= 10:
			second -= 10
			minute += 1
		if is_instance_valid(%Second):
			%Second.text = str(value).lpad(2, '0')

var kill_count_current_wave := 0
var wave_number := 1
var enemies_to_kill_for_next_wave := 10

var base_enemies_per_wave := 5
var enemies_increase_per_wave := 2
var current_wave_enemies_to_spawn := 0

var base_enemy_health := 100
var health_increase_per_wave := 20

var is_waiting_for_next_wave := false

func _ready():
	add_to_group("game_spawners")
	if spawn_points_container != null:
		for child in spawn_points_container.get_children():
			if child is Node2D:
				spawn_points_list.append(child)
			else:
				push_warning(str("ALGO DEU ERRADO", spawn_points_container.get_path(), "'."))
		
		if spawn_points_list.is_empty():
			push_error(str("ERRO"))
	else:
		push_error("ERRO NO SPAWN")
	
	start_new_wave()


func spawn(pos : Vector2):
	var max_active_enemies = 20 + (wave_number * 5)
	if current_enemies >= max_active_enemies:
		return
	
	var enemy_instance = enemy.instantiate()
	enemy_instance.type = enemy_types[min(minute, enemy_types.size() - 1)]
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	enemy_instance.health = base_enemy_health + (health_increase_per_wave * (wave_number - 1))
	
	get_tree().current_scene.add_child.call_deferred(enemy_instance)
	current_enemies += 1

func get_random_position() -> Vector2:
	if spawn_points_list.is_empty():
		return player.position
	var random_point = spawn_points_list[randi() % spawn_points_list.size()]
	return random_point.global_position


func on_enemy_died():
	current_enemies -= 1
	kill_count_current_wave += 1

	if kill_count_current_wave >= enemies_to_kill_for_next_wave and not is_waiting_for_next_wave:
		is_waiting_for_next_wave = true
		print("--- PROXIMA ONDA VAI COMEÇAR... ---")
		
		await get_tree().create_timer(5.0).timeout
		
		start_new_wave()
		is_waiting_for_next_wave = false

func start_new_wave():
	wave_number += 1
	kill_count_current_wave = 0

	current_wave_enemies_to_spawn = base_enemies_per_wave + (enemies_increase_per_wave * (wave_number - 1))
	enemies_to_kill_for_next_wave = int(base_enemies_per_wave + (enemies_increase_per_wave * wave_number) * 1.5)

	print("\n--- INICIANDO ONDA ", wave_number, " ---")
	print("Zumbis Nascendo!!!: ", current_wave_enemies_to_spawn)
	print("A VIDA FOI DOBRADA  HAHAHA! PARA: ", base_enemy_health + (health_increase_per_wave * (wave_number - 1)))
	print("Próxima onda em: ", enemies_to_kill_for_next_wave, " abates.")

	var spawned_count := 0
	while spawned_count < current_wave_enemies_to_spawn:
		var spawn_position = get_random_position()
		spawn(spawn_position)
		await get_tree().create_timer(0.2).timeout
		spawned_count += 1
		
		

func _on_timer_timeout() -> void:
	second += 1

func _on_pattern_timeout() -> void:
	pass

func _on_elite_timeout() -> void:
	pass
