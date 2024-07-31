# shadow_fiend.gd
# controls shadow fiend enemy logic

extends CharacterBody2D

# shadow knight variables
var speed = 175
var health = 100
var ghost_damage = 0.5
var dead = false

#detector/collision variables
var colliding_with_player = false
var player_in_area = false
var player = null

# item drop texture variables
@onready var bone = $bone_collectable
@onready var orb = $shadow_orb_collectable
@onready var ring = $ring_collectable

var randNum

@onready var healthbar = $Healthbar
func _ready():
	health = 100
	dead = false
	healthbar.visible = false
	healthbar.init_health(health)
	
func _set_health(value):
		health = value
		if health <= 0 and !dead:
			death()
		
		healthbar.health = health

func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false

		if player_in_area:
			var direction = (player.position - position).normalized()
			position += direction * speed * delta
			$AnimatedSprite2D.play("idle")     # change to "move" when animation is made
		else:
			$AnimatedSprite2D.play("idle")
			
		if colliding_with_player and player.isAlive and !dead:
			deal_damage(ghost_damage)	
		
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true

		
# ------------ damage functions ------------
func take_damage(damage):
	var new_health = health - damage
	healthbar.visible = true
	if health <= 0 and !dead:
		death()
	else:
		_set_health(new_health)
		
func deal_damage(damage):
	if player.reflectionPotionOn:
		take_damage(damage)
	else:
		var new_health = player.health - damage
		if player.health <= 0:
			player.death()
		else:
			player._set_health(new_health)	
		

# ------------ collision functions ------------
# shadow knight hit by attack
func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("projectile_deal_damage"):
		if player.firePotionOn:
			damage = player.base_damage + 100
		else:
			damage = player.base_damage
		if player and player.frostPotionOn:
			speed = 10
			$Slow_timer.start(10)
		if player and player.shockPotionOn:
			speed = 0
			$Shock_timer.start(10)
		print(damage)
		print(player.firePotionOn)
		if !dead:
			take_damage(damage)
		area.visible = false
	
# when player is within enemy detection area
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		if player.shadowsPotionOn:
			return
		player_in_area = true

# when player leaves enemy detection area
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

# enemy collides with player
func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		colliding_with_player = true

# enemy/player exit collision area
func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		colliding_with_player = false
		
		
# ------------ death function ------------
func death():
	dead = true
	# todo - add death animation
	# $AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.1).timeout
	
	
	# get random number
	randomize()
	randNum = randi_range(1, 100)
	
	# drop resource, decide drop based on random number
	if randNum > 95:     # 5% chance to drop ring
		dropAndCollect(ring)
	elif randNum <= 95 && randNum > 75:     # 20% chance to drop orb
		dropAndCollect(orb)    
	elif randNum <= 75 && randNum > 35: # 40% change to drop bone
		dropAndCollect(bone)
	# else - 35% no drops for wizard, get rekt
	
	# get rid of sprite and disable all hitboxes 
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
# ------------ resources: drop and collect function ------------
func dropAndCollect(item):
	item.visible = true
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_find_player_area_body_entered(body):
	if body.has_method("player"):
		player = body


func _on_slow_timer_timeout():
	speed = 175


func _on_shock_timer_timeout():
	speed = 175
