extends Node2D

func _ready():
	$AnimatedSprite2D.play("blood")
	# Espera a animação terminar, depois se remove da cena
	await $AnimatedSprite2D.animation_finished
	queue_free()
