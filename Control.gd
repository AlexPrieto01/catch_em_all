extends Control


func _ready():
	OS.center_window()

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://main/Main.tscn")
		
func _on_LabelStart_pressed():
	get_tree().change_scene("res://main/Main.tscn")
