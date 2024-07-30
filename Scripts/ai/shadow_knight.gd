extends CharacterBody2D

# shadow knight variables
var speed = 40
var health = 300
var knight_damage = 3
var dead = false

#detector/collision variables
var colliding_with_player = false
var player_in_area = false
var player = null
var collectable_area = false

# item drop texture variables
@onready var bone = $bone_collectable
@onready var orb = $shadow_orb_collectable
@onready var ring = $ring_collectable
@onready var stone = $stone_collectable

# item resource variables 
var boneRes = preload("res://Inventory/items/bone.tres") 
var orbRes = preload("res://Inventory/items/shadow_orb.tres")
var ringRes = preload("res://Inventory/items/ring.tres")
var stoneRes = preload("res://Inventory/items/stone.tres")
var randNum

func _ready():
	dead = false

func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed 
			$AnimatedSprite2D.play("idle")     # change to "move" when animation is made
		else:
			$AnimatedSprite2D.play("idle")
			
		if colliding_with_player and player.isAlive and !dead:
			deal_damage(knight_damage)	
		
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		
# ------------ damage functions ------------
func take_damage(damage):
	health = health - damage
	if health <= 0 and !dead:
		death()
		
func deal_damage(damage):
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
		damage = 50
		take_damage(damage)

# when player is within enemy detection area
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body

# when player leaves enemy detection area
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		player = null

# enemy collides with player
func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		colliding_with_player = true

# enemy/player exit collision area
func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		colliding_with_player = false
		
# collection area for enemy resource drops
func _on_shadow_collect_area_body_entered(body):
	if body.has_method("player"):
		player = body
		
# ------------ death function ------------
func death():
	dead = true
	# todo - add death animation
	# $AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	
	
	# get random number
	randomize()
	randNum = randi_range(1, 100)
	
	# drop resource, decide drop based on random number
	if randNum > 95:     # 5% chance to drop ring
		drop_stone()
	elif randNum <= 95 && randNum > 75:     # 20% chance to drop orb
		drop_stone()     
	elif randNum <= 75 && randNum > 0: # 40% change to drop bone
		drop_stone()
	# else - 35% no drops for wizard, get rekt
	
	# get rid of sprite and disable all hitboxes except collect_area
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
# ------------ resources: drop and collect functions ------------
func drop_bone():
	bone.visible = true
	$shadow_collect_area/CollisionShape2D.disabled = false
	bone_collect()

func drop_orb():
	orb.visible = true
	$shadow_collect_area/CollisionShape2D.disabled = false
	orb_collect()

func drop_ring():
	ring.visible = true
	$shadow_collect_area/CollisionShape2D.disabled = false
	ring_collect()

func drop_stone():
	stone.visible = true
	await get_tree().create_timer(5).timeout
	queue_free()	
	

func bone_collect():
	await get_tree().create_timer(1.5).timeout
	bone.visible = false
	if player: 
		player.collect(boneRes)
	queue_free()
	
func orb_collect():
	await get_tree().create_timer(1.5).timeout
	orb.visible = false
	if player: 
		player.collect(orbRes)
	queue_free()
	
func ring_collect():
	await get_tree().create_timer(1.5).timeout
	ring.visible = false
	if player: 
		player.collect(ringRes)
	queue_free()
