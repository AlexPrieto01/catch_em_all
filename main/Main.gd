extends Node2D

#signals
#constants
const BASE_GEMS = 5
const BONUS_TIME = 10
#exports
export(PackedScene) var Gem
export(PackedScene) var Cherry
#vars
var global
var Cherry2 = preload("res://gem/Cherry.tscn")
var stage = 0
var screenSize = Vector2.ZERO
var initialTimeLeft
var score = 0
var scoreByStage = BASE_GEMS
var scoreMaxByStage = BASE_GEMS
var gemsLeft = BASE_GEMS
var audio
var auxStr
onready var gameOverDelay = Timer.new()

func _ready():
	OS.center_window()
	global = get_node("/root/Global")
	randomize()
	initial_settings(global.hard_mode, global.release_frogs)
	screenSize = get_viewport().get_size()
	print(str(screenSize))
	spawn_gems()
	set_cherryTime()

func initial_settings(var hard, var frogs):
	if hard:
		time_settings(5)
		pass
	else:
		time_settings(20)
		pass
	
	if frogs:
		$Froggy.queue_free()
		$Froggy2.queue_free()
		$Platform.queue_free()

func _process(delta):
	update_platform()
	check_Stage()
	_tocuch_control(InputEventScreenTouch)

func _tocuch_control(event):
	if event is InputEventScreenTouch:
		print(event.position)
		$Player/AnimatedSprite.play("hurt")

func time_settings(var time):
	
	initialTimeLeft = time
	
	$HUD.update_timer(initialTimeLeft)
	gameOverDelay.wait_time = 2
	gameOverDelay.connect("timeout", self, "_on_gameOverDelay_timeout")
	self.add_child(gameOverDelay)

func _on_gameOverDelay_timeout():
	get_tree().change_scene("res://menu/Control.tscn")

func check_Stage():
	if $GemBag.get_child_count() == 0:
		#Update stage and time bonus
		stage+=1
		initialTimeLeft += BONUS_TIME
		$StageUp.play()
#		audio = AudioStreamPlayer.new()
#		audio.stream = load("res://assets/audio/Level.wav")
#		add_child(audio)
#		audio.play()
		$HUD.update_stage("Stage "+str(stage))
		scoreByStage = BASE_GEMS+stage
		scoreMaxByStage += scoreByStage
		gemsLeft = scoreByStage
		auxStr = str(score)+"\n"+str(scoreMaxByStage)
		$HUD.update_score(auxStr)
		spawn_gems()
		print("Total gems: "+str($GemBag.get_child_count()))
		
func spawn_gems():
	if Gem != null:
		for i in range(scoreByStage):
			var gem = Gem.instance()
			gem.position = Vector2(rand_range(0,screenSize.x), rand_range(0,screenSize.y))
			$GemBag.add_child(gem)

func update_platform():
	if !global.release_frogs:
		$Platform.position.x = $Froggy.position.x
	

func _on_Timer_timeout():
	initialTimeLeft -= 1
	if initialTimeLeft >= 0:
		$HUD.update_timer(initialTimeLeft)
	else:
		game_over()


func _on_Player_picked(type): #type gem or cherry
	
	match type:
		"gem":
			score += 1
			auxStr = str(score)+"\n"+str(scoreMaxByStage)
			$HUD.update_score(auxStr)
			gemsLeft-=1
			print("Gems left: "+str(gemsLeft))
		"cherry":
			$Player._powerUp_Start()
	

func game_over():
	$HUD.update_stage("You lose!")
	$Timer.stop()
	$TouchScreenController/TouchScreenButton/Player.game_over()
	set_process(false)
	gameOverDelay.start()

func set_cherryTime():
	var waitTime = rand_range(5,10)
	$CherryTimer.wait_time = waitTime
	$CherryTimer.start()

func getRandomPosition():
	return Vector2(rand_range(0,screenSize.x), rand_range(0,screenSize.y))

func _on_CherryTimer_timeout():
	if Cherry2 != null:
		var cherry = Cherry2.instance()
		cherry.position = getRandomPosition()
		add_child(cherry)
		set_cherryTime()


func _on_Player_hard():
	game_over()
