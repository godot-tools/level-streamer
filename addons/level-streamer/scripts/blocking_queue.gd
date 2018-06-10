
var _sem = Semaphore.new()

var _queue = []

func enqueue(val):
	_queue.push_back(val)
	_sem.post()

func dequeue():
	_sem.wait()
	return _queue.pop_front()
	