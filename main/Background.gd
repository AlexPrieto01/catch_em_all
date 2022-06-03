extends Node2D

var color
var new_modulate
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Sprite.modulate = _make_rainbow_effect()
	new_modulate = _make_rainbow_effect()
	color = _make_rainbow_effect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	new_modulate = lerp(new_modulate, color, 0.02)
	$Sprite.modulate = new_modulate

func _make_rainbow_effect():
	return Color(
		randf(),
		randf(),
		randf()
	)

func _on_Timer_timeout():
	color = _make_rainbow_effect()
