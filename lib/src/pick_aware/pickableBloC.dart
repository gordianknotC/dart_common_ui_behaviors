import 'package:mobx/mobx.dart';

// Include generated file
part 'pickableBloC.g.dart';

/*
*
* 				R E A C T     S T A T E M A N A G E R ..
*
*
* */

class PickableReact<T> extends _PickableReact<T> with _$PickableReact<T>{
	static Map<Type, PickableReact> instances = {};
	
	PickableReact();
	
	factory PickableReact.F(T element){
		instances ??= {};
		if (!(instances?.containsKey(T) ?? false)) {
		  return instances[T] = PickableReact<T>();
		}
		return instances[T] as PickableReact<T>;
	}
}


// The store-class
abstract class _PickableReact<T> with Store {
	@observable ObservableList<T> picked = ObservableList.of([]);
	@computed bool get hasPickedUp => picked.isNotEmpty;
	@computed int  get pickedElements => picked.length;
}


class SavedAwarePickable {
	PickableReact<bool> assignedReact;
	PickableReact<bool> savedReact;
	PickableReact<bool> modifiedReact;
	PickableReact<bool> uploadedReact;
	// ---------------------------------------
	Computed<bool> canShowContent;
	Computed<bool> canShowDefects;
	Computed<bool> canSave 			 ;
	Computed<bool> saved   			 ;
	Computed<bool> canUpload 		 ;
	Computed<bool> modified 		 ;
	// ---------------------------------------
	SavedAwarePickable (this.assignedReact, this.savedReact, this.uploadedReact){
		canShowContent = Computed(_canShowContent);
		canShowDefects = Computed(_canShowDefects);
		canSave 			 = Computed(_canSave);
		saved 			   = Computed(_saved);
		canUpload 		 = Computed(_canUpload);
		modifiedReact = PickableReact<bool>();
		modified      = Computed(_modified);
	}
	
	bool _canShowContent()=> assignedReact.hasPickedUp;
	bool _canShowDefects()=> assignedReact.hasPickedUp;
	bool _canSave       ()=> _canShowDefects() && !_saved();
	bool _saved         ()=> savedReact.hasPickedUp;
	bool _canUpload     ()=> _canShowDefects() && _saved();
	bool _modified      ()=> assignedReact.hasPickedUp && modifiedReact.hasPickedUp;
	
	void setPatrolAssigned(){
		assignedReact.picked.clear();
		assignedReact.picked.add(true);
		if (saved.value) {
		  setModified();
		}
	}
	void setSaved(){
		savedReact.picked.clear();
		savedReact.picked.add(true);
		modifiedReact.picked.clear();
	}
	void setUpload(){
		uploadedReact.picked.clear();
		uploadedReact.picked.add(true);
	}
	void setModified(){
		savedReact.picked.clear();
		uploadedReact.picked.clear();
		modifiedReact.picked.clear();
		modifiedReact.picked.add(true);
	}

  void setReset() {
		assignedReact.picked.clear();
		savedReact.picked.clear();
		uploadedReact.picked.clear();
		modifiedReact.picked.clear();
	}
}


