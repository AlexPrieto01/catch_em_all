extends Area2D

var screenSize
var marginScreen

func _ready():
	randomize()
	screenSize = Global.screenSize
	marginScreen = Global.marginScreen
	$Worm.animation = "default"
	$Worm.frame = rand_range(0,7)
	#Escalado
	$Tween.interpolate_property(
		$Worm,
		'scale',
		$Worm.scale, 
		$Worm.scale*2, 
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
		)
	#Desvanecimiento
	$Tween.interpolate_property(
		$Worm,
		'modulate',
		Color(1,1,1,1), 
		Color(1,1,1,0), 
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
		)
		
func pickup():
	self.remove_child($Hitbox)
	$Tween.start()
#	yield($Tween, "tween_completed")
#	call_deferred("queue_free")

func _on_Tween_tween_all_completed():
	call_deferred("queue_free")


func _on_Food_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("collision"):
		position = Vector2(
			rand_range(marginScreen,screenSize.x-marginScreen), 
			rand_range(marginScreen,screenSize.y-marginScreen))
		print("Gema colisiona con rana")
