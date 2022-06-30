extends Area2D
#signal
signal picked
signal hard
#constants
const marginScreen = Global.marginScreen
const screenSize = Global.screenSize
const high_speed = 600
const normal_speed = 400
#var
var velocity = Vector2.ZERO
var speed = normal_speed
var turbo
var hurt

func _ready():
	pass
	
func _process(delta):
	#_character_control()
	_sprite_control()
	_velocity_control(delta)
	_limit_control()
	
#Movimiento del personaje
func _character_control():
	hurt=false;
	velocity = Vector2.ZERO
	velocity.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	velocity.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	if Input.is_action_pressed("ui_accept"):
		hurt=true	


#Cambio de sprites
func _sprite_control():
	if velocity.x !=0 or velocity.y!=0:
		if velocity.x<0:
			$AnimatedSprite.flip_h=true
		elif velocity.x>0:
			$AnimatedSprite.flip_h=false
		$AnimatedSprite.play("run")
	else:
		if hurt:
			$AnimatedSprite.play("hurt")
		else:
			$AnimatedSprite.play("idle")

#Ajuste de velocidad
func _velocity_control(delta):
	if velocity.length()>0:
		velocity = velocity.normalized()*speed*delta
	position+=velocity

#Control de limite
func _limit_control():
	if position.x > screenSize.x:
		position.x = -marginScreen
	if position.x < -marginScreen:
		position.x = screenSize.x
	if position.y>screenSize.y:
		position.y = -marginScreen
	if position.y < -marginScreen:
		position.y = screenSize.y
#	if position.x>450:
#		position.x=450
#	if position.x<0:
#		position.x=0
#	if position.y>720:
#		position.y=720
#	if position.y<0:
#		position.y=0

func _powerUp_Start():
	speed=high_speed
	$powerUp.start()

func game_over():
	set_process(false)
	$HitAudio.play()
	$AnimatedSprite.animation = "hurt"
	$CollisionShape2D.queue_free()

func _on_joystick_signal(new_velocity):
	velocity = new_velocity

func _on_Owl_player_area_entered(area):
	if area.is_in_group("food"):
		$FoodAudio.play()
		emit_signal("picked", "food")
		
	elif area.is_in_group("cherry"):
		$CherryAudio.play()
		emit_signal("picked", "cherry")
		
	if area.has_method("pickup"):
		area.pickup()
		
	elif area.name:
		pass

func _on_Owl_player_body_entered(body):
	print(body.get_name())
	if body.is_in_group("enemy"):
		emit_signal("hard") 
	if body.get_name() == "plants":
		pass

func _on_powerUp_timeout():
	speed = normal_speed
