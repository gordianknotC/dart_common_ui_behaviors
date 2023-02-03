import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
part 'single_group_aware.g.dart';

const _singleError = 'multiple elements is not allowed in single selection mode';
const _memberError = 'activated element is not in member of the group';


// The store-class
abstract class _SingleGroupAware<T> with Store {
	bool multipleAwareness;
	@observable ObservableList<T> group;
	@observable ObservableList<T> prevActivated;
	@observable ObservableList<T> activateds;
	@computed bool get hasActivatedElements => activateds.isNotEmpty;
	@computed int  get activatedElements    => activateds.length;
	@computed ObservableList<T> get property_activations => activateds;
	
	bool isStateChanged(T element){
		if (prevActivated.contains(element)){
			return !isActivated(element);
		}else{
			return isActivated(element);
		}
	}
	
	bool isActivated(T element) 	=> activateds.contains(element);
	
// ignore: unused_element
	List<T> _inferDisactivated(List<T> elements){
		if (elements.isEmpty || activateds.isEmpty){
			return <T>[];
		}
		if (elements.every((e) => activateds.contains(e))) {
		  return <T>[];
		}
		final _prev = activateds.toList();
		final _new  = elements;
		return _prev.where((p) => !_new.contains(p)).toList();
	}
	
	void _setActivations(List<T> elements){
		if (!elements.every((e) => activateds.contains(e))){
			prevActivated.clear();
			prevActivated.addAll(activateds.toList());
		}
		activateds.clear();
		activateds.addAll(elements);
	}
	void setActivations(List<T> elements){
		if (multipleAwareness){
			_multiGuard(elements);
			_setActivations(elements);
		}else{
			_singleGuard(elements);
			_setActivations(elements);
		}
	}
	
	void _singleGuard(List<T> elements){
		assert(elements.length <= 1, _singleError);
		assert(group.any((g) => elements.contains(g)), _memberError);
	}
	
	void _multiGuard(List<T> elements){
		assert(group.any((g) => elements.contains(g)), _memberError);
	}
}


class SingleGroupAware<T> extends _SingleGroupAware<T> with _$SingleGroupAware<T>{
	static Map<String, SingleGroupAware> instances = {};
	final String key;
	@override final bool multipleAwareness; // ignore: overridden_fields
	@override ObservableList<T> group; // ignore: overridden_fields
	@override ObservableList<T> activateds; // ignore: overridden_fields
	@override ObservableList<T> prevActivated; // ignore: overridden_fields
	
	
	SingleGroupAware._({
		@required List<T> children, @required this.key,
		this.multipleAwareness = false, List<T> initialSelection
	}) :
		group 				= ObservableList.of(children),
		activateds 	= ObservableList.of(initialSelection ?? []),
		prevActivated = ObservableList.of([])
	{
		if (!multipleAwareness) {
		  assert(activateds.length <= 1, _singleError);
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
		return instances[key] as SingleGroupAware<T>;
	}
}


abstract class SingleGroupAwareWidgetSketch<T>{
//	ObservableList<T>    Function() property_activations;
//	bool Function(T 		  elements) isActivated;
//	void Function(List<T> elements) setActivations;
	SingleGroupAware<T> Function() awareness;
}