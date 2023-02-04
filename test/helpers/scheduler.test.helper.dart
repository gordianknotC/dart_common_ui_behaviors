import 'package:test/test.dart';
import 'package:ui_common_behaviors/src/schedulers/base_schedulers.dart';
import 'package:ui_common_behaviors/src/schedulers/debouncer_scheduler.dart';

extension DateTimeExtension on DateTime {
  /// event dump 的時間
  static DateTime? _pseudoEventTime;

  /// app 初始化的時間
  static DateTime? _appInitialTime;

  ///
  static void setAppInitialTime(DateTime data) {
    _appInitialTime = data;
  }

  static void setPseudoEventTime(DateTime date) {
    _pseudoEventTime = date;
  }

  static void clearPseudoEventTime() {
    _pseudoEventTime = null;
  }

  static DateTime envNow() {
    assert(_appInitialTime != null && _pseudoEventTime != null);
    final diff = _appInitialTime!.difference(_pseudoEventTime!);
    return DateTime.now().subtract(diff);
  }

  DateTime clone() {
    return DateTime(
      this.year,
      this.month,
      this.day,
      this.hour,
      this.minute,
      this.second,
      this.millisecond,
      this.microsecond,
    );
  }
}

///
///  量測效能
///  [run]
/// 	[runAsync]
///
class Performance {
  static final Map<String, Performance> instances = {};
  late Debouncer notifyDeBouncer;
  late String tagname;
  late int diff;
  List<int> results = [];

  Performance._(this.tagname);

  factory Performance.singleton(String name, {int notifySpan = 500}) {
    if (!instances.containsKey(name))
      return instances[name] = Performance._(name)
        ..notifyDeBouncer = Debouncer(milliseconds: notifySpan);
    return instances[name]!;
  }

  void notify() {
    // _D.i(()=>'performance<$tagname> ${results.reduce((a, b) => a + b)/ results.length} / ${results.length}');
    results.clear();
  }

  Future<T> runAsync<T>(Future<T> cb()) async {
    final a = DateTimeExtension.envNow();
    final result = await cb();
    final b = DateTimeExtension.envNow();
    diff = b.difference(a).inMilliseconds;
    results.add(diff);
    notifyDeBouncer.run(action: notify);
    // _D.i(()=>'runAsync $tagname, diff: $diff');
    return result;
  }

  T run<T>(T cb()) {
    final a = DateTime.now();
    final result = cb();
    final b = DateTimeExtension.envNow();
    final diff = b.difference(a);
    results.add(diff.inMilliseconds);
    notifyDeBouncer.run(action: notify);
    // _D.i(()=>'run $tagname, diff: $diff');
    return result;
  }
}

class ScheduleTestHelper {
  final ScheduledFutureList futureList;
  final List<Future> pendingTests = [];

  ScheduleTestHelper(this.futureList);

  Future testAsyncSchedule<T>(
      {required int interval,
      required String tagname,
      required T action(),
      required String result,
      required int idx}) async {
    final task =
        ScheduledTask<T>(tagName: tagname, interval: interval, action: action);
    final schedulRes = futureList.addSchedule(task);
    expect(schedulRes.tagName, tagname, reason: "tagname should be the same");
    expect(schedulRes.idx, idx, reason: 'idx should be the same');
    expect(task.finished, false, reason: 'should not be finished');
    expect(task.proceedInQueue, true,
        reason: 'should aready be in proceed queue');
    final perf = Performance.singleton("testA");
    final fetching = perf.runAsync<T>(() {
      return schedulRes.result;
    });
    pendingTests.add(fetching);
    final fetched = await fetching;
    pendingTests.remove(fetching);
    expect(fetched, result, reason: "result should be the same");
    expect(perf.diff, greaterThanOrEqualTo(interval - 6),
        reason: "should greater than interval");
    print('perf: ${perf.diff}');
  }

  Future waitPendingAsyncTests() {
    final tests = List<Future>.from(pendingTests);
    return Future.wait(tests);
  }
}
