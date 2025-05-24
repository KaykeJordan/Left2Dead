extends Node

var wave = 1

var zombie_target = 11
var zombie_count = 0

func _ready() -> void:
	
	print("MATE " + str(zombie_target) + " PARA A PROXIMA ONDA!")
	
	pass


func _process(delta: float) -> void:
	
	next_wave()
	
	
	
	pass

func next_wave():
	
	if zombie_count >= zombie_target:
		zombie_count = 0
		wave += 1
		zombie_target = zombie_target * 2
		print("PROXIMA ONDA!")
		print("MATE " + str(zombie_target) + "   PARA A PROXIMA ONDA!")
		chamar_funcao_em_nos()
		
		
	pass


func chamar_funcao_em_nos():
	# Obter todos os nós no grupo "meu_grupo"
	var nos_do_grupo = get_tree().get_nodes_in_group("game_spawners")
	# Iterar sobre cada nó e chamar uma função neles
	for no in nos_do_grupo:
		if no is Node:  # Verificar se o nó é do tipo esperado
			no.waves()  # Chama a função "minha_funcao" no nó
