

import '../notifier.dart';

/// untested:
class TaskScheduler {
  final Map<int, void Function()> callbacks = {};
  final List<Future Function()> _cbsList = [];
  final StateNotifier<int> performedReporter = StateNotifier(null, name: 'TaskSch');
  final int decay;

  TaskScheduler({this.decay = 0}){
    performedReporter.addListener(_onTaskPerformed);
  }

  void _removeCb({int? id}){
    if (id == null){
      final first = _cbsList.first;
      _cbsList.remove(first);
      callbacks.removeWhere((k, v) => v == first);
    }else{
      final rec = callbacks[id];
      _cbsList.remove(rec);
      callbacks.removeWhere((k,v) => v == rec);
    }
  }

  void _onTaskPerformed(){
    final id = performedReporter.value;
    _removeCb(id: id);
  }

  Future addTasks(List<Future Function()> callbacks){
    _cbsList.addAll(callbacks);
    callbacks.forEach((_){
      this.callbacks[_.hashCode] = _;
    });
    return _perform();
  }

  Future _perform(){
    if (_cbsList.isEmpty)
      return Future.value(true);
    return _cbsList.first.call().then((_){
      _removeCb();
      return _perform();
    });
  }
}

