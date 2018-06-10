const BlockingQueue = preload("res://addons/level-streamer/scripts/blocking_queue.gd")
const ThreadPool = preload("res://addons/level-streamer/scripts/threadpool.gd")

var _stream_queue = BlockingQueue.new()
var _stream_thread = Thread.new()
var _waiting_queue = BlockingQueue.new()
var _monitor_thread = Thread.new()
var _thread_pool

var _active = []

func _init(pool_size=10):
	_thread_pool = ThreadPool.new(pool_size)
	_monitor_thread.start(self, "_monitor")

func stream():
	_stream_thread.start(self, "_stream")

func post(task):
	_stream_queue.enqueue(task)

func _stream(data):
	while true:
		print("waiting for task")
		var tasks = _stream_queue.dequeue()
		print(str("tasks: ", tasks))
		if typeof(tasks) == TYPE_ARRAY:
			_execute_concurrently(tasks)
		elif tasks is Task:
			tasks.execute()

func _monitor(data):
	while true:
		var monitor = _waiting_queue.dequeue()
		if not monitor.check():
			_waiting_queue.enqueue(monitor)

func _execute_concurrently(tasks):
	print("execute concurrently")
	var monitor = _monitor.new(_thread_pool)
	for task in tasks:
		var thread = _thread_pool.request()
		monitor.threads.push_back(thread)
		print(thread.start(self, "_execute_async", task))
	print("queueing monitor")
	_waiting_queue.enqueue(monitor)
	monitor.sem.wait()

func _execute_async(ctx):
	print(str("task: ", ctx.data))
	ctx.data.execute()
	ctx.close()
	print("killt")

class Task:
	var obj
	var method
	
	func _init(obj, method):
		self.obj = obj
		self.method = method
	
	func execute():
		obj.call(method)

class _monitor:
	var threads = []
	var sem = Semaphore.new()
	var _thread_pool
	
	func _init(thread_pool):
		_thread_pool = thread_pool
	
	func check():
		var ready = true
		for thread in threads:
			if thread._active:
				ready = false
				break
		if ready:
			print("ready")
			for thread in threads:
				_thread_pool.release(thread)
			sem.post()
		return ready