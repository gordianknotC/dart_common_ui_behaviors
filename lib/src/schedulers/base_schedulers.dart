
import 'dart:async';


/// tested: test/schedule_task.test.dart
class ScheduledResult<T>{
	final String tagName;
	final Future<T> result;
	final int idx;
	ScheduledResult({required this.tagName, required this.idx, required this.result});
}

/// tested: test/schedule_task.test.dart
class ScheduledTask<T>{
	final String tagName;
	final T Function() action;
	final int interval;
	List<ScheduledTask> _schedules;

	final Completer<T> completer;
	bool							  _proceedInQueue =  false;
	bool						 get proceedInQueue => _proceedInQueue;
	ScheduledTask<T>? get nextSchedule => (index == _schedules.length - 1 ? null : _schedules[index + 1]) as ScheduledTask<T>?;
	ScheduledTask<T>? get prevSchedule => (index == 0 ? null : _schedules[index - 1]) as ScheduledTask<T>?;
	ScheduledTask<T>? get currentFlag  => (index == 0 ? null : _schedules[index - 1]) as ScheduledTask<T>?;
	int 						 get index 				=> _schedules.indexOf(this);
	bool						 get finished     => completer.isCompleted;

	ScheduledTask({required this.tagName, required this.interval, required this.action}): completer = Completer<T>(), _schedules = [];

	void setSchedules(List<ScheduledTask> schedules){
		_schedules = schedules;
	}

	ScheduledResult<T> _getResult(){
		final result = completer.future;
		return ScheduledResult(tagName: this.tagName, idx: index, result: result);
	}

	void _remove(){
		print('$tagName $index remove action');
		_schedules.remove(this);
	}

	void _clearAll(){
		final copied = List<ScheduledTask>.from(_schedules);
		for (var i = 0; i < copied.length; ++i) {
			final s = copied[i];
			if (s.finished)
				s._remove();
		}
	}

	ScheduledResult<T> _processSchedule({bool byPassCheck = false}){
		_proceedInQueue = true;
		if (index == 0 || byPassCheck){
			final _prev = prevSchedule;
			if (_prev != null){
				if (_prev.finished){
					_prev._remove();
				}else{
					if (_prev._proceedInQueue){
					}else{
						_prev._processSchedule();
					}
				}
			}

			print('$tagName $index prepare action');
			Future.delayed(Duration(milliseconds: interval), (){
				print('$tagName $index run action');
				if (T.runtimeType == Future){
					final result = (action() as Future<T>).then((_){
						completer.complete(_);
						final next = nextSchedule;
						print('$tagName $index next $next');
						if (next != null){
							next._processSchedule(byPassCheck: true);
						}else{
							_clearAll();
						}
					});
				}else{
					final result = action();
					completer.complete(result);
					final next = nextSchedule;
					print('$tagName $index next $next');
					if (next != null){
						next._processSchedule(byPassCheck: true);
					}else{
						_clearAll();
					}
				}
			});
		}

		return _getResult();
	}
}


///  ??????
///  -----------------------
///  	????????????list???????????????????????????????????????????????????????????????
/// 	??????????????? 30 ???????????????????????????????????????20ms, ???30???????????? 600 ms
///   UI????????????????????????[ScheduledFutureList] ??????????????? 30 ms ????????????
///
///   ??????????????????????????????????????????????????????????????????????????????CPU??????
///   [ScheduledFutureList] ??????????????????????????????????????????
///
///  ??????????????????????????? ??????????????????
///  ????????? CPU ??????????????????????????????????????????????????? isolate)???
///  ????????????????????????????????????CPU load time ?????????
///  ?????????????????? [ScheduledFutureList]
///
/// tested: test/schedule_task.test.dart
class ScheduledFutureList{
	static ScheduledFutureList? instance;
	final Map<String, List<ScheduledTask>> _tasks = {};

	ScheduledFutureList._();
	factory ScheduledFutureList.singleton(){
		return instance ??= ScheduledFutureList._();
	}

	ScheduledResult<T> addSchedule<T>(ScheduledTask<T> task){
		_tasks[task.tagName] ??= <ScheduledTask<T>>[];
		_tasks[task.tagName]!.add(task);
		task.setSchedules(_tasks[task.tagName]!);
		return task._processSchedule();
	}

	int getCurrentIdx(String tagname){
		assert(_tasks[tagname] != null);
		return _tasks[tagname]!.length;
	}

	Future waitForTagList(String tagname){
		assert(_tasks[tagname] != null);
		return _tasks[tagname]!.last.completer.future;
	}
}


