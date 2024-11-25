import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:solution_one/assets.dart';
import 'package:solution_one/main.dart';
import 'package:solution_one/router.dart';
import 'package:solution_one/view_model/app_haptics.dart';
import 'package:solution_one/view_model/buttons/app_icons.dart';
import 'package:solution_one/view_model/buttons/color_utilis.dart';
import 'package:solution_one/view_model/buttons/static_text_style.dart';
import 'package:solution_one/view_model/model_widget/app_page_indicator.dart';
import 'package:solution_one/view_model/model_widget/circle_button.dart';
import 'package:solution_one/view_model/model_widget/page_image.dart/gradient_container.dart';
import 'package:solution_one/view_model/model_widget/page_image.dart/page_image.dart';
import 'package:solution_one/view_model/model_widget/themed_txt.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const double _imageSize = 250;
  static const double _logoHeight = 126;
  static const double _textHeight = 110;
  static const double _pageIndicatorHeight = 55;

  static List<PageData> pageData = [];

  late final PageController _pageController = PageController()
    ..addListener(_handlePageChanged);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  bool get _isOnLastPage => _currentPage.value.round() == pageData.length - 1;
  bool get _isOnFirstPage => _currentPage.value.round() == 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleIntroCompletePressed() {
    if (_currentPage.value == pageData.length - 1) {
      context.go(ScreenPaths.home);
      // settingsLogic.hasCompletedOnboarding.value = true;
    }
  }

  void _handlePageChanged() {
    int newPage = _pageController.page?.round() ?? 0;
    _currentPage.value = newPage;
  }

  void _handleSemanticSwipe(int dir) {
    _pageController.animateToPage((_pageController.page ?? 0).round() + dir,
        duration: $styles.times.fast, curve: Curves.easeOut);
  }

  void _handleNavTextSemanticTap() => _incrementPage(1);

  void _incrementPage(int dir) {
    final int current = _pageController.page!.round();
    if (_isOnLastPage && dir > 0) return;
    if (_isOnFirstPage && dir < 0) return;
    _pageController.animateToPage(current + dir,
        duration: 250.ms, curve: Curves.easeIn);
  }

  void _handleScrollWheel(double delta) => _incrementPage(delta > 0 ? 1 : -1);

  @override
  Widget build(BuildContext context) {
    // Set the page data, as strings may have changed based on locale
    pageData = const [
      PageData('Online Learning Platform',
          'Navigate the intersection of time, art, and culture.', 'camel', '1'),
      PageData(
          'Explore Books',
          'Uncover remarkable Litrture Books from around the world.',
          'petra',
          '2'),
      PageData(
          'Discover Videos',
          'Learn about science throughout time by examining things they left behind in past.',
          'statue',
          '3'),
    ];

    // This view uses a full screen PageView to enable swipe navigation.
    // However, we only want the title / description to actually swipe,
    // so we stack a PageView with that content over top of all the other
    // content, and line up their layouts.
    final List<Widget> pages = pageData.map((e) => _Page(data: e)).toList();

    /// Return resulting widget tree
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          _handleScrollWheel(signal.scrollDelta.dy);
        }
      },
      child: DefaultTextColor(
        color: $styles.colors.offWhite,
        child: Container(
          color: $styles.colors.black,
          child: SafeArea(
            child: Animate(
              delay: 500.ms,
              effects: const [FadeEffect()],
              child: Stack(
                children: [
                  // page view with title & description:
                  MergeSemantics(
                    child: Semantics(
                      onIncrease: () => _handleSemanticSwipe(1),
                      onDecrease: () => _handleSemanticSwipe(-1),
                      child: PageView(
                        controller: _pageController,
                        children: pages,
                        onPageChanged: (_) => AppHaptics.lightImpact(),
                      ),
                    ),
                  ),

                  IgnorePointer(
                    ignoringSemantics: false,
                    child: Column(children: [
                      const Spacer(),

                      // logo:
                      Semantics(
                        header: true,
                        child: Container(
                          height: _logoHeight,
                          alignment: Alignment.center,
                          child: _WonderousLogo(),
                        ),
                      ),

                      // masked image:
                      SizedBox(
                        height: _imageSize,
                        width: _imageSize,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _currentPage,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: $styles.times.slow,
                              child: KeyedSubtree(
                                key: ValueKey(
                                    value), // so AnimatedSwitcher sees it as a different child.
                                child: PageImage(data: pageData[value]),
                              ),
                            );
                          },
                        ),
                      ),

                      // placeholder gap for text:
                      const Gap(_IntroScreenState._textHeight),

                      // page indicator:
                      Container(
                        height: _pageIndicatorHeight,
                        alignment: const Alignment(0.0, 0),
                        child: AppPageIndicator(
                            count: pageData.length,
                            controller: _pageController,
                            color: $styles.colors.offWhite),
                      ),

                      const Spacer(flex: 2),
                    ]),
                  ),

                  // Build a cpl overlays to hide the content when swiping on very wide screens
                  _buildHzGradientOverlay(left: true),
                  _buildHzGradientOverlay(),

                  // finish button:
                  Positioned(
                    right: $styles.insets.lg,
                    bottom: $styles.insets.lg,
                    child: _buildFinishBtn(context),
                  ),

                  // nav help text:
                  BottomCenter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: $styles.insets.lg),
                      child: _buildNavText(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHzGradientOverlay({bool left = false}) {
    return Align(
      alignment: Alignment(left ? -1 : 1, 0),
      child: FractionallySizedBox(
        widthFactor: .5,
        child: Padding(
          padding: EdgeInsets.only(left: left ? 0 : 200, right: left ? 200 : 0),
          child: Transform.scale(
              scaleX: left ? -1 : 1,
              child: HzGradient([
                $styles.colors.black.withOpacity(0),
                $styles.colors.black,
              ], const [
                0,
                .2
              ])),
        ),
      ),
    );
  }

  Widget _buildFinishBtn(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (_, pageIndex, __) {
        return AnimatedOpacity(
          opacity: pageIndex == pageData.length - 1 ? 1 : 0,
          duration: $styles.times.fast,
          child: CircleIconBtn(
            icon: AppIcons.next_large,
            bgColor: $styles.colors.accent1,
            onPressed: _handleIntroCompletePressed,
            semanticLabel: 'Enter the app',
          ),
        );
      },
    );
  }

  Widget _buildNavText(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentPage,
      builder: (_, pageIndex, __) {
        return AnimatedOpacity(
          opacity: pageIndex == pageData.length - 1 ? 0 : 1,
          duration: $styles.times.fast,
          child: Semantics(
            onTapHint: 'Navigate',
            onTap: _isOnLastPage ? null : _handleNavTextSemanticTap,
            child:
                Text('Swipe left to continue', style: $styles.text.bodySmall),
          ),
        );
      },
    );
  }
}

