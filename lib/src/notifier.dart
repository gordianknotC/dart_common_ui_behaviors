// import 'dart:ui';
import 'package:mobx/mobx.dart';
import 'package:meta/meta.dart';


const _FRAME = Duration(microseconds: 16666);

class SchedulerBindingDelegate {
	static SchedulerBindingDelegate? _instance;
	static SchedulerBindingDelegate get instance => _instance ??= SchedulerBindingDelegate._();

	factory SchedulerBindingDelegate (){
		return _instance ??= SchedulerBindingDelegate._();
	}

	SchedulerBindingDelegate._();

	void addPostFrameCallback(callback) {
		Future.delayed(_FRAME).then((_){
			callback(_);
		});
	}

	void scheduleFrameCallback(callback, {bool rescheduling = false}) {
		Future.delayed(_FRAME).then((_){
			callback(_);
		});
	}
}


typedef VoidCallback = void Function();

mixin ValueChangedTracker<T>{
	bool get notifyOnInitializeOnly;

	@protected
	void Function()? get onNotify;
	
	@protected
	T? storedVal;
	T? get value => storedVal;
	
	@protected
	T? storedPrevVal;
	T? get prevValue => storedPrevVal;

	set value(T? newValue) {
		if (storedVal != null && notifyOnInitializeOnly) {
		  return;
		}
		if (storedVal == newValue) {
		  return;
		}
		storedPrevVal = storedVal;
		storedVal = newValue;
		onNotify?.call();
	}

	bool _hasReset = false;
	bool get hasReset => _hasReset;

	void resetValue(T? value){
		/// set value without notifying listeners
		storedPrevVal = storedVal;
		storedVal = value;
		_hasReset = true;
	}

	void setValue(T value, {bool forceNotify = false}){
		storedPrevVal = value;
		this.value = value;
		if (forceNotify){
			onNotify?.call();
		}
	}
}

abstract class ValueListenable<T>{
	const ValueListenable();
	void addListener(VoidCallback listener, {String? name});
	void removeListener(VoidCallback listener);
	T? get value;
	void set value(T? val);
}

abstract class IStateNotifier<T>{
	Observable<T?> get delegate;
	T? get initialValue;
	String get name;
	void addListener(VoidCallback listener, {required String name});
	void removeListener(VoidCallback listener);
	T? get value;
	void set value(T? val);
}

class StateNotifier<T>
		with ValueChangedTracker<T>
		implements ValueListenable<T>, IStateNotifier<T>
{
	@override final bool notifyOnInitializeOnly;
	@override void Function()? onNotify;
	@override T? storedVal;

	final Map<void Function(), Dispose> listenersInUse = {};
	@override final Observable<T?> delegate;
	@override final T? initialValue;
	@override final String name;

	StateNotifier(this.initialValue, {
		required this.name,
		ReactiveContext? context,
		this.notifyOnInitializeOnly = false,
		this.onNotify
	}) : delegate = Observable(initialValue, name: name, context: context),
				assert(name != null);

	@override
	void addListener(listener, {String? name}) {
		assert(name != null, 'listener name is required - StateNotifier(${this.name})');
		listenersInUse[listener]?.call();
		final dis = delegate.observe((notifier) {
			print('--- observe_$name, noti:${notifier.newValue}');
			listener();
		});
		listenersInUse[listener] = dis;
	}

	@override
	void removeListener(listener) {
		if (listenersInUse.containsKey(listener)){
			listenersInUse[listener]?.call();
			listenersInUse.remove(listener);
		}
	}

	void _setVal(T? value){
		try {
			runInAction((){
				delegate.value = value;
			});
    } catch (e, s) {
      print('[ERROR] on StateNotifier._setVal, params: f $e\n$s');
      rethrow;
    }
  }

	@override T? get value {
		if (hasReset){
			_setVal(storedVal);
			return storedVal!;
		}
		return delegate.value;
	}

	@override void set value(T? newValue) {
		if (storedVal != null && notifyOnInitializeOnly)
			return;
		if (storedVal == newValue)
			return;
		storedPrevVal = storedVal;
		storedVal = newValue;
		_setVal(newValue);
		onNotify?.call();
	}

	@override void setValue(T value, {bool forceNotify = false}){
		storedPrevVal = value;
		this.value = value;
		if (forceNotify){
			onNotify?.call();
		}
	}

	@override void resetValue(T? value){
		super.resetValue(value);
	}

	void scheduleSetValue(T value){
		resetValue(value);
		SchedulerBindingDelegate.instance.scheduleFrameCallback((timeStamp) {
			_setVal(value);
			onNotify?.call();
		});
	}


	void dispose(){
		listenersInUse.forEach((k, v){
			v();
		});
		listenersInUse.clear();
	}
}





