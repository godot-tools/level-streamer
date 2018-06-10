const BlockingQueue = preload("res://addons/level-streamer/scripts/blocking_queue.gd")

var _queue = BlockingQueue.new()
var _thread = Thread.new()

func stream():
	_thread.start(self, "_stream")

func post(task):
	_queue.enqueue(task)

func _stream(data):
	while true:
		var tasks = _queue.dequeue()
		if typeof(tasks) == TYPE_ARRAY:
			for task in tasks:
				task.execute()
		elif tasks is Task:
			tasks.execute()

class Task:
	var obj
	var method
	
	func _init(obj, method):
		self.obj = obj
		self.method = method
	
	func execute():
		obj.call(method)
