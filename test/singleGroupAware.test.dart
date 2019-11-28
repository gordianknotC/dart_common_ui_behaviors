import 'package:behaviors/behaviors.dart';
import 'package:behaviors/src/group_aware/singleGroupAware.dart';
import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
	group('SingleGroupAwareness tests', () {
		SingleGroupAware single_awareness;
		SingleGroupAware multi_awareness;
		SingleProgressAware pg_awareness;
		final List<String> data = [
			'one', 'two', 'three', 'four'
		];
		
		setUpAll(() {
			SingleGroupAware.singleton(children: data, key: '#12343125', multipleAwareness: false);
			single_awareness 	= SingleGroupAware.singleton(children: data, key: '#12345', multipleAwareness: false, initialSelection: ['one']);
			multi_awareness 	= SingleGroupAware.singleton(children: data, key: '#3333', multipleAwareness: true, initialSelection: ['one', 'two']);
			pg_awareness = SingleProgressAware(total: 111, current: 0);
			
			single_awareness.property_activations;
			reaction((_) => single_awareness.activateds,
				(msg) => print("on group chaged: $msg"))();
			
			reaction((_) => single_awareness.property_activations,
				(msg) => print("on property chaged: $msg"))();
			
		});
		
		group('single selection tests', (){
			test('initial test, expect "one" activated and "two" inactivated', (){
				expect(single_awareness.isActivated('one'), isTrue);
				expect(single_awareness.isActivated('two'), isFalse);
				
				expect(single_awareness.isStateChanged('one'), isTrue);
				expect(single_awareness.isStateChanged('two'), isFalse);
				expect(single_awareness.isStateChanged('three'), isFalse);
				
				pg_awareness.current = 11;
				expect(pg_awareness.property_progress, 11/111);
			});
			
			test('activate "two", expect previous "one" inactivated and "two" activated', (){
				single_awareness.setActivations(['two']);
				
				expect(single_awareness.isActivated('two'), isTrue);
				expect(single_awareness.isActivated('one'), isFalse);
				
				expect(single_awareness.isStateChanged('one'), isTrue);
				expect(single_awareness.isStateChanged('two'), isTrue);
				expect(single_awareness.isStateChanged('three'), isFalse);
			});
		});
		
		group('multi selections tests', (){
			test('initial test, expect "one" and "two" are activated', (){
				expect(multi_awareness.isActivated('one'), isTrue);
				expect(multi_awareness.isActivated('two'), isTrue);
			});
			
			test('activate one, two, three, expect both "three" and previous x are activated', (){
				multi_awareness.setActivations(['one', 'two', 'three']);
				expect(multi_awareness.isActivated('three'), isTrue);
				expect(multi_awareness.isActivated('two'), isTrue);
				expect(multi_awareness.isActivated('one'), isTrue);
				
				expect(multi_awareness.isStateChanged('one'), isFalse);
				expect(multi_awareness.isStateChanged('two'), isFalse);
				expect(multi_awareness.isStateChanged('three'), isTrue);
			});
			
			test('activate three only', (){
				multi_awareness.setActivations([ 'three']);
				expect(multi_awareness.isActivated('three'), isTrue);
				expect(multi_awareness.isActivated('two'), isFalse);
				expect(multi_awareness.isActivated('one'), isFalse);
				
				expect(multi_awareness.isStateChanged('one'), isTrue);
				expect(multi_awareness.isStateChanged('two'), isTrue);
				expect(multi_awareness.isStateChanged('three'), isTrue);
			});
			
		});
	});
}
