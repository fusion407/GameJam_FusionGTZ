extends CharacterBody2D
class_name Player

var speed = 100
var health = 100
var base_damage = 10
var player_state

@export var inv: Inv
@onready var healthbar = $Healthbar
@onready var pot: Pot = load("res://Alchemy/Potions/potion_inventory.tres")

# once the game has ended, make sure game_has_started, and wand_equipped is set to false
# by default, game_has_started will eventually be set to false so player has to initiate game start function to use wand
var isAlive = true
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
	health = value
	if health <= 0 and isAlive:
		death()
	
	healthbar.health = health
	print(health)

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
		
		# plays attack animation when left mouse click is used not working very well, attack animation can be low priority
		# play_attack_anim(mouse_loc_from_player)
		
		await get_tree().create_timer(0.1).timeout
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
			
	$potion_ui.remove_potion(name, index)

	

func craftPotion(potion):
	pot.insert(potion)
	
func potion_of_healing_effect():
	var new_health = health + 10
	if health >= 100:
		_set_health(100)
	else:
		_set_health(new_health)	

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


func _on_potion_ui_current_pot_index(index):
	currentIndex = index
	print(currentIndex)


func _on_potion_ui_drink_potion(potion, index):
	print("signal worked:")
	drink_potion(potion.name, index)
	
	
