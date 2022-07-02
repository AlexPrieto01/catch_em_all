extends Node

#const
const marginScreen = 50
const screenSize = Vector2(854,480)
const controlMusic_path = "res://assets/audio/POL/POL-foggy-forest-short.wav"
const firstMainMusic_path = "res://assets/audio/POL/POL-blob-tales-short.wav"
const secondMainMusic_path = "res://assets/audio/POL/POL-jungle-hideout-short.wav"
const thirdMainsMusic_path = "res://assets/audio/POL/POL-lone-wolf-short.wav"
#Nodos
var sound = AudioStreamPlayer.new()
var musicTimer = Timer.new()
#Valores
#var actualMusic
#Solo hará nueva musica en la main.tscn
#var makeNewMusic = false 
var songsCollection = [firstMainMusic_path, secondMainMusic_path, thirdMainsMusic_path]
#Valores por default
var hard_mode = false
var release_frogs = false

func _ready():
	randomize()
	add_child(sound)
#	_timer_settings()
#	_music_settings()

func play_music(new_path):
	if !sound.playing:
		sound.stream = load(new_path)
		
		sound.play()

func stop_music():
	sound.stop()

func change_musicTo(new_path):
	sound.stop()
	play_music(new_path)

func takeRandomPath():
	return songsCollection[rand_range(0,songsCollection.size())]


