extends Semaphore

var _barrier = Semaphore.new()

var limit

func _init(limit=1):
	self.limit = limit
	for i in range (limit):
		_barrier.post()

func wait():
	_barrier.post()
	.wait()

func post():
	_barrier.wait()
	.post()

