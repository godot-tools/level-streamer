var _threads = []
var _sem = Semaphore.new()
var _mu = Mutex.new()

func _init(size=2):
	print(size)
	for i in range(size):
		var t = PooledThread.new(i)
		_threads.push_back(t)
		_sem.post()

func request():
	_sem.wait()
	print("requesting")
	var thread
	_mu.lock()
	for t in _threads:
		if not t.locked:
			t.lock()
			thread = t
			break
		print("lock tried")
	_mu.unlock()
	print(thread)
	return thread
	
func release(thread):
	print("waiting for finish ", thread.get_id())
	#var ret = OK
	var ret = thread.wait_to_finish()
	thread.release()
	_sem.post()
	return ret
	
class PooledThread extends Thread:	
	var _mu = Mutex.new()
	var id
	var locked = false
	var _active = false
	
	func start(instance, method, data=null, pri=1):
		print("start")
		_active = true
		var ctx = _ctx.new()
		ctx._thread = self
		ctx.data = data
		print("starting")
		return .start(instance, method, ctx, pri)
	
	func _init(id):
		self.id = id
	
	func lock():
		if not locked:
			_mu.lock()
			locked = true
	
	func release():
		if locked:
			_mu.unlock()
			locked = false
	
	func finish():
		_active = false
	
	class _ctx:
		var _thread
		var data
		
		func close():
			_thread.finish()