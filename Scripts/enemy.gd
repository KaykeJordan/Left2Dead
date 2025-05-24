extends CharacterBody2D

@onready var player_reference = $"../Player"
var direction : Vector2
var speed : float = 70
var damage : float
var BloodEffect = preload("res://Scanes/blood_effect.tscn")

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
#@export var target_to_chase: CharacterBody2D

@export var health : float = 100:
	set(value):
		health = value
	

var type : Enemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage

func _physics_process(_delta: float) -> void:
	if player_reference == null:
		return
	
	if player_reference:
		navigation_agent.target_position = player_reference.global_position

	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	
	#velocity = (player_reference.position - position).normalized() * speed
	move_and_slide()
	$AnimatedSprite2D.look_at(player_reference.global_position)

func _ready():
	
	pass

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Zumbi (", name, ") morreu!")
	Global.zombie_count += 1
	print(str(Global.zombie_count) + "/" + str(Global.zombie_target))
	var blood = BloodEffect.instantiate()
	blood.global_position = global_position
	get_tree().current_scene.add_child(blood)
	
	# === MUDEI A FUNÇÃO!
	var spawners_in_scene = get_tree().get_nodes_in_group("game_spawners")
	if not spawners_in_scene.is_empty():
	
		var main_spawner = spawners_in_scene[0] 
		if main_spawner.has_method("on_enemy_died"):
			main_spawner.on_enemy_died()
	# =========================================

	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		take_damage(25) # Dano que a bala causa
		area.queue_free()
