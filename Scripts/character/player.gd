extends CharacterBody2D
class_name Player

var speed = 100
var health = 100
var base_damage = 50
var player_state

@export var inv: Inv
@onready var healthbar = $Healthbar
@onready var pot: Pot = load("res://Alchemy/Potions/potion_inventory.tres")

# once the game has ended, make sure game_has_started, and wand_equipped is set to false
# by default, game_has_started will eventually be set to false so player has to initiate game start function to use wand
var isAlive = true

# potion effects
var protectionPotionOn = false
var isHealingPotion = false
var reflectionPotionOn = false
var burstPotionOn = false
var spreadPotionOn = false
var speedPotionOn = false
var firePotionOn = false
var frostPotionOn = false
var shockPotionOn = false
var lovePotionOn = false
var luckPotionOn = false
var shadowsPotionOn = false


var game_has_started = false
var wand_equipped = false
var wand_cooldown = true
var projectile = preload("res://Scenes/character/projectile.tscn")
var currentIndex

var mouse_loc_from_player = null

func _ready():
	health = 100
	isAlive = true
	healthbar.init_health(health)
	
func _set_health(value):
	if protectionPotionOn and !isHealingPotion:
		return
	if reflectionPotionOn and !isHealingPotion:
		return
	else:
		health = value
		if health <= 0 and isAlive:
			death()
		
		healthbar.health = health

func _physics_process(delta):
	mouse_loc_from_player = get_global_mouse_position() - self.position
	
	# what direction is player facing?
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# set state of players idle and walking animations, and calculate velocity
	if isAlive:
		if direction.x == 0 and direction.y == 0:
			player_state = "idle"
		elif direction.x != 0 or direction.y != 0:
			player_state = "walking"
		
		
	velocity = direction * speed
	move_and_slide()
	
	# wand_equipped will be true based on whether or not the game has started yet.
	if game_has_started:
		wand_equipped = true
	else:
		wand_equipped = false
		
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	
	# event handler for left mouse click when game has started, fires projectiles 
	if Input.is_action_just_pressed("left_mouse") and wand_equipped and game_has_started and wand_cooldown:
		wand_cooldown = false
		
		var projectile_instance = projectile.instantiate()
		projectile_instance.rotation = $Marker2D.rotation
		projectile_instance.global_position = $Marker2D.global_position
		add_child(projectile_instance)
		$projectileAudio.play()

		if burstPotionOn:
			await get_tree().create_timer(0.05).timeout
			var projectile_instance2 = projectile.instantiate()
			var projectile_instance3 = projectile.instantiate()

			projectile_instance2.rotation = $Marker2D.rotation
			projectile_instance3.rotation = $Marker2D.rotation
			
			projectile_instance2.global_position = $Marker2D.global_position
			projectile_instance3.global_position = $Marker2D.global_position
			
			add_child(projectile_instance2)
			await get_tree().create_timer(0.05).timeout
			add_child(projectile_instance3)
		if spreadPotionOn:
			var projectile_instance3 = projectile.instantiate()
			var projectile_instance4 = projectile.instantiate()
			projectile_instance3.rotation = $Marker2D.rotation * 0.25
			projectile_instance4.rotation = $Marker2D.rotation * 0.5
			
			projectile_instance3.global_position = $Marker2D.global_position
			projectile_instance4.global_position = $Marker2D.global_position
			add_child(projectile_instance3)
			add_child(projectile_instance4)
		
		await get_tree().create_timer(0.3).timeout

		
		# plays attack animation when left mouse click is used not working very well, attack animation can be low priority
		# play_attack_anim(mouse_loc_from_player)
		
		wand_cooldown = true
	
	play_anim(direction)

func play_anim(dir):
	
	

		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
			
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")


func play_attack_anim(mouse_loc_from_player):
	
		if wand_equipped:
			if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
				$AnimatedSprite2D.play("n-attack")
			if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
				$AnimatedSprite2D.play("e-attack")
			if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
				$AnimatedSprite2D.play("s-attack")
			if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.x < 0:
				$AnimatedSprite2D.play("w-attack")
				
			if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
				$AnimatedSprite2D.play("ne-attack")
			if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
				$AnimatedSprite2D.play("se-attack")
			if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
				$AnimatedSprite2D.play("sw-attack")
			if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
				$AnimatedSprite2D.play("ne-attack")

