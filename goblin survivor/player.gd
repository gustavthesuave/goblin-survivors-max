extends KinematicBody2D

# temporarily constant movement speed...
var player_speed = 200.0

var is_attacking = false
var is_dying = false
var is_grabbing = false

var max_health = 5
onready var cur_health = max_health
#onready var golds = 0

signal player_health(current_health)
#signal update_goldz(golds)

func _ready():
	$ProgressBar.max_value = max_health
	$ProgressBar.value = max_health
	emit_signal("player_health", max_health)
	
func _process(_delta):
	var player_direction = Vector2.ZERO 
	var player_velocity = Vector2.ZERO
	
	if not is_dying:
		# get direction info from asdf keys...
		player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		# creating a movement vector and mechanism...
		player_velocity = player_direction * player_speed
		player_velocity = move_and_slide(player_velocity)
	
	
	if not is_attacking and not is_dying and not is_grabbing:
		# account for directional input and animation facing...
		if player_velocity.x > 0:
			$player_AnimatedSprite.animation = "walk_left"
			$player_AnimatedSprite.flip_h = true
			$player_attack.scale.x = -1
			$gold_grab.scale.x = -1
		elif player_velocity.x < 0:
			$player_AnimatedSprite.animation = "walk_left"
			$player_AnimatedSprite.flip_h = false
			$player_attack.scale.x = 1
			$gold_grab.scale.x = 1
		elif player_velocity.x == 0:
			if player_velocity.y != 0:
				$player_AnimatedSprite.animation = "walk_left"
			else:
				$player_AnimatedSprite.animation = "idle"
		
		if Input.is_action_just_pressed("player_attack"):
			$AnimationPlayer.play("player_attack")
			print("yo momma")
			is_attacking = true
			
		if Input.is_action_just_pressed("gold_grab"):
			$AnimationPlayer.play("gold_grab")
			is_grabbing = true
			
func on_attack_end():
	is_attacking = false

func on_grab_end():
	is_grabbing = false
	
func _on_player_attack_body_entered(body):
	body.queue_free()

func _on_creep_bubble_body_entered():
	print("ballz that hurtz!!!")
	cur_health -= 1
	$ProgressBar.value -= 1
	emit_signal("player_health", cur_health)
	if cur_health <= 0:
		cur_health = 0
		is_dying = true
		print("oh NOES, my megabytes!!!")
		$player_AnimatedSprite.animation = "death"
	if cur_health <= 0:
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://deathscreen.tscn")
		
func _on_gold_grab_body_entered(body):
	body.queue_free()
	#golds = 1
	#emit_signal("update_goldz", golds)
	print("Get That Cheeze, HOMIE!!!")
