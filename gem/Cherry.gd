extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
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


func _on_Timer_timeout():
	call_deferred("queue_free")
