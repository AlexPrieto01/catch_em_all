extends Area2D
#signal
signal picked
signal hard
#var
var velocity = Vector2.ZERO
var speed = 400
var turbo
var hurt
func _ready():
	OS.center_window()
	position = Vector2(225,360)
	
func _process(delta):
	_character_control()
	_sprite_control()
	_velocity_control(delta)
	_limit_control()
	
#Movimiento del personaje
func _character_control():
	hurt=false;
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y += -1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x += -1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
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
	if position.x>500:
		position.x=-50
	if position.x<-50:
		position.x=500
	if position.y>750:
		position.y=-50
	if position.y<-50:
		position.y=750
#	if position.x>450:
#		position.x=450
#	if position.x<0:
#		position.x=0
#	if position.y>720:
#		position.y=720
#	if position.y<0:
#		position.y=0


func _on_Player_area_entered(area):
	if area.is_in_group("gem"):
		$GemAudio.play()
		emit_signal("picked", "gem")
		
	elif area.is_in_group("cherry"):
		$CherryAudio.play()
		emit_signal("picked", "cherry")
	if area.has_method("pickup"):
		area.pickup()



func _powerUp_Start():
	speed=600
	$powerUp.start()
	
func _powerUp_End():
	speed=400

func game_over():
	set_process(false)
	$HitAudio.play()
	$AnimatedSprite.animation = "hurt"


func _on_Player_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("hard") 
