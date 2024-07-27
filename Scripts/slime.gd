extends CharacterBody2D
class_name Slime

var speed = 100
var health = 100
var slime_damage = 1

var dead = false
<<<<<<< Updated upstream
var player_in_area
var player
=======
var player_in_area = false
var colliding_with_player = false
var player = null
var randNum
>>>>>>> Stashed changes

@onready var slime = $slime_collectable
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
			
		if colliding_with_player:
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
	player.health = player.health - damage
	print(player.health)

	
	

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	
	# todo: write function to calculate item drop chance
	drop_slime()
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
func drop_slime():
	slime.visible = true
	$slime_collect_area/CollisionShape2D.disabled = false
	slime_collect()
	
func slime_collect():
	await get_tree().create_timer(1.5).timeout
	slime.visible = false
	player.collect(itemRes)
	queue_free()



func _on_slime_collect_area_body_entered(body):
	if body.has_method("player"):
		player = body

func enemy_slime():
	pass


func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		colliding_with_player = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		colliding_with_player = false
