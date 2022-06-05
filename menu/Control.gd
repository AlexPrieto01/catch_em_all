extends Control

func _ready():
	OS.center_window()
	get_node("/root/Global")
	Global.play_music(Global.controlMusic_path)
	$Background.modulate = Color(randf(), 0, randf())

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://main/Main.tscn")

func _on_LabelStart_pressed():
	Global.change_musicTo(Global.takeRandomPath())
	get_tree().change_scene("res://main/Main.tscn")

func _on_LabelAssets_pressed():
	get_tree().change_scene("res://menu/Settings.tscn")
