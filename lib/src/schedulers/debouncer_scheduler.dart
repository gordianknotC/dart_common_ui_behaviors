
import 'dart:async';



class DebounceCallState{
  final String name;
  dynamic extra;
  bool called = false;
  void Function() _cb;

  DebounceCallState(this._cb, this.name, {this.extra = ''});
  void call(){
    _cb();
    called = true;
  }
}



///
/// 	用於 Animation 事件駐列
///
///  [debounceTime]
///  功能視作為 Debouncer 呼叫 function 的最小間隔
///
///	 [canCall]
///  判定前後含數 是否可被呼叫，當不可被呼叫，持續於駐列中等待呼叫
///  當可以被呼叫時，呼叫該駐列function，並於呼叫後移除
///
///  [onAddCall], [onRemoveCall]
///  當新增/移除 function 時呼叫
///
class DebouncedCallStack {
  final Map<String, DebounceCallState> lastNamedCall = {};
  final List<DebounceCallState> callSequence = [];
  final int debounceTime;
  final bool Function() canCall;
  final Debouncer debouncer;
  final void Function(DebounceCallState state) onAddCall;
  final void Function(DebounceCallState state, int idx) onRemoveCall;

  int get length => callSequence.length;

  DebounceCallState get currentCall => callSequence.first;
  DebouncedCallStack(this.debounceTime, {
    required this.canCall,
    required this.onAddCall,
    required this.onRemoveCall,
  }): debouncer = Debouncer(milliseconds: debounceTime);

  void addCall(String name, void cb(),  {dynamic extra, bool duplicateGuard = false}){
    assert(name != null);
    void _run(){
      final state = lastNamedCall[name] = DebounceCallState(cb, name)..extra = extra;
      callSequence.add(state);
      onAddCall(state);
      run();
    }
    if (duplicateGuard){
      if (!lastNamedCall.containsKey(name))
        _run();
    }else{
      _run();
    }
  }

  void removeCall(DebounceCallState call){
    assert(call.name != null);
    final idx = callSequence.indexOf(call);
    assert(idx != -1, 'call idx not found');
    callSequence.removeAt(idx);
    lastNamedCall.remove(call.name);
    onRemoveCall(call, idx);
  }

  void _call(){
    if (callSequence.isEmpty)
      return;
    if (canCall()){
      currentCall.call();
      removeCall(currentCall);
      debouncer.run(action: _call);
    }else{
      debouncer.run(action: _call);
    }
  }

  Future run() async {
    debouncer.run(action: _call);
  }
}



/// tested: test/stackDebouncerTest.dart
/// [DebouncerStack]
/// [Debouncer] + Action 駐列
///
/// example:
/// dstack = DebouncerStack(milliseconds: 1000);
/// dstack.run();
/// dstack.addAction(() => notifyChanges);
/// dstack.addAction(() => notifyChangesB);
/// ...
/// 1 秒後執行並清空所有的 action
///
class DebouncerStack{
  final Debouncer delegate;
  final List<Function> actionStack = [];
  DebouncerStack({required int milliseconds})
      : delegate = Debouncer(milliseconds: milliseconds);

  void addAction(void action()){
    actionStack.add(action);
  }

  void run(){
    delegate.run(action: (){
      actionStack.forEach((_) => _());
      actionStack.clear();
    });
  }
}


/// tested:
class Debouncer {
  int milliseconds;
  late bool active;
  late Timer? _timer;
  late void Function()? action;

  Debouncer({ required this.milliseconds }){
    active = false;
  }

  bool get isBouncing {
    return active;
  }

  void update([int? time, void onCompleted()?]){
    milliseconds = time ?? milliseconds;
    if (onCompleted == null)
      run(action: action);
    else{
      final prevAction = action;
      run(action: (){
        prevAction?.call();
        onCompleted();
      });
    }
  }

  void run({required void Function()? action, void onError(StackTrace err)?}) {
    this.action = action;
    _timer?.cancel();
    if (milliseconds != null){
      active = true;
      _timer = Timer(Duration(milliseconds: milliseconds), (){
        try{
          _timer?.cancel();
          this.action?.call();
          active = false;
        }catch(e){
          onError?.call(StackTrace.fromString(e.toString()));
          active = false;
          rethrow;
        }
      });
    }
  }

  void dispose(){
    active = false;
    _timer?.cancel()	;
  }

  void cancel(){
    active = false;
    _timer?.cancel();
  }
}
