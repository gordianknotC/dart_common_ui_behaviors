import 'package:mobx/mobx.dart';
import 'package:meta/meta.dart';

part 'single_progress_aware.g.dart';



abstract class _SingleProgressAware<T> with Store {
	@observable double total;
	@observable double current;
	
	@computed bool get isInitialized 	=> total != null;
	@computed bool get isStarted 			=> current != null;
	@computed bool get isFinished 		=> current >= total;
	
	@computed double get progress => current / total;
}

///
/// [total] 資料總長度
/// [current] 當前長度
/// [isStarted] 是否開始
/// [isFinished] 是否結束
/// [progress] progress 0~1
///
class SingleProgressAware<T> extends _SingleProgressAware<T> with _$SingleProgressAware<T>{
	SingleProgressAware({@required double total, double current}){
		this.total = total;
		this.current = current;
	}
}

