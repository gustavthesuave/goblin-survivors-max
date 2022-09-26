extends KinematicBody2D

#signal goldz_check

func _ready(): 
	pass

func _physics_process(delta):
	var player = get_parent().get_node("player")
	#if is_instance_valid(player):
	position += (player.position - position).normalized() * 0.65
	if position.x - player.position.x > 0:
		$creep_01_AnimatedSprite.flip_h = true
	else:
		$creep_01_AnimatedSprite.flip_h = false

func _on_creep_bubble_body_entered(body):
	print("OUCH -1 HP!!!") # Replace with function body.
	#emit_signal("goldz_check")
	body._on_creep_bubble_body_entered()
	#print(body)
