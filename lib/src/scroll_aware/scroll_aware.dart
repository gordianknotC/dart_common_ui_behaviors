// TODO: Put public facing types in this file.
import 'package:mobx/mobx.dart';

part 'scroll_aware.g.dart';

/// __example__:
/// ```dart
/// class ScrollControllerImpl implements ScrollControllerSketch{
///   final ScrollController controller;
///   @override double get offset => controller.offset;
/// 	ScrollControllerImpl(this.controller);
/// }
/// ```
abstract class ScrollControllerSketch {
	double get offset;
//	void addListener(void Function());
}


abstract class _ScrollAccAware<T> with Store {
	@observable double offset = 0;
	@observable double delta = 0;
	double prevOffset = 0;
	double get ratio;
	double get containerHeight;
	ScrollControllerSketch get scrollController;
	
	void onScroll() {
		double __offset = scrollController.offset;
		delta += (__offset - prevOffset) * ratio ?? 0.6;
		if (delta > containerHeight) {
			delta = containerHeight;
		} else if (delta < 0) {
			delta = 0;
		}
		prevOffset = __offset;
		offset = -delta;
		// menu?.updatePos(0, - offset);
	}
}


/// 當[scrollController]事件發生時，將改變的 [delta]/[offset] 寫入
/// ScrollAccAware 中，便於 Mobx 使用
///
/// __example__:
/// ```dart
/// class ScrollControllerImpl implements ScrollControllerSketch{
///   final ScrollController controller;
///   @override double get offset => controller.offset;
/// 	ScrollControllerImpl(this.controller);
/// }
/// class AppGeneralLayout {
///   static final ScrollController scrollController = ScrollController()
///     ..addListener(() {
///       AppGeneralLayout.scrollAwareness.onScroll();
///       _D.debug("onscroll, offset: ${scrollAwareness.offset}/${AppGeneralLayout.scrollController
///           .offset}");
///     });
///   static final ScrollAccAware scrollAwareness = ScrollAccAware(
///       appBarHeight, ScrollControllerImpl(AppGeneralLayout.scrollController));
/// }
/// ```
///
/// 這時 AppGeneralLayout.scrollAwareness 便可作為 reactive 物件使用
/// 用來偵測 AppGeneralLayout.scrollController 的變化
///
class ScrollAccAware extends _ScrollAccAware with _$ScrollAccAware{
	@override final double containerHeight;
	@override final ScrollControllerSketch scrollController;
	@override final double ratio;
	ScrollAccAware(this.containerHeight, this.scrollController, {this.ratio = 0.6});
}
