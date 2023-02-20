import 'dart:async';
import 'package:test/test.dart';
import 'package:ui_common_behaviors/src/common.dart';
import 'package:ui_common_behaviors/src/schedulers/base_schedulers.dart';

import 'helpers/scheduler.test.helper.dart';




void main() {
  late ScheduledFutureList futureList;
  late ScheduleTestHelper H;
  group('ScheduledTask tests', () {
    setUpAll(() {
      futureList = ScheduledFutureList.singleton();
      H = ScheduleTestHelper(futureList);
    });

    test('add schedule', () async {
      final result = "testA result";
      await H.testAsyncSchedule<String>(
        interval: 500,
        tagname: 'testA',
        result: result,
        idx: 0,
        action: () {
          return result;
        }
      );
    });

    test('execute ten tasks simultaneously expect execution peak being spread', () async {
      final interval_per_task = 60;
      final tagname = 'testB';
      final task_numbers = 20;
      final a = DateTimeExtension.envNow();
      for (var i = 0; i < task_numbers; ++i) {
        final result = '$tagname result $i';
        H.testAsyncSchedule<String>(
          interval: interval_per_task,
          tagname: tagname,
          idx: i,
          result: result,
          action: () {
            return result;
          }
        );
      }
      await H.waitPendingAsyncTests();
      final b = DateTimeExtension.envNow();

      expect(b.difference(a).inMilliseconds, greaterThan(task_numbers * interval_per_task));
    });

    /// todo: test for 驗證回傳資料
    test('test for validating future responses', () async {});
  });
}
