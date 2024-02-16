class_name CombatWave
extends Node2D

signal wave_started
signal wave_finished

var enemies: Array[CombatEntity] = []


func start():
	visible = true
	for enemy: CombatEntity in enemies:
		add_child(enemy)
		enemy.spawn()
		enemy.killed.connect(_on_enemy_killed.bind(enemy))
	print_debug("Wave Started. Enemies: ", enemies)


func _ready():
	visible = false
	# remove all enemies from the node tree to be added later
	for child in get_children():
		if not child is CombatEntity: continue
		var enemy = child as CombatEntity
		enemies.push_back(enemy)
		remove_child(enemy)


func _on_enemy_killed(enemy:CombatEntity) -> void:
	enemies.erase(enemy)
	if enemy.killed.is_connected(_on_enemy_killed):
		enemy.killed.disconnect(_on_enemy_killed)
	print_debug("Enemy Defeated. Enemies left: ", enemies)
	if enemies.size() == 0:
		print_debug("All enemies defeated in this wave.")
		wave_finished.emit()
