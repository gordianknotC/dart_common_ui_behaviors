

import '../common.dart';
import '../notifier.dart';
import 'debouncer_scheduler.dart';


///
/// note: 使用記得 dispose
/// [canPerformFutureAction] 判斷是否可執行 fetch
///     |
///     V
/// [futureAction]           fetch 實作
///     |
///     V
/// [canUpdate]              是否可 update
///     |
///     V
/// [updateAction]           update 實作
///     |
///     V
/// [updateNotifier]				 通知相應組件進行 update
///                          可使用 [updateNotifier.addListener]
///                          或 [ValueListenableBuilder] 接收相應事件
///
///  [AutoUpdateScheduler]
///  使用 Debouncer，意思是無論 schedule 幾次
///  只要在 schedulePeriod 內都只會執行一次 （第一次的 schedule）
///
class AutoUpdateScheduler{
  /// [canUpdate]
  /// 用於判斷是否可 update, 若 true, 執行 [updateAction]
  ///
  /// [canPerformFutureAction]
  /// 用於判斷是否可 futureAction, 若 true, 執行 [futureAction]
  ///
  /// [futureAction]
  /// 非同步 action, 如 fetch 一類
  ///
  /// [_autoRefreshDeBouncer]
  /// schedule update 用的 debouncer
  ///
  /// [_isRunning]
  /// 判斷是否有正在執行中的 schedule
  ///
  final bool Function() canUpdate;
  final bool Function() canPerformFutureAction;
  final Future Function() futureAction;
  final StateNotifier updateNotifier = StateNotifier(null, name: 'AutoUpdateSch');
  final Debouncer _autoRefreshDeBouncer;
  final int schedulePeriod;
  final void Function() updateAction;

  AutoUpdateScheduler({
    required this.canUpdate,
    required this.schedulePeriod,
    required this.canPerformFutureAction,
    required this.futureAction,
    required this.updateAction,
  }): _autoRefreshDeBouncer = Debouncer(milliseconds: schedulePeriod);

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  void scheduleUpdate(){
    _isRunning = true;
    _autoRefreshDeBouncer.run(action: (){
      _isRunning = false;
      if (canPerformFutureAction()){
        futureAction().then((_){
          print('perform update action(${canUpdate()}), future $_');
          if (canUpdate()){
            updateAction.call();
            updateNotifier.resetValue(false);
            updateNotifier.value = true;
          }
        }).whenComplete(scheduleUpdate);
      }else{
        scheduleUpdate();
      }
    });
  }

  void dispose(){
    _autoRefreshDeBouncer.cancel();
    updateNotifier.dispose();
    print('AutoUpdateScheduler disposed');
  }
}