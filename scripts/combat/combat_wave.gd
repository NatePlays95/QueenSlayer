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
	AudioManager.play_sfx("Misc/EnemySpawn.wav", "Swooshes")
	print_debug("Wave Started. Enemies: ", enemies)


func kill_all_enemies():
	for child in get_children():
		if not child is Enemy: continue
		var enemy = child as Enemy
		enemy.apply_damage(enemy.health)


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_K:
			kill_all_enemies()


func _ready():
	visible = false
	y_sort_enabled = true
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
