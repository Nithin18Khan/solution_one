import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solution_one/main.dart';

class AppPageIndicator extends StatefulWidget {
  const AppPageIndicator({
    Key? key,
    required this.count,
    required this.controller,
    this.onDotPressed,
    this.color,
    this.dotSize,
    String? semanticPageTitle,
  })  : semanticPageTitle = semanticPageTitle ?? 'page',
        super(key: key);
  final int count;
  final PageController controller;
  final void Function(int index)? onDotPressed;
  final Color? color;
  final double? dotSize;
  final String semanticPageTitle;

  @override
  State<AppPageIndicator> createState() => _AppPageIndicatorState();
}

class _AppPageIndicatorState extends State<AppPageIndicator> {
  final _currentPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handlePageChanged);
  }

  int get _controllerPage => _currentPage.value;

  void _handlePageChanged() {
    _currentPage.value = widget.controller.page!.round();
  }

  String appPageSemanticSwipe(Object pageTitle, Object total, Object count) {
    return '$pageTitle $count of $total.';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.transparent,
        height: 30,
        alignment: Alignment.center,
        child: ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (_, value, child) {
              return Semantics(
                  liveRegion: true,
                  focusable: false,
                  readOnly: true,
                  label: appPageSemanticSwipe(
                    widget.semanticPageTitle,
                    (_controllerPage % (widget.count) + 1),
                    widget.count,
                  ),
                  child: Container());
            }),
      ),
      Positioned.fill(
        child: Center(
          child: ExcludeSemantics(
            child: SmoothPageIndicator(
              controller: widget.controller,
              count: widget.count,
              onDotClicked: widget.onDotPressed,
              effect: ExpandingDotsEffect(
                  dotWidth: widget.dotSize ?? 6,
                  dotHeight: widget.dotSize ?? 6,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: (widget.dotSize ?? 6) / 2,
                  dotColor: widget.color ?? $styles.colors.accent1,
                  activeDotColor: widget.color ?? $styles.colors.accent1,
                  expansionFactor: 2),
            ),
          ),
        ),
      ),
    ]);
  }
}