@immutable
class _PageData {
  const _PageData(this.title, this.desc, this.img, this.mask);

  final String title;
  final String desc;
  final String img;
  final String mask;
}

class _Page extends StatelessWidget {
  const _Page({Key? key, required this.data}) : super(key: key);

  final PageData data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
        child: Column(children: [
          const Spacer(),
          const Gap(
              _IntroScreenState._imageSize + _IntroScreenState._logoHeight),
          SizedBox(
            height: _IntroScreenState._textHeight,
            width: 400,
            child: StaticTextScale(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.title,
                      style: $styles.text.wonderTitle
                          .copyWith(fontSize: 24 * $styles.scale)),
                  Gap($styles.insets.sm),
                  Text(data.desc,
                      style: $styles.text.body, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const Gap(_IntroScreenState._pageIndicatorHeight),
          const Spacer(flex: 2),
        ]),
      ),
    );
  }
}

class _WonderousLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExcludeSemantics(
          child: SvgPicture.asset(SvgPaths.compassSimple,
              colorFilter: $styles.colors.offWhite.colorFilter, height: 48),
        ),
        Gap($styles.insets.xs),
        StaticTextScale(
          child: Text(
            'Interview Task',
            style: $styles.text.wonderTitle.copyWith(
                fontSize: 32 * $styles.scale, color: $styles.colors.offWhite),
          ),
        )
      ],
    );
  }
}



class _PageImage extends StatelessWidget {
  const _PageImage({Key? key, required this.data}) : super(key: key);

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            '${ImagePaths.common}/intro-${data.img}.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
        Positioned.fill(
            child: Image.asset(
          '${ImagePaths.common}/intro-mask-${data.mask}.png',
          fit: BoxFit.fill,
        )),
      ],
    );
  }
}

