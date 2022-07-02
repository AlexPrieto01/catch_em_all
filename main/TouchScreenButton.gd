extends TouchScreenButton

signal joystick(velocity)

const limit = 20

var screenSize = Vector2.ZERO
var touchPos = null
var basePos = Vector2.ZERO
var isAreaEntered = false
var isNotProcessing = true
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
	if isAreaEntered and InputEventScreenTouch and isNotProcessing:
		isNotProcessing = false
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
		isNotProcessing = true

#Movimiento del personaje
func _character_control():
	velocity = Vector2.ZERO
	if isAreaEntered:
		velocity = $Base/Joystick.position

func _process(delta):
	_character_control()
	emit_signal("joystick", velocity)

func _on_Player_hard():
	set_process(false)
