
var filename
var bounds
var transform
var count = 0

var _levels_root
var _instance
var _mu = Mutex.new()

func _init(filename, transform, bounds, levels_root):
	self.filename = filename
	self.transform = transform
	self.bounds = bounds
	self._levels_root = levels_root

func add_ref(d):
	_mu.lock()
	count += d
	_mu.unlock()

func ref():
	add_ref(1)
	
func deref():
	add_ref(-1)
	
func load_level():
	_mu.lock()
	if not _instance:
		print(count)
		var scene = load(filename)
		_instance = scene.instance()
		_instance.transform = transform
		_levels_root.add_child(_instance)
	ref()
	_mu.unlock()

func unload_level():
	_mu.lock()
	print(count)
	if count == 1:
		_levels_root.call_deferred("remove_child", _instance)
		_instance.queue_free()
		_instance = null
	deref()
	_mu.unlock()

func _is_loaded():
	_mu.lock()
	var ins = _instance
	_mu.unlock()
	return ins != null
	
	
