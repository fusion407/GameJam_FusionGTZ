extends CharacterBody2D

var speed = 100
var health = 100
var slime_damage = 1

var dead = false
var colliding_with_player = false
var player_in_area = false
var player = null
var randNum

@onready var slime = $slime_collectable
@onready var bone = $bone_collectable

# load item res variable
@export var addBoneInv = preload("res://Inventory/items/bone.tres") 
@export var itemRes: InvItem

func _ready():
	dead = false
	
func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
			
		if colliding_with_player and player.isAlive:
			deal_damage(slime_damage)	
		
	if dead:
		$detection_area/CollisionShape2D.disabled = true


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body
		


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		player = null


func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("projectile_deal_damage"):
		damage = 50
		take_damage(damage)

func take_damage(damage):
	health = health - damage
	if health <= 0 and !dead:
		death()
		
func deal_damage(damage):
	if player.health <= 0:
		player.death()
		
	player.health = player.health - damage
	print(player.health)	

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	
	# get random number
	randomize()
	randNum = randi_range(1, 100)
	
	# decide drop based on number
	if randNum > 85:     # 15% chance to drop bone
		drop_bone()
	elif randNum <= 85 && randNum >= 35:     # 50% chance to drop slime
		drop_slime()     
	# else - 35% no drops for wizard, get rekt
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
# drop and collection functions
func drop_slime():
	slime.visible = true
	$slime_collect_area/CollisionShape2D.disabled = false
	slime_collect()
	
func drop_bone():
	bone.visible = true
	$slime_collect_area/CollisionShape2D.disabled = false
	bone_collect()
	
func slime_collect():
	await get_tree().create_timer(1.5).timeout
	slime.visible = false
	if player: 
		player.collect(itemRes)
	queue_free()

func bone_collect():
	await get_tree().create_timer(1.5).timeout
	bone.visible = false
	if player: 
		player.collect(addBoneInv)
	queue_free()


func _on_slime_collect_area_body_entered(body):
	if body.has_method("player"):
		player = body


func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		colliding_with_player = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		colliding_with_player = false
