extends Node

var num_players = 20

var bus = "master"

var available = []  # The available players.

var queue = []  # The queue of sounds to play.
var music_queue = []  # The queue of sounds to play.

var music_player = AudioStreamPlayer.new()

var play_music = true
var play_sounds = true

var play_victory = false
var music_player_is_free = false

onready var cmi = preload("res://music/Commando_Maggots_intro.wav")
onready var cml = preload("res://music/Commando_Maggots_loop.ogg")
onready var bm = preload("res://music/Battle_Maggots.ogg")


func toggle_victory(val):
	if val == false:
		play_victory = true
		music_player_is_free = true
		music_queue = []
		music_queue.append(cmi)
		music_queue.append(cml)
	else:
		play_victory = false
		music_player_is_free = false
		music_queue = []
		play_normal_music()
		


func _input(event):
	if event.is_action_pressed("ToggleSound"):
		play_sounds = !play_sounds
	if event.is_action_pressed("ToggleMusic"):
		if play_music:
			music_player.stop()
		else:
			music_player.play()
		play_music = !play_music

func play_normal_music():
	music_player.stream = bm
	music_player.volume_db = -6
	music_player.play()

func _ready():
	# Create the pool of AudioStreamPlayer nodes.

	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus
		
	music_player = AudioStreamPlayer.new()	
	music_player.connect("finished", self, "_on_music_stream_finished")
	add_child(music_player)
	toggle_victory(false)

func _on_music_stream_finished():
	music_player_is_free = true
func _on_stream_finished(stream):
	available.append(stream)


func play(sound_path):
	if play_sounds:
		queue.append(sound_path)
	

func _process(delta):
	# Play a queued sound if any players are available.

	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
	
	if play_victory:
		if not music_queue.empty() and music_player_is_free:
			music_player.stream = music_queue.pop_front()
			music_player.play()			
			music_player_is_free = false
