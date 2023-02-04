import 'dart:async';
import 'dart:math';
import 'package:test/test.dart';
import 'package:ui_common_behaviors/src/schedulers/auto_update_scheduler.dart';


final rnd = Random();
late AutoUpdateScheduler scheduler;
bool canUpdate = true;
bool canPerform = true;
int futureData = 0;
int updateData = 0;


Future wait (double second){
	return Future.delayed(Duration(milliseconds: (second * 1000).toInt()));
}

void main() {
	group('群組測試', () {
		setUpAll((){
			scheduler = AutoUpdateScheduler(
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
		});
		
		test('測試 - setVal1 test', () async {
			int prevFuture = futureData;
			int prevUpdate = updateData;
			scheduler.scheduleUpdate();
			
			/// wait for one second
			await wait(1.05);
			print('${futureData} - ${updateData}');
			expect(futureData, isNot(equals(prevFuture)));
			expect(updateData, isNot(equals(prevUpdate)));
			expect(scheduler.isRunning, isTrue);
			
			prevFuture = futureData;
			prevUpdate = updateData;
			
			await wait(1.0);
			print('${futureData} - ${updateData}');
			expect(futureData, isNot(equals(prevFuture)));
			expect(scheduler.isRunning, isTrue);
			expect(scheduler.isRunning, isTrue);
			
			prevFuture = futureData;
			prevUpdate = updateData;
			
			await wait(1.0);
			print('${futureData} - ${updateData}');
			expect(futureData, isNot(equals(prevFuture)));
			expect(scheduler.isRunning, isTrue);
			expect(scheduler.isRunning, isTrue);
			
		});
		
		
		test('常用判斷', (){
			expect(1, equals(1));
			expect(1, isNot(equals(2)));
			expect(true, isTrue);
			expect(false, isFalse);
			expect(1, lessThan(2));
			expect(2, greaterThanOrEqualTo(2));
			expect([1, 2], unorderedEquals([2, 1]));
			expect([1, 2], orderedEquals([1,2]));
			expect('hello', contains('hello'));
			expect([0, 'hello', 1, 'world'], containsAllInOrder(['hello', 'world']));
			expect(() => throw Exception(), throwsException);
		});
	});
}
