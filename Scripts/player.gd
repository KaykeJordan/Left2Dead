extends CharacterBody2D


var bullet_scene = preload("res://Scanes/bullet.tscn")
var cooldown = true
var aim_input = Vector2()
var bullets_in_mag : int = 25
var mags : int = 3  # Total de pentes seu burro

const MAX_BULLETS_PER_MAG = 25


@export var shoot_point: Node2D


@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_up = "move_up"
@export var move_down = "move_down"

@export var look_left = "look_left"
@export var look_right = "look_right"
@export var look_up = "look_up"
@export var look_down = "look_down"
@export var shoot = "shoot"
@export var reload = "reload"

var speed : float = 150
var health : float = 100:
	set(value):
		health = value
		%Health.value = value

func _physics_process(delta: float) -> void:
	
	
	
	velocity = Input.get_vector(move_left, move_right, move_up, move_down) * speed
	move_and_collide(velocity * delta)
	

	
	
	# AQUI TA LENDO O VETOR DO CONWTROLO/ ANALOGICO
	aim_input = Vector2(Input.get_action_strength(look_right) - Input.get_action_strength(look_left),Input.get_action_strength(look_down) - Input.get_action_strength(look_up))
	  
	if aim_input.length() > 0.1:
		rotation = aim_input.angle()
	
	
	if Input.is_action_pressed(shoot) and cooldown == true:
		if Input.is_action_just_pressed(shoot):
			print("Tiro!")
		shooting()
	
	if Input.is_action_just_pressed(reload):
		reloading()


	
func _ready():
	pass


func shooting():
	if bullets_in_mag <= 0:
		print("Sem munição!")
		return
	
	#================#
	
	$ShootSound.play()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = shoot_point.global_position
	bullet.rotation = rotation
	cooldown = false
	$Cadencia.start()
	get_tree().current_scene.add_child(bullet)


func reloading():
	if mags > 0 and bullets_in_mag < MAX_BULLETS_PER_MAG:
		mags -= 1
		bullets_in_mag = MAX_BULLETS_PER_MAG

func take_damage(amount):
	health -= amount
	print(amount)
	if health <= 0:
		await get_tree().create_timer(0.2).timeout
		get_tree().call_deferred("reload_current_scene")

func _on_self_damage_area_entered(area: Area2D) -> void:
	
	
	
	if area.is_in_group("Zombie"):
		take_damage(50)
	
	pass # Replace with function body.


func _on_cadencia_timeout() -> void:
	cooldown = true
	
	
	pass # Replace with function body.
