extends Node2D

const pressed = "64ffffff"
const notPressed = "ffffff"

var hard_mode = Global.hard_mode
var release_frogs = Global.release_frogs
var global

func _ready():
	OS.center_window()
	global = get_node("/root/Global")
	_checkHardButton()
	_checkFrogButton()

func _checkHardButton():
	if hard_mode:
		$Difficulty/EasyGame.set_modulate(notPressed) 
		$Difficulty/HardGame.set_modulate(pressed)
	else:
		$Difficulty/EasyGame.set_modulate(pressed)
		$Difficulty/HardGame.set_modulate(notPressed)
	
func _checkFrogButton():
	if release_frogs:
		$Frogs/KeepFrogs.set_modulate(notPressed)
		$Frogs/NoMoreFrogs.set_modulate(pressed)
	else:
		$Frogs/KeepFrogs.set_modulate(pressed)
		$Frogs/NoMoreFrogs.set_modulate(notPressed)

func _on_HardGame_pressed():
	hard_mode = true
	_checkHardButton()

func _on_EasyGame_pressed():
	hard_mode = false
	_checkHardButton()

func _on_KeepFrogs_pressed():
	release_frogs = false
	_checkFrogButton()

func _on_NoMoreFrogs_pressed():
	release_frogs = true
	_checkFrogButton()

func _on_Back_pressed():
	global.hard_mode = hard_mode
	global.release_frogs = release_frogs
	get_tree().change_scene("res://menu/Control.tscn")
