extends Node



const MUSIC_FOLDER = "res://audio/music/"
const SFX_FOLDER = "res://audio/sfx/"

var music_player : AudioStreamPlayer

var num_sfx_players = 20
var sfx_available = []  # The available players.
var sfx_queue = []  # The queue of sounds to play.


## Usage: AudioManager.play_music("Example1.wav")
func play_music(music_file:String):
	var sound_path = MUSIC_FOLDER + music_file
	music_player.stop()
	music_player.stream = load(sound_path)
	music_player.play()


## Usage: AudioManager.play_sfx("Example1.wav")
func play_sfx(sfx_file:String):
	var sound_path = SFX_FOLDER + sfx_file
	sfx_queue.append(sound_path)

## https://www.youtube.com/watch?v=QgBecUl_lFs
func install_ui(node:Node):
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(_on_ui_button_hovered)
			child.focus_entered.connect(_on_ui_button_hovered)
			child.pressed.connect(_on_ui_button_pressed)
			#child.pressed.connect(play_sfx.bind("button_pressed"))
		#elif child is LineEdit etc etc
		
		# do recursive
		install_ui(child)


func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	music_player = AudioStreamPlayer.new()
	music_player.bus = "MUSIC"
	
	for i in num_sfx_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		sfx_available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = "SFX"


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	sfx_available.append(stream)


func _process(delta):
	# Play a queued sound if any players are available.
	if not sfx_queue.empty() and not sfx_available.empty():
		sfx_available[0].stream = load(sfx_queue.pop_front())
		sfx_available[0].play()
		sfx_available.pop_front()


func _on_ui_button_hovered():
	pass
	# play click sound


func _on_ui_button_pressed():
	pass
	# play click sound