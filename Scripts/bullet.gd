extends Area2D

var direction: Vector2
const speed = 400

var dir

func _ready():
	dir = transform.x
	#rotation = direction.angle()  # Alinha visualmente a bala

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
