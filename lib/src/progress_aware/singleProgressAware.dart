import 'package:mobx/mobx.dart';
import 'package:meta/meta.dart';

part 'singleProgressAware.g.dart';


// The store-class
abstract class _SingleProgressAware<T> with Store {
	@observable double total;
	@observable double current;
	
	@computed bool get isInitialized 	=> total != null;
	@computed bool get isStarted 			=> current != null;
	@computed bool get isFinished 		=> current >= total;
	
	@computed double get property_progress => current / total;
}

class SingleProgressAware<T> extends _SingleProgressAware<T> with _$SingleProgressAware<T>{
	SingleProgressAware({@required double total, double current}){
		this.total = total;
		this.current = current;
	}
}

