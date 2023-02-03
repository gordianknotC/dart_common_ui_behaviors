__outdated not recommended__

滙集一些常用的 reactive 功能，命名以後綴 Aware 作為修飾，reactive 的部份目前以 mobx 實作, dart 版本太舊，待更新 
- scrollAware
- progressAware
- pickedAware
- groupAware

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
## Usage
