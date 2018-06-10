const BoundedSemaphore = preload("res://addons/level-streamer/scripts/boundedsemaphore.gd")

var _s = Semaphore.new()
#var _x = BoundedSemaphore.new(1)
var _x = Mutex.new()
var _h = Semaphore.new()
var _waiters = 0

var _m

func _init(lock):
	self._m = lock

func wait():
	_x.lock()
	_waiters += 1
	_x.unlock()
	_m.unlock()
	
	_s.wait()
	_h.post()
	_m.lock()
	
func post():
	_x.lock()
	if waiters > 0:
		waiters -= 1
		_s.post()
		_h.wait()
	_x.unlock()

func boradcast():
	_x.lock()
	for i in range(waiters):
		_s.post()
	while waiters > 0:
		waiters -= 1
		_h.wait()
	_x.unlock()
	
	
	
