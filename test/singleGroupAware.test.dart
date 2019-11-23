import 'package:behaviors/behaviors.dart';
import 'package:behaviors/src/group_aware/singleGroupAware.dart';
import 'package:test/test.dart';

void main() {
	group('SingleGroupAwareness tests', () {
		SingleGroupAware single_awareness;
		SingleGroupAware multi_awareness;
		final List<String> data = [
			'one', 'two', 'three', 'four'
		];
		
		setUpAll(() {
			single_awareness 	= SingleGroupAware.singleton(children: data, key: '#12345', multipleAwareness: false, initialSelection: ['one']);
			multi_awareness 	= SingleGroupAware.singleton(children: data, key: '#3333', multipleAwareness: true, initialSelection: ['one', 'two']);
		});
		
		group('single selection tests', (){
			test('initial test, expect "one" activated and "two" inactivated', (){
				expect(single_awareness.isActivated('one'), isTrue);
				expect(single_awareness.isActivated('two'), isFalse);
			});
			
			test('activate "two", expect previous "one" inactivated and "two" activated', (){
				single_awareness.activate(['two']);
				expect(single_awareness.isActivated('two'), isTrue);
				expect(single_awareness.isActivated('one'), isFalse);
				
			});
		});
		
		group('multi selections tests', (){
			test('initial test, expect "one" and "two" are activated', (){
				expect(multi_awareness.isActivated('one'), isTrue);
				expect(multi_awareness.isActivated('two'), isTrue);
			});
			
			test('activate three, expect both "three" and previous x are activated', (){
				multi_awareness.activate(['three']);
				expect(multi_awareness.isActivated('three'), isTrue);
				expect(multi_awareness.isActivated('two'), isTrue);
				expect(multi_awareness.isActivated('one'), isTrue);
			});
		});
	});
}
