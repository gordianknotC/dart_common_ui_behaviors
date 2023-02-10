__outdated not recommended__

滙集一些常用的 reactive 功能，命名以後綴 Aware 作為修飾，reactive 的部份目前以 mobx 實作, dart 版本太舊，待更新 

## todos
- [V] 更新 dart sdk
- [ ] 更新單元測試

## 目錄
- [ScrollAccAware](#ScrollAccAware)
- [SingleProgressAware](#SingleProgressAware)
- [PickedAware](#PickedAware)
- [AutoUpdateScheduler](#AutoUpdateScheduler)
- [ScheduledFutureList](#ScheduledFutureList)
- debouncer
- notifiers

### ScrollAccAware
偵測 ScrollController 變化
```dart
class ScrollControllerImpl implements ScrollControllerSketch{
  final ScrollController controller;
  @override double get offset => controller.offset;
	ScrollControllerImpl(this.controller);
}
class AppGeneralLayout {
  static final ScrollController scrollController = ScrollController()
    ..addListener(() {
      AppGeneralLayout.scrollAwareness.onScroll();
      _D.debug("onscroll, offset: ${scrollAwareness.offset}/${AppGeneralLayout.scrollController
          .offset}");
    });
  static final ScrollAccAware scrollAwareness = ScrollAccAware(
      appBarHeight, ScrollControllerImpl(AppGeneralLayout.scrollController));
}
/// 這時 AppGeneralLayout.scrollAwareness 便可作為 reactive 物件使用
/// 用來偵測 AppGeneralLayout.scrollController 的變化
```

### SingleProgressAware
偵測 Progress 變化
```dart
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
```

### PickedAware
#### Usage
```dart
Thumbnail thumb;
final pickable = PickedAware.F(element);
pickable.picked.add(thumb);
pickable.picked.remove(thumb);
picable.hasPickedUp;
```
#### 應用，偵測可否儲存
```dart
class SavedAwareOnPickedDetection {
	PickedAware<bool> assignedOrNot;
	PickedAware<bool> savedOrNot;
	PickedAware<bool> modifiedOrNot;
	PickedAware<bool> uploadedOrNot;
	// ---------------------------------------
	Computed<bool> canShowContent;
	Computed<bool> canShowDefects;
	Computed<bool> canSave 			 ;
	Computed<bool> saved   			 ;
	Computed<bool> canUpload 		 ;
	Computed<bool> modified 		 ;
	// ---------------------------------------
	SavedAwareOnPickedDetection (this.assignedOrNot, this.savedOrNot, this.uploadedOrNot){
		canShowContent = Computed(_canShowContent);
		canShowDefects = Computed(_canShowDefects);
		canSave 			 = Computed(_canSave);
		saved 			   = Computed(_saved);
		canUpload 		 = Computed(_canUpload);
		modifiedOrNot = PickedAware<bool>();
		modified      = Computed(_modified);
	}
	
	bool _canShowContent()=> assignedOrNot.hasPickedUp;
	bool _canShowDefects()=> assignedOrNot.hasPickedUp;
	bool _canSave       ()=> _canShowDefects() && !_saved();
	bool _saved         ()=> savedOrNot.hasPickedUp;
	bool _canUpload     ()=> _canShowDefects() && _saved();
	bool _modified      ()=> assignedOrNot.hasPickedUp && modifiedOrNot.hasPickedUp;
	
	void setPatrolAssigned(){
		assignedOrNot.picked.clear();
		assignedOrNot.picked.add(true);
		if (saved.value) {
		  setModified();
		}
	}
	void setSaved(){
		savedOrNot.picked.clear();
		savedOrNot.picked.add(true);
		modifiedOrNot.picked.clear();
	}
	void setUpload(){
		uploadedOrNot.picked.clear();
		uploadedOrNot.picked.add(true);
	}
	void setModified(){
		savedOrNot.picked.clear();
		uploadedOrNot.picked.clear();
		modifiedOrNot.picked.clear();
		modifiedOrNot.picked.add(true);
	}

  void setReset() {
		assignedOrNot.picked.clear();
		savedOrNot.picked.clear();
		uploadedOrNot.picked.clear();
		modifiedOrNot.picked.clear();
	}
}

```

### AutoUpdateScheduler
```
[canPerformFutureAction] 判斷是否可執行 fetch
    |
    V
[futureAction]           fetch 實作
    |
    V
[canUpdate]              是否可 update
    |
    V
[updateAction]           update 實作
    |
    V
[updateNotifier]				 通知相應組件進行 update
                         可使用 [updateNotifier.addListener]
                         或 [ValueListenableBuilder] 接收相應事件

 [AutoUpdateScheduler]
 使用 Debouncer，意思是無論 schedule 幾次
 只要在 schedulePeriod 內都只會執行一次 （第一次的 schedule）
```
> source
```dart
class AutoUpdateScheduler {
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
}
```

#### Example
```dart
final scheduler = AutoUpdateScheduler(
    canUpdate: () => canUpdate,
    canPerformFutureAction: () => canPerform,
    futureAction: () {
        futureData = rnd.nextInt(10000);
        return Future.value(futureData);
    },
    updateAction: () {
        updateData = futureData;
        print('update action $updateData');
    },
    schedulePeriod: 1000,
);
scheduler.scheduleUpdate()
```

### ScheduledFutureList
```
///  說明
///  -----------------------
///  	指定處理list內單筆資料的間隔時間，以簡易達成分散式處理
/// 	如一次載入 30 筆影像，若載入一筆影像需要20ms, 則30筆就需要 600 ms
///     UI可能會頓個半秒，[ScheduledFutureList] 可指定每隔 30 ms 載入一個
///
///   若單筆資料太大，如存取大檔案所造成的延遲，請另開一個CPU線程
///   [ScheduledFutureList] 無法處理這一類負載過大的問題
///
///  主要用於分散式處理 （非多線程）
///  因使用 CPU 線程會需要額外的操作（自建獨立環境 isolate)，
///  當同時處理太多小資料，使CPU load time 太重高
///  這時就可以用 [ScheduledFutureList]
///  
```

> source
```dart
class ScheduledResult<T>{
  final String tagName;
  final Future<T> result;
  final int idx;
  ScheduledResult({required this.tagName, required this.idx, required this.result});
}
class ScheduleFutureList {
  ScheduledResult<T> addSchedule<T>(ScheduledTask<T> task){  }
}
```

#### Example
```dart
final futureList = ScheduledFutureList.singleton();
final task1 = ScheduledTask<T>(tagName: tagname, interval: interval, action: action);
final task2 = ScheduledTask<T>(tagName: tagname, interval: interval, action: action);
final scheduledResult1 = futureList.addSchedule(task1);
final scheduledResult2 = futureList.addSchedule(task2);
```





[autoupdate-test]: ./test/io.cmd.test.dart
[bhaviors-test]: ./test/io.codec.test.dart
[dbouncer-test]: ./test/io.glob.test.dart
[schedule-test]: ./test/io.logger.test.dart
[group_aware-test]: ./test/fileio.test.dart
[portfolio]: https://gordianknotC.github.io/portfolio2019Fl



