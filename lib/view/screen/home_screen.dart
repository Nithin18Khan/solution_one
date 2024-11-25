import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/main.dart';
import 'package:solution_one/model/data_model.dart';
import 'package:solution_one/model/logic/wonders_logic.dart';
import 'package:solution_one/model/provider/wonder_index_provider.dart';
import 'package:solution_one/view/decoration/animated.clouds.dart';
import 'package:solution_one/view/decoration/app_header.dart';
import 'package:solution_one/view/decoration/color_extention.dart';
import 'package:solution_one/view/screen/tabbar.screen.dart';
import 'package:solution_one/view/texture/title_text.dart';
import 'package:solution_one/view/transition/illustration.config.dart';
import 'package:solution_one/view/transition/illustration.dart';
import 'package:solution_one/view_model/app_haptics.dart';
import 'package:solution_one/view_model/buttons/animated_button.dart';
import 'package:solution_one/view_model/buttons/app_icons.dart';
import 'package:solution_one/view_model/model_widget/app_page_indicator.dart';
import 'package:solution_one/view_model/model_widget/page_image.dart/gradient_container.dart';
import 'package:solution_one/view_model/model_widget/themed_txt.dart';
import 'package:solution_one/view_model/styles/vertical_swipe_controller.dart';
import 'package:gap/gap.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final VerticalSwipeController _swipeController;

  late int _wonderIndex;
  final _fadeAnims = <AnimationController>[];
  double? _swipeOverride;
  bool _fadeInOnNextBuild = false;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _wonderIndex = 0; // Initialize _wonderIndex here
    _swipeController = VerticalSwipeController(this, showDetailsPage);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wonders = ref.read(wondersProvider); // Get wonders list
    _wonderIndex = ref.read(wonderIndexProvider); // Initialize wonder index
    final initialPage = wonders.length * 100 + _wonderIndex;
    _pageController = PageController(viewportFraction: 1, initialPage: initialPage);
     
  }

  void _handlePageChanged(int value) {
    final wonders = ref.read(wondersProvider);
    final newIndex = value % wonders.length;
    if (newIndex == _wonderIndex) return;
    setState(() {
      _wonderIndex = newIndex;
    });
    ref.read(wonderIndexProvider.notifier).setWonderIndex(_wonderIndex);
    AppHaptics.lightImpact();
  }

  void _handleFadeAnimInit(AnimationController controller) {
    _fadeAnims.add(controller);
    controller.value = 1;
  }

  void _setPageIndex(int index, {bool animate = false}) {
    final wonders = ref.read(wondersProvider);
    if (index == _wonderIndex) return;
    final pos = ((_pageController.page ?? 0) / wonders.length).floor() * wonders.length;
    final newIndex = pos + index;
    if (animate) {
      _pageController.animateToPage(newIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    } else {
      _pageController.jumpToPage(newIndex);
    }
  }

void showDetailsPage() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TabBarScreen()),
  );
}


  void _startDelayedFgFade() async {
    try {
      for (var a in _fadeAnims) {
        a.value = 0;
      }
      await Future.delayed(const Duration(milliseconds: 300));
      for (var a in _fadeAnims) {
        a.forward();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }





  Widget build(BuildContext context) {


    final wonders = ref.watch(wondersProvider);
    final currentWonder = wonders[_wonderIndex];

    
    if (_fadeInOnNextBuild) {
      _startDelayedFgFade();
      _fadeInOnNextBuild = false;
    }

    return _swipeController.wrapGestureDetector(Container(
      color: Colors.black,
      child: Stack(
        children: [
          ..._buildBgAndClouds(wonders, currentWonder),
          _buildFgAndGradients(),
          _buildMgPageView(),
          _buildFloatingUi(),
        ],
      ).animate().fadeIn(),
    ));
  }

  Widget _buildMgPageView() {
final wonders = ref.watch(wondersProvider);
bool _isSelected(WonderType wonderType) {
  return wonders[_wonderIndex].type == wonderType;
}

    return ExcludeSemantics(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _handlePageChanged,
        itemBuilder: (_, index) {
          final wonder = wonders[index % wonders.length];
          final wonderType = wonder.type;
          bool isShowing = _isSelected(wonderType);
          return _swipeController.buildListener(
            builder: (swipeAmt, _, child) {
              final config = WonderIllustrationConfig.mg(
                isShowing: isShowing,
                zoom: .05 * swipeAmt,
              );
              return WonderIllustration( config: config);
            },
          );
        },
      ),
    );
  }
List<Widget> _buildBgAndClouds(List<WonderData> wonders, WonderData currentWonder) {
  return [
    ...wonders.map((wonder) {
      return WonderIllustration(
        config: WonderIllustrationConfig.bg(isShowing: wonder == currentWonder),
      );
    }).toList(),
   
  ];
}



  Widget _buildFgAndGradients() {
  Widget buildSwipeableBgGradient(Color fgColor) {
    return _swipeController.buildListener(
      builder: (swipeAmt, isPointerDown, _) {
        return IgnorePointer(
          child: FractionallySizedBox(
            heightFactor: .6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    fgColor.withOpacity(0),
                    fgColor.withOpacity(.5 + swipeAmt * .25),
                  ],
                  stops: const [0, 1],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  final wonders = ref.watch(wondersProvider);
  final currentWonder = wonders[_wonderIndex];
  final fgColor = currentWonder.type.fgColor;

  return Stack(
    children: [
      BottomCenter(
        child: buildSwipeableBgGradient(fgColor.withOpacity(.65)),
      ),
      BottomCenter(
        child: buildSwipeableBgGradient(fgColor),
      ),
    ],
  );
}


 
Widget _buildFloatingUi() {
  return Stack(children: [
    AnimatedSwitcher(
      duration: $styles.times.fast,
      child: AnimatedOpacity(
        opacity: _isMenuOpen ? 0 : 1,
        duration: $styles.times.med,
        child: RepaintBoundary(
          child: OverflowBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: double.infinity),
                const Spacer(),

                // Title Content
                LightText(
                  child: IgnorePointer(
                    ignoringSemantics: false,
                    child: Transform.translate(
                      offset: const Offset(0, 30),
                      child: Column(
                        children: [
                          Semantics(
                            liveRegion: true,
                            button: true,
                            header: true,
                            onIncrease: () => _setPageIndex(_wonderIndex + 1),
                            onDecrease: () => _setPageIndex(_wonderIndex - 1),
                            onTap: () {
                              // Call showDetailsPage to navigate
                              showDetailsPage();
                            },
                            child: WonderTitleText(
                              "Drop Down",
                              enableShadows: true,
                            ),
                          ),
                          Gap($styles.insets.md),
                          AppPageIndicator(
                            count: 1,
                            controller: _pageController,
                            color: $styles.colors.white,
                            dotSize: 8,
                            semanticPageTitle: 'wonder',
                          ),
                          Gap($styles.insets.md),
                        ],
                      ),
                    ),
                  ),
                ),

                // Animated arrow and background
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  key: ValueKey(_wonderIndex),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _swipeController.buildListener(
                          builder: (swipeAmt, _, child) {
                            double heightFactor = .5 + .5 * (1 + swipeAmt * 4);
                            return FractionallySizedBox(
                              alignment: Alignment.bottomCenter,
                              heightFactor: heightFactor,
                              child: Opacity(opacity: swipeAmt * .5, child: child),
                            );
                          },
                          child: VtGradient(
                            [
                              $styles.colors.white.withOpacity(0),
                              $styles.colors.white.withOpacity(1)
                            ],
                            const [.3, 1],
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),

                      // Arrow Btn
                      AnimatedArrowButton(
                        onTap: () {
                          showDetailsPage(); // Call navigation method
                        },
                        semanticTitle: "Jockong"
                      ),
                    ],
                  ),
                ),
                Gap($styles.insets.md),
              ],
            ),
          ),
        ),
      ),
    ),
  ]);
}
    }