extends Area2D

const Streamer = preload("res://addons/level-streamer/scripts/streamer.gd")

var _target
var _shape
var _levels = []
var _streamer = Streamer.new()

func get_bounds():
	if not _shape:
		return Rect2()
	return Rect2(position, _shape.extents*2)

func _ready():
	_init_shape()
	_streamer.stream()
	connect("body_entered", self, "_body_entered")
	connect("body_exited", self, "_body_exited")

func _process(delta):
	_streamer._tick()

func _init_shape():
	for child in get_children():
		if child is CollisionShape2D:
			if child.shape is RectangleShape2D:
				_shape = child.shape
				break

func _body_entered(body):
	if body == _target:
		var tasks = []
		for level in _levels:
			var task = Streamer.Task.new(level, "load_level")
			tasks.push_back(task)
		_streamer.post(tasks)

func _body_exited(body):
	if body == _target:
		var tasks = []
		for level in _levels:
			var task = Streamer.Task.new(level, "unload_level")
			tasks.push_back(task)
		_streamer.post(tasks)