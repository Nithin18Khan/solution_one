import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:solution_one/main.dart';
import 'package:solution_one/model/provider/app_provider.dart';
import 'package:solution_one/view_model/styles/app_scroll_behaviour.dart';
import 'package:solution_one/view_model/styles/styles.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Add this import

class WondersAppScaffold extends ConsumerWidget {
  const WondersAppScaffold({Key? key, required this.child}) : super(key: key);
  final Widget child;
  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access appLogic using Riverpod provider
    final appLogic = ref.read(appLogicProvider);

    // Listen to the device size, and update AppStyle when it changes
    final mq = MediaQuery.of(context);
    appLogic.handleAppSizeChanged(mq.size);

    // Set default timing for animations in the app
    Animate.defaultDuration = _style.times.fast;

    // Create a style object that will be passed down the widget tree
    _style = AppStyle(screenSize: context.sizePx);

    return KeyedSubtree(
      key: ValueKey($styles.scale),
      child: Theme(
        data: $styles.colors.toThemeData(),
        // Provide a default texts style to allow Hero's to render text properly
        child: DefaultTextStyle(
          style: $styles.text.body,
          // Use a custom scroll behavior across entire app
          child: ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: child,
          ),
        ),
      ),
    );
  }
}
