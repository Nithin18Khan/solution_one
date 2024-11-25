import 'dart:async';
import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:solution_one/main.dart';
import 'package:solution_one/model/logic/settings_logic.dart';
import 'package:solution_one/router.dart';
import 'package:solution_one/view_model/platform_info.dart';

class AppLogic {
  Size _appSize = Size.zero;

  bool isBootstrapComplete = false;

  List<Axis> supportedOrientations = [Axis.vertical, Axis.horizontal];

  List<Axis>? _supportedOrientationsOverride;
  set supportedOrientationsOverride(List<Axis>? value) {
    if (_supportedOrientationsOverride != value) {
      _supportedOrientationsOverride = value;
      _updateSystemOrientation();
    }
  }

  Future<void> bootstrap(WidgetRef ref) async {
    debugPrint('bootstrap start...');

    // Set min-sizes for desktop apps
    if (PlatformInfo.isDesktop) {
      await DesktopWindow.setMinWindowSize($styles.sizes.minAppSize);
    }

    if (kIsWeb) {
      print(
        '''Thanks for checking out Wonderous on the web!
        If you encounter any issues please report them at https://github.com/gskinnerTeam/flutter-wonderous-app/issues.''',
      );
      WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
    }

    isBootstrapComplete = true;

    // Use Riverpod to get the app's settings state
    final settings = ref.read(settingsProvider);

    // Load the initial view
    bool showIntro = settings.hasCompletedOnboarding == false;
    if (showIntro) {
      appRouter.go(ScreenPaths.intro);
    } else {
      appRouter.go(initialDeeplink ?? ScreenPaths.home);
    }
  }

  /// Called from the UI layer once a MediaQuery has been obtained
  void handleAppSizeChanged(Size appSize) {
    /// Disable landscape layout on smaller form factors
    bool isSmall = display.size.shortestSide / display.devicePixelRatio < 600;
    supportedOrientations =
        isSmall ? [Axis.vertical] : [Axis.vertical, Axis.horizontal];
    _updateSystemOrientation();
    _appSize = appSize;
  }

  Display get display => PlatformDispatcher.instance.displays.first;

  bool shouldUseNavRail() =>
      _appSize.width > _appSize.height && _appSize.height > 250;

  void _updateSystemOrientation() {
    final axisList = _supportedOrientationsOverride ?? supportedOrientations;
    final orientations = <DeviceOrientation>[];
    if (axisList.contains(Axis.vertical)) {
      orientations.addAll([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    if (axisList.contains(Axis.horizontal)) {
      orientations.addAll([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    SystemChrome.setPreferredOrientations(orientations);
  }
}

class AppImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    this.imageCache.maximumSizeBytes = 250 << 20; // 250mb
    return super.createImageCache();
  }
}
