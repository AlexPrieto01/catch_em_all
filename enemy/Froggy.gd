extends KinematicBody2D

var auxAnimationName

export(int) var gravity
export(int) var jump
export(int) var speed

var velocity = Vector2.ZERO
var current_anim
var new_anim

enum {IDLE, BREATHE, JUMP_UP, JUMP_DOWN}
var state

func transition_to(new_state):
	state = new_state
	match state:
		IDLE: 
			new_anim = "idle"
		BREATHE: 
			new_anim = "breathe"
		JUMP_UP: 
			new_anim = "jump_up"
		JUMP_DOWN:
			new_anim = "jump_down"

func _process(delta):
	
	_limit_control()
	
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimationPlayer.play(current_anim)
		
		
	if not is_on_floor():
		velocity.x = speed
		$Sprite.flip_h = (speed>0)
		if velocity.y > 0:
			transition_to(JUMP_DOWN)
		
	else:
		velocity.x = 0
		
	if is_on_floor() and state == JUMP_DOWN:
		transition_to(IDLE)

func _physics_process(delta):
	velocity.y += gravity*delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _ready():
	randomize()
	$Sprite.frame = 0
	transition_to(IDLE)
	setTimer()

func setTimer():
	#Breath, jump
	var interval = rand_range(2,6)
	if $Timer.is_stopped():
			$Timer.wait_time = interval
			$Timer.start()
	if $JumpTimer.is_stopped():
			$JumpTimer.wait_time = interval
			$JumpTimer.start()

func _on_Timer_timeout():
	$Timer.stop()
	if state == IDLE:
		transition_to(BREATHE)
#	$AnimationPlayer.play("idle")
	setTimer()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "breathe":
		transition_to(IDLE)


func _on_JumpTimer_timeout(): #La rana salta
	$JumpTimer.stop()
	if state == IDLE:
		velocity.y = jump
		transition_to(JUMP_UP)
		update_Speed()
	setTimer()

func update_Speed():
	speed = speed * -1 if bool(randi() % 2) else speed * 1
	
func _limit_control():
	if position.x>460:
		position.x=-10
	if position.x<-10:
		position.x=450
	if position.y>730:
		position.y=-10
	if position.y<-10:
		position.y=730
