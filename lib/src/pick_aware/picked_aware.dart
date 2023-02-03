import 'package:mobx/mobx.dart';

// Include generated file
part 'picked_aware.g.dart';

/*
*
* 				R E A C T     S T A T E M A N A G E R ..
*
*
* */

class PickedAware<T> extends _PickedAware<T> with _$PickableAware<T>{
	static Map<Type, PickedAware> instances = {};
	
	PickedAware();
	
	factory PickedAware.F(T element){
		instances ??= {};
		if (!(instances?.containsKey(T) ?? false)) {
		  return instances[T] = PickedAware<T>();
		}
		return instances[T] as PickedAware<T>;
	}
}


// The store-class
abstract class _PickedAware<T> with Store {
	@observable ObservableList<T> picked = ObservableList.of([]);
	@computed bool get hasPickedUp => picked.isNotEmpty;
	@computed int  get pickedElements => picked.length;
}


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


