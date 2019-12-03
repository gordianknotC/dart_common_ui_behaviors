// TODO: Put public facing types in this file.
import 'package:mobx/mobx.dart';

part 'scroll_show_hide_aware.g.dart';

abstract class ScrollControllerSketch {
	double get offset;
//	void addListener(void Function());
}


abstract class _ScrollAccAware<T> with Store {
	@observable double offset = 0;
	@observable double delta = 0;
	double prevOffset = 0;
	double get containerHeight;
	ScrollControllerSketch get scrollController;
	
	void onScroll() {
		double __offset = scrollController.offset;
		delta += (__offset - prevOffset) * 0.6;
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

class ScrollAccAware extends _ScrollAccAware with _$ScrollAccAware{
	@override final double containerHeight;
	@override final ScrollControllerSketch scrollController;
	ScrollAccAware(this.containerHeight, this.scrollController);
}
