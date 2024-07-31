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
@onready var lighter = $lighter_collectable
@onready var ruby = $ruby_collectable

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
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
			
		if colliding_with_player and player.isAlive and !dead:
			deal_damage(slime_damage)	
		
		
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true


# ---------- collision functions ----------
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		if player.shadowsPotionOn:
			return
		player_in_area = true
	

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

func _on_find_player_area_body_entered(body):
	if body.has_method("player"):
		player = body

func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("projectile_deal_damage"):
		if player and player.firePotionOn:
			damage = player.base_damage + 100
		elif player:
			damage = player.base_damage
		if player and player.frostPotionOn:
			speed = 10
			$Slow_timer.start(10)
		if player and player.shockPotionOn:
			speed = 0
			$Shock_timer.start(10)
		print(damage)
		if !dead:
			take_damage(damage)
			
		area.visible = false
			
		
		

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		colliding_with_player = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		colliding_with_player = false

# --------- damage functions -----------
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

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	
	# get random number
	randomize()
	randNum = randi_range(1, 100)
	
	# decide drop based on number
	if randNum > 95:     # 5% chance to drop rare item
		dropAndCollect(ruby) # add rare item
	elif randNum <= 95 && randNum > 85:     # 10% chance to drop lighter
		dropAndCollect(lighter)    
	elif randNum <= 85 && randNum > 45: # 40% change to drop slime
		dropAndCollect(slime)
	# else - 45% no drops for wizard, get rekt
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
	
# ------------ resources: drop and collect function ------------
func dropAndCollect(item):
	item.visible = true
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_slow_timer_timeout():
	speed = 100


func _on_shock_timer_timeout():
	speed = 100
