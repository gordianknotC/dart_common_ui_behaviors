import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
part 'singleGroupAware.g.dart';

const _singleError = 'multiple elements is not allowed in single selection mode';
const _memberError = 'activated element is not in member of the group';


// The store-class
abstract class _SingleGroupAware<T> with Store {
	bool multipleAwareness;
	@observable ObservableList<T> _group;
	@observable ObservableList<T> _activateds;
	@computed bool get hasActivatedElements => _activateds.isNotEmpty;
	@computed int  get activatedElements    => _activateds.length;
	
	bool isActivated(T element) 	=> _activateds.contains(element);
	void activate(List<T> elements){
		if (multipleAwareness){
			_multiGuard(elements);
			_activateds.addAll(elements);
		}else{
			_singleGuard(elements);
			_activateds.clear();
			_activateds.addAll(elements);
		}
	}
	
	void _singleGuard(List<T> elements){
		assert(elements.length == 1, _singleError);
		assert(_group.any((g) => elements.contains(g)), _memberError);
	}
	
	void _multiGuard(List<T> elements){
		assert(_group.any((g) => elements.contains(g)), _memberError);
	}
}

class SingleGroupAware<T> extends _SingleGroupAware<T> with _$SingleGroupAware<T>{
	static Map<String, SingleGroupAware> instances = {};
	final String key;
	@override final bool multipleAwareness;
	@override ObservableList<T> _group;
	@override ObservableList<T> _activateds;
	
	SingleGroupAware._({
		@required List<T> children, @required this.key,
		this.multipleAwareness = false, List<T> initialSelection
	}) :
			_group = ObservableList.of(children),
			_activateds = ObservableList.of(initialSelection ?? [])
	{
		if (!multipleAwareness) {
		  assert(initialSelection.length ==1, _singleError);
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
