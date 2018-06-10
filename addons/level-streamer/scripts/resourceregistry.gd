var _resources = {}
var _mu = Mutex.new()

func load_resource(filename):
	_mu.lock()
	if not filename in _resources:
		_resources[filename] = load(filename)
	_mu.unlock()
	return _resources[filename]

func unload_resource(filename):
	_mu.lock()
	_resources.erase(filename)
	_mu.unlock()
		