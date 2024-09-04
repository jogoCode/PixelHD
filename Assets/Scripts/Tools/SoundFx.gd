extends Node

var is_activate:bool = true;
var num = 0;

var sounds = {
	"Slash" : load("res://Assets/Sounds/audio_slash.wav"),
	"G_Slash" : load("res://Assets/Sounds/audio_g_slash.wav"),
	"Impact" : load("res://Assets/Sounds/audio_impact01.wav"),
	"Roll" : load("res://Assets/Sounds//audio_roll.wav"),
	"FootSteps" : load("res://Assets/Sounds/audio_FootStep-001.wav"),
	"BloodDrop" : load("res://Assets/Sounds/audio_blood_drop.wav"),
	"BassDrop" : load("res://Assets/Sounds/audio_bassDrop.wav")
}

@onready var sound_players:Array = get_children();

func _ready():
	await  get_tree().create_timer(0.1).timeout;

func play(sound_name:String,delay:float):
	if is_activate:
		await get_tree().create_timer(delay).timeout;
		if sound_name == "Impact":
			num+=1;
		var sound_to_play = sounds[sound_name];
		if(sounds[sound_name] is Array):
			print(sounds[sound_name][0]);
			var rand = randf_range(0,sounds[sound_name].size());
			sound_to_play = sounds[sound_name][int(rand)];
		
		print(num);
		
		for sound_player in sound_players:
			if(sound_player.playing and sound_player.stream == sound_to_play):
				sound_player.volume_db -=4;
				await  get_tree().create_timer(0.04).timeout;
			if(!sound_player.playing):
				sound_player.volume_db =0;
				sound_player.stream = sound_to_play;
				sound_player.pitch_scale = randf_range(0.98,1.05);
				sound_player.play();
				return;
		printerr("To many sound play at the same time, not enought sound player");


