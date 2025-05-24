extends Control

func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/Play.grab_focus()
	
	pass

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://Scanes/test_scane.tscn")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scanes/test_scane.tscn")


func _on_leave_pressed() -> void:
	get_tree().quit()
