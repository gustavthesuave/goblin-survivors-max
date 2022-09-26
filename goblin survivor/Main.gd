extends Node

var creep_01 = preload("res://creep_01.tscn")
var moneybag = preload("res://moneybag.tscn")

var elf_points = 0
var goldz = 0
var total_elf_points = 0

func _ready():
	$HealButton.text = "Elf Meatz: " + String(elf_points)
	$TotalKillz.text = "Total Elfs Bashed: " + String(total_elf_points)
	$goldz.text = "GoLdz: " + String(goldz)

func _process(delta):
	$goldz.text = "GoLdz: " + String(goldz)
	if Input.is_action_just_released("heal_button"):
		if elf_points < 5:
			return
		elf_points -= 5
		$YSort/player.cur_health += 1
		$YSort/player.emit_signal("player_health", $YSort/player.cur_health)
		$HealButton.text = "Elf Meatz: " + String(elf_points)
		$YSort/player/ProgressBar.value += 1
	
	if total_elf_points >= 100:
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://winscreen.tscn")
		
func _on_Timer_timeout():
	var enemy = creep_01.instance()
	$YSort.add_child(enemy)
	#enemy.connect("damage_player", self, "on_player_hit")
	enemy.connect("tree_exiting", self, "update_KillMoneyz", [enemy])
	var player = $YSort/player
	if player:
		enemy.position = player.position + Vector2(250, 0).rotated(rand_range(0, 2*PI))
	#func on_player_hit():
	#$YSort/player._on_creep_bubble_body_entered()

func _on_player_player_health(cur_health):
	$CurrentHealth.text = "HP: " + String(cur_health)

func update_KillMoneyz(enemy):
	elf_points += 1
	total_elf_points += 1
	$HealButton.text = "Elf Meatz: " + String(elf_points)
	$TotalKillz.text = "Total Elfs Bashed: " +String(total_elf_points)
	var player = $YSort/player
	var gold_check = randi() % 4 + 1
	if gold_check == 3:
		var goldbag = moneybag.instance()
		$YSort.add_child(goldbag)
		goldbag.position = enemy.position + Vector2(1, 0)
		#goldbag.connect("update_goldz", self, "_on_update_goldz", [goldbag])
	enemy.disconnect("tree_exiting", self, "update_KillMoneyz")

func _on_HealButton_pressed():
	if elf_points < 5:
		return
	elf_points -= 5
	$YSort/player.cur_health += 1
	$YSort/player.emit_signal("player_health", $YSort/player.cur_health)
	$HealButton.text = "Elf Meatz: " + String(elf_points)
	$YSort/player/ProgressBar.value += 1
	
#func _on_update_goldz(goldbag):
	#goldz += 1
	#goldbag.disconnect("update_goldz", self, "_on_update_golds")
	#print(String(goldz))

func _on_gold_grab_body_entered(body):
	goldz += randi() % 4 + 1
