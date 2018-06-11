extends Node2D

const StreamingVolume = preload("res://addons/level-streamer/scripts/streaming_volume.gd")
const Level = preload("res://addons/level-streamer/scripts/level.gd")

export(NodePath) var target
export(NodePath) var levels = "Levels"
export(NodePath) var volumes = "Volumes"
export var cache_resources = false

onready var _target = get_node(target)
onready var _level_root = get_node(levels)
onready var _volume_root = get_node(volumes)

var _resource_cache = {}

var _levels = []

func _ready():
	_init_levels()
	_init_volumes()

func _init_levels():
	for child in _level_root.get_children():
		if child.filename and child.has_method("get_bounds"):
			var bounds = child.get_bounds()
			var resource
			if cache_resources:
				resource = load(child.filename)
				_resource_cache[child.filename] = resource
			_levels.push_back(Level.new(child.filename, child.transform, bounds, _level_root, resource))
			_level_root.remove_child(child)
			child.queue_free()

func _init_volumes():
	for volume in _volume_root.get_children():
		if volume is StreamingVolume:
			volume._target = _target
			for level in _levels:
				if level.bounds.intersects(volume.get_bounds()):
					volume._levels.push_back(level)
