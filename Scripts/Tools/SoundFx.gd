extends Node

var is_activate:bool = true;

var sounds = {
	"Slash" : load("res://Sounds/audio_slash.mp3")
}

@onready var sound_players:Array = get_children();
func play(sound_name):
	if is_activate:
		var sound_to_play = sounds[sound_name];
		for sound_player in sound_players:
			if(!sound_player.playing):
				sound_player.stream = sound_to_play;
				sound_player.pitch_scale = randf_range(0.98,1.05);
				sound_player.play();
				return;
		printerr("To many sound play at the same time, not enought sound player");
