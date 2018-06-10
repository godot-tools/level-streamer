tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("LevelStreamer", "Node2D", preload("res://addons/level-streamer/scripts/level_streamer.gd"), null)
	add_custom_type("StreamingVolume", "Area2D", preload("res://addons/level-streamer/scripts/streaming_volume.gd"), null)
	
func _exit_tree():
	remove_custom_type("LevelStreamer")
	remove_custom_type("StreamingVolume")