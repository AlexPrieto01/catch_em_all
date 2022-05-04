extends Area2D

var screenSize
var marginScreen

func _ready():
	screenSize = Global.screenSize
	marginScreen = Global.marginScreen
	$AnimatedSprite.animation = "default"
	#Escalado
	$Tween.interpolate_property(
		$AnimatedSprite,
		'scale',
		$AnimatedSprite.scale, 
		$AnimatedSprite.scale*2, 
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
		)
	#Desvanecimiento
	$Tween.interpolate_property(
		$AnimatedSprite,
		'modulate',
		Color(1,1,1,1), 
		Color(1,1,1,0), 
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
		)
		
func pickup():
	self.remove_child($GemHitbox)
	$Tween.start()
#	yield($Tween, "tween_completed")
#	call_deferred("queue_free")

func _on_Tween_tween_all_completed():
	call_deferred("queue_free")

func _on_Gem_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("collision"):
		position = Vector2(
			rand_range(marginScreen,screenSize.x-marginScreen), 
			rand_range(marginScreen,screenSize.y-marginScreen))
		print("Gema colisiona con rana")
