import 'package:test/test.dart';
import 'package:ui_common_behaviors/src/common.dart';
import 'package:ui_common_behaviors/src/schedulers/debouncer_scheduler.dart';


Future wait(int t){
	return Future.delayed(Duration(milliseconds: t));
}



void main(){
	bool canCal = false;
	int addedCounter = 0;
	
	void onAddCall(DebounceCallState s){
		addedCounter ++;
	}
	void onRemoveCall( DebounceCallState s, idx){
	
	}
	final stack = DebouncedCallStack(
		30,
		canCall: () => canCal,
		onAddCall: onAddCall,
		onRemoveCall: onRemoveCall,
	);
	
	group('Debouncer tests', (){
		// InPlayMatchesManager mgr;
		// setUpAll((){
		// 	mgr = InPlayMatchesManager.singleton();
		// });
		// test('fetchDate ', () async {
		// 	var res1 = mgr.fetchDateMatchesWithDeBouncer(0);
		// 	await wait(100);
		// 	var res2 = mgr.fetchDateMatchesWithDeBouncer(0);
		// 	await wait(100);
		// 	var res3 = mgr.fetchDateMatchesWithDeBouncer(0);
		// 	await wait(100);
		// 	await res1;
		// 	await res2;
		// 	await res3;
		// 	expect(res1, equals(res2));
		// 	expect(res2, equals(res3));
		//
		// 	var resL1 = mgr.fetchDateMatchesWithDeBouncer(1);
		// 	await wait(100);
		// 	var resL2 = mgr.fetchDateMatchesWithDeBouncer(1);
		// 	await wait(100);
		// 	var resL3 = mgr.fetchDateMatchesWithDeBouncer(1);
		// 	await wait(100);
		// 	expect(resL1, equals(resL2));
		// 	expect(resL2, equals(resL3));
		// });
		// test('call five times', () async {
		// 	int called = 0;
		// 	final name = 'firstCall';
		// 	canCal = true;
		//
		// 	for (var i = 0; i < 5; ++i) {
		// 		stack.addCall(name, (){
		// 			canCal = false;
		// 			called ++;
		// 			print(called);
		// 		});
		// 		canCal = false;
		// 	}
		// 	expect(addedCounter, 5);
		//
		// 	await wait(500);
		// 	canCal = true;
		// 	await wait(30);
		// 	expect(called, 1);
		// 	expect(stack.callSequence.length, 4);
		//
		// 	await wait(500);
		// 	canCal = true;
		// 	await wait(30);
		// 	expect(called, 2);
		// 	expect(stack.callSequence.length, 3);
		//
		// 	await wait(500);
		// 	canCal = true;
		// 	await wait(30);
		// 	expect(called, 3);
		// 	expect(stack.callSequence.length, 2);
		//
		// 	await wait(500);
		// 	canCal = true;
		// 	await wait(30);
		// 	expect(called, 4);
		// 	expect(stack.callSequence.length, 1);
		//
		// 	await wait(500);
		// 	canCal = true;
		// 	await wait(30);
		// 	expect(called, 5);
		// 	expect(stack.callSequence.length, 0);
		// });
	});
}
