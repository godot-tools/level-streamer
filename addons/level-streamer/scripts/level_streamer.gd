extends Node2D

const ResourceRegistry = preload("res://addons/level-streamer/scripts/resourceregistry.gd")
const StreamingVolume = preload("res://addons/level-streamer/scripts/streaming_volume.gd")
const Level = preload("res://addons/level-streamer/scripts/level.gd")


export(NodePath) var levels = "Levels"
export(NodePath) var volumes = "Volumes"
export var cache_resources = false

onready var _level_root = get_node(levels)
onready var _volume_root = get_node(volumes)

var _resource_registry = ResourceRegistry.new()

var _levels = []

func _ready():
	print("streamer")
	_init_levels()
	_init_volumes()

func _init_levels():
	for child in _level_root.get_children():
		if child.filename and child.has_method("get_bounds"):
			var bounds = child.get_bounds()
			if cache_resources:
				_resource_registry.load_resource(child.filename)
			_levels.push_back(Level.new(child.filename, child.transform, bounds, _level_root, cache_resources, _resource_registry))
			_level_root.remove_child(child)
			child.queue_free()
	for file in _resource_registry._resources:
		print(str(file, ": ", _resource_registry._resources[file])) 

func _init_volumes():
	
	for volume in _volume_root.get_children():
		if volume is StreamingVolume:
			for level in _levels:
				if level.bounds.intersects(volume.get_bounds()):
					volume._levels.push_back(level)
