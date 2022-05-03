extends TouchScreenButton

var screenSize = Vector2.ZERO
var touchPos = null
var basePos = Vector2.ZERO
var isAreaEntered = false
#Player vars
var velocity = Vector2.ZERO
var speed = 400
var auxPosition

func _ready():
	screenSize = get_viewport().get_size()
	shape.extents.x = screenSize.x
	shape.extents.y = screenSize.y

func _on_TouchScreenButton_pressed():
	isAreaEntered = true

func _on_TouchScreenButton_released():
	isAreaEntered = false
	touchPos = null
	$Base.hide()
	

func _input(event):
	if isAreaEntered and InputEventScreenTouch:
		if touchPos==null: 
			touchPos = event.get_position() 
			basePos = touchPos
			$Base.show()
			$Base/Joystick.show()
			$Base.position = touchPos
		else:
			touchPos = event.get_position() 
		$Base/Joystick.position = touchPos-$Base.position
		print($Base/Joystick.position)

#Movimiento del personaje
func _character_control(delta):
	velocity = Vector2.ZERO
	velocity = $Base/Joystick.position*delta*speed
	
	

func _process(delta):
	
	pass
	


