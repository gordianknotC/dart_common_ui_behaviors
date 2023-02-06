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
	});
}