func player():
	pass

func collect(item):
	inv.insert(item)
	
func drink_potion(name, index):
	print("drinks: ")
	match name:
		"Potion of Healing":
			print("potion of healing")
			potion_of_healing_effect()
		"Potion of Speed":
			print("potion of Speed")
			potion_of_speed_effect()
		"Potion of Protection":
			print("potion of Protection")
			potion_of_protection_effect()
		"Potion of Reflection":
			print("potion of Reflection")
			potion_of_reflection_effect()
		"Potion of Burst":
			print("potion of Burst")
			potion_of_burst_effect()
		"Potion of Spread":
			print("potion of Spread")
			potion_of_spread_effect()
		"Potion of Fire":
			print("potion of Fire")
			potion_of_fire_effect()
		"Potion of Frost":
			print("potion of Frost")
			potion_of_frost_effect()
		"Potion of Shock":
			print("potion of Shock")
			potion_of_shock_effect()
		"Potion of Love":
			print("potion of Love")
			potion_of_love_effect()
		"Potion of Luck":
			print("potion of Luck")
			potion_of_luck_effect()
		"Potion of Shadows":
			print("Potion of Shadows")
			potion_of_shadows_effect()
			
	$potion_ui.remove_potion(name, index)

	

# potion effect functions

func potion_of_healing_effect():
	isHealingPotion = true
	var new_health = health + 10
	if health >= 100:
		_set_health(100)
	else:
		_set_health(new_health)	
	isHealingPotion = false

func potion_of_speed_effect():
	speedPotionOn = true
	speed = 400
	$Speed_timer.start(10)

func potion_of_protection_effect():
	protectionPotionOn = true
	$Protection_timer.start(10)
	
func potion_of_reflection_effect():
	reflectionPotionOn = true
	$Reflection_timer.start(10)

func potion_of_burst_effect():
	burstPotionOn = true
	$Burst_timer.start(10)
	
func potion_of_spread_effect():
	spreadPotionOn = true
	$Spread_timer.start(10)

func potion_of_fire_effect():
	firePotionOn = true
	base_damage = 50
	$Fire_timer.start(10)

func potion_of_frost_effect():
	frostPotionOn = true
	$Frost_timer.start(10)
	
func potion_of_shock_effect():
	shockPotionOn = true
	$Shock_timer.start(10)
	
func potion_of_love_effect():
	lovePotionOn = true
	$Love_timer.start(10)
	
func potion_of_luck_effect():
	luckPotionOn = true
	$Luck_timer.start(10)
	
func potion_of_shadows_effect():
	shadowsPotionOn = true
	$Shadows_timer.start(10)


# the all so scary death function

func death():
	isAlive = false
	print("player is dead lol")
	$AnimatedSprite2D.play("death")
	$CollisionShape2D.disabled = true
	speed = 0
	get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/levels/house.tscn")
	$CollisionShape2D.disabled = false
	speed = 100
	

	
	
	# hello - corbin


# potion effect timeout signals

func _on_potion_ui_drink_potion(potion, index):
	drink_potion(potion.name, index)
	
func _on_speed_timer_timeout():
	speed = 100
	speedPotionOn = false

func _on_protection_timer_timeout():
	protectionPotionOn = false

func _on_reflection_timer_timeout():
	reflectionPotionOn = false

func _on_burst_timer_timeout():
	burstPotionOn = false

func _on_spread_timer_timeout():
	spreadPotionOn = false

func _on_fire_timer_timeout():
	firePotionOn = false
	

func _on_frost_timer_timeout():
	frostPotionOn = false

func _on_shock_timer_timeout():
	shockPotionOn = false

func _on_love_timer_timeout():
	lovePotionOn = false

func _on_luck_timer_timeout():
	luckPotionOn = false

func _on_shadows_timer_timeout():
	shadowsPotionOn = false
