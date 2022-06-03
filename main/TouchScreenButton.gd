extends TouchScreenButton

signal joystick(velocity)

const limit = 20

var screenSize = Vector2.ZERO
var touchPos = null
var basePos = Vector2.ZERO
var isAreaEntered = false
#Player vars
var velocity = Vector2.ZERO
var speed = 400
var auxPosition


func _ready():
	screenSize = Global.screenSize
	shape.extents = screenSize
	
	connect("joystick", $Player, "_on_joystick_signal")
	

func _on_TouchScreenButton_pressed():
	isAreaEntered = true

func _on_TouchScreenButton_released():
	isAreaEntered = false
	touchPos = null
	$Base.hide()
	

func _input(event):
	if isAreaEntered and InputEventScreenTouch:
		if touchPos==null and !$Base.visible: 
			touchPos = event.get_position() 
			basePos = touchPos
			$Base.show()
			$Base/Joystick.show()
			$Base.position = touchPos
		else:
			touchPos = event.get_position() 
			#touchPos.x = clamp(touchPos.x, -limit+$Base.position.x, limit+$Base.position.x)
			#touchPos.y = clamp(touchPos.y, -limit+$Base.position.y, limit+$Base.position.y)
		
		#Procura que el movimiento sea más circular
		auxPosition = touchPos-$Base.position
		auxPosition = auxPosition.normalized()
		$Base/Joystick.position.x = auxPosition.x
		$Base/Joystick.position.y = auxPosition.y 
		

#Movimiento del personaje
func _character_control(delta):
	velocity = Vector2.ZERO
	if isAreaEntered:
		velocity = $Base/Joystick.position

func _sprite_control():
	if velocity.x !=0 or velocity.y!=0:
		if velocity.x<0:
			$Player/AnimatedSprite.flip_h=true
		elif velocity.x>0:
			$Player/AnimatedSprite.flip_h=false
		$Player/AnimatedSprite.play("run")
	else:
		$Player/AnimatedSprite.play("idle")

func _process(delta):
	_character_control(delta)
#	_sprite_control()
#	if velocity.length()>0:
#		velocity = velocity.normalized()*speed*delta
#		$Player.position += velocity
	emit_signal("joystick", velocity)

func _on_Player_hard():
	set_process(false)
