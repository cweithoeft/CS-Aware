
class RoundRobinList<T>  {

	num _current;
	num _listSize;
	List _list;

	RoundRobinList<T> (num initialSize) {
		_list = new List<T>(initialSize);
		_current = 0;
		_listSize = initialSize;
		return _list;
	}

	add(T value) {
		_list[_current] = value;
		_current++;
		if (_current >= _listSize) _current = 0;
	}

	Iterator<T> iterator() {
		return _list.iterator;
	}

	num length() {
		return _list.length;
	}

}