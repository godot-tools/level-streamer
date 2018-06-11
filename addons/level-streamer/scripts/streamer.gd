const BlockingQueue = preload("res://addons/level-streamer/scripts/blocking_queue.gd")

var _queue = BlockingQueue.new()
var _thread = Thread.new()

var _main_thread_queue = []

func stream():
	_thread.start(self, "_stream")

func post(task):
	_queue.enqueue(task)

func _tick():
	var task = _main_thread_queue.pop_front()
	if task:
		task.execute()
		pass

func _stream(data):
	while true:
		var tasks = _queue.dequeue()
		
		if typeof(tasks) == TYPE_ARRAY:
			for task in tasks:
				task.execute(_main_thread_queue)
		elif tasks is Task:
			tasks.execute(_main_thread_queue)

class Task:
	var obj
	var method
	
	func _init(obj, method):
		self.obj = obj
		self.method = method
	
	func execute(param=null):
		if param != null:
			obj.call(method, param)
		else:
			obj.call(method)
