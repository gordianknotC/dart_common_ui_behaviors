import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'singleGroupAware.g.dart';


// The store-class
abstract class _SingleGroupAware<T> with Store {
	@observable ObservableList<T> group;
	@observable ObservableList<T> activateds;
	@computed bool get hasActivatedElements => activateds.isNotEmpty;
	@computed int  get activatedElements    => activateds.length;
	@computed bool isActivated(T element) 	=> activateds.contains(element);
}

class SingleGroupAware<T> extends _SingleGroupAware<T> with _$SingleGroupAware<T>{
	static Map<String, SingleGroupAware> instances = {};
	final bool multipleAwareness;
	final String key;
	@override final ObservableList<T> group;
	@override final ObservableList<T> activateds;
	
	SingleGroupAware._({
		@required List<T> children, @required this.key,
		this.multipleAwareness = false, List<T> initialSelection
	}) :
			group = ObservableList.of(children),
			activateds = ObservableList.of(initialSelection ?? [])
	{
		if (!multipleAwareness) {
		  assert(initialSelection.length ==1, 'multiple elements is not allowed in single selection mode');
		}
	}
	
	
	factory SingleGroupAware.singleton({
		@required List<T> children, String key,
		bool multipleAwareness = false, List<T> initialSelection
	}){
		if (key == null) {
		  return SingleGroupAware._(children: children,key: key, multipleAwareness: multipleAwareness, initialSelection: initialSelection);
		}
		if (!(instances?.containsKey(key) ?? false)) {
			return instances[key] = SingleGroupAware<T>._(
					children: children,key: key, multipleAwareness: multipleAwareness, initialSelection: initialSelection
			);
		}
		return instances[T] as SingleGroupAware<T>;
	}
}
