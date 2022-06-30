extends Node2D

#signals
#constants
const BASE_FOOD = 5
const BONUS_TIME = 10
const FROGGY_HIGH = -280
const STAGEFORFROG = 5
#exports
export(PackedScene) var Froggy
export(PackedScene) var Food
export(PackedScene) var Cherry
#vars
var global
var Cherry2 = preload("res://gem/Cherry.tscn")
var stage = 0
var stageForFrog = STAGEFORFROG
var screenSize = Vector2.ZERO
var initialTimeLeft
var score = 0
var highScore = 0
var scoreByStage = BASE_FOOD
var scoreMaxByStage = BASE_FOOD
var foodLeft = BASE_FOOD
var audio
var auxStr
var scoreFile

onready var gameOverDelay = Timer.new()

func _ready():
	#OS.center_window()
	global = get_node("/root/Global")
	randomize()
	initial_settings(Global.hard_mode, Global.release_frogs)
	screenSize = global.screenSize
	_load_score()
	spawn_food()
	set_cherryTime()

func initial_settings(var hard, var frogs):
	if hard:
		time_settings(5)
		stageForFrog = 1
	else:
		time_settings(20)
	
	if frogs:
		$FroggyBag.queue_free()
		$Platform.queue_free()

func _process(_delta):
	update_platform()
	check_Stage()

func time_settings(var time):
	
	initialTimeLeft = time
	
	$HUD_Node/HUD.update_timer(initialTimeLeft)
	gameOverDelay.wait_time = 2
	gameOverDelay.connect("timeout", self, "_on_gameOverDelay_timeout")
	self.add_child(gameOverDelay)

func _on_gameOverDelay_timeout():
	get_tree().change_scene("res://menu/Control.tscn")

func check_Stage():
	if $FoodBag.get_child_count() == 0:
		#Update stage and time bonus
		stage+=1
		initialTimeLeft += BONUS_TIME
		$StageUp.play()
#		audio = AudioStreamPlayer.new()
#		audio.stream = load("res://assets/audio/Level.wav")
#		add_child(audio)
#		audio.play()
		$HUD_Node/HUD.update_stage("Stage "+str(stage))
		scoreByStage = BASE_FOOD+stage
		scoreMaxByStage += scoreByStage
		#gemsLeft = scoreByStage
		
		#auxStr = str($GemBag.get_child_count())+"\n"+str(scoreMaxByStage)
		#$HUD_Node/HUD.update_score(auxStr)
		spawn_food()
		if stage%stageForFrog == 0 and !Global.release_frogs:
			spawn_frog()
		
func spawn_food():
	if Food != null:
		for _i in range(scoreByStage):
			var food = Food.instance()
			food.position = getRandomPosition(50)
			$FoodBag.add_child(food)

func spawn_frog():
	var frog = Froggy.instance()
	frog.position = Vector2(
		rand_range(
			Global.marginScreen, 
			screenSize.x-Global.marginScreen),
		FROGGY_HIGH)
	frog.modulate = Color(
		randf(),
		randf(),
		randf()
	)
	#Easter egg
	if stage == stageForFrog*5:
		frog.scale = Vector2(5, 5)
	print(frog.modulate)
	frog.jump = int(rand_range(-400, -700))
	frog.speed = int(rand_range(100, 300))
	$FroggyBag.add_child(frog)

func update_platform():
	if !global.release_frogs:
		$Platform.position.x = $FroggyBag/FroggyBoss.position.x
	

func _on_Timer_timeout():
	initialTimeLeft -= 1
	if initialTimeLeft >= 0:
		$HUD_Node/HUD.update_timer(initialTimeLeft)
	else:
		game_over()


func _on_Player_picked(type): #type food or cherry
	match type:
		"food":
			score += 1
			auxStr = str(score)+"\n"+str(scoreMaxByStage)
			$HUD_Node/HUD.update_score(auxStr)
			foodLeft-=1
		"cherry":
			$TouchScreenController/TouchScreenButton/Player._powerUp_Start()
	
func game_over():
	$HUD_Node/HUD.update_stage("You lose!")
	$Timer.stop()
	$TouchScreenController/TouchScreenButton/Player.game_over()
	set_process(false)
	gameOverDelay.start()

func set_cherryTime():
	var waitTime = rand_range(5,10)
	$CherryTimer.wait_time = waitTime
	$CherryTimer.start()

func getRandomPosition(red):
	return Vector2(rand_range(red,screenSize.x-red), rand_range(red,screenSize.y-red))

func _on_CherryTimer_timeout():
	if Cherry2 != null:
		var cherry = Cherry2.instance()
		cherry.position = getRandomPosition(-50)
		add_child(cherry)
		set_cherryTime()


func _on_Player_hard():
	Global.stop_music()
	Global.musicTimer.stop()
	if int(score) > int(highScore):
		_save_score()
	game_over()

func _save_score():
	scoreFile = File.new()
	scoreFile.open("user://savefile.save", File.WRITE)
	scoreFile.store_line(str(score))
	scoreFile.close()

func _load_score():
	scoreFile = File.new()
	if not scoreFile.file_exists("user://savefile.save"):
		return
	scoreFile.open("user://savefile.save", File.READ)
	highScore = scoreFile.get_line()
	$HUD_Node/HUD.update_highScore(highScore)
	scoreFile.close()
