import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:solution_one/main.dart';
import 'package:solution_one/model/provider/app_provider.dart';
import 'package:solution_one/view/screen/home_screen.dart';
import 'package:solution_one/view/screen/intro_screen.dart';
import 'package:solution_one/view_model/model_widget/page_image.dart/error_page.dart';
import 'package:solution_one/view_model/styles/app_scaffold.dart';


class ScreenPaths {

  static String splash = '/';
  static String intro = '/welcome';
  static String home = '/home';
  static String settings = '/settings';
static String  tab = '/tabbar';


}



/// Routing table, matches string paths to UI Screens, optionally parses params from the paths
final appRouter = GoRouter(
  redirect: (context, state) {
    // Access the redirect logic using a Riverpod `ProviderScope`
    final ref = ProviderScope.containerOf(context);
    final redirectLogic = ref.read(redirectProvider);
    return redirectLogic(state);
  },
  errorPageBuilder: (context, state) =>
      MaterialPage(child: PageNotFound(state.uri.toString())),
  routes: [
    ShellRoute(
      builder: (context, router, navigator) {
        return WondersAppScaffold(child: navigator);
      },
      routes: [
        AppRoute(
          ScreenPaths.splash,
          (_) => Container(color: $styles.colors.greyStrong),
        ),
        AppRoute(ScreenPaths.intro, (_) => IntroScreen()),
        AppRoute(ScreenPaths.home, (_) => HomeScreen()),
        //  AppRoute (ScreenPaths.tab,   (_) =>  TabBarScreen()),
  

      ],
    ),
  ],
);

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}

String? get initialDeeplink => _initialDeeplink;
String? _initialDeeplink;

final initialDeeplinkProvider = StateProvider<String?>((ref) => null);

String? _handleRedirect(WidgetRef ref, GoRouterState state) {
  final appLogic = ref.watch(appLogicProvider); // Access the AppLogic instance
  final initialDeeplink = ref.read(initialDeeplinkProvider.notifier); // Manage deeplink state

  // Prevent navigation away from `/` if app is starting up
  if (!appLogic.isBootstrapComplete && state.uri.path != ScreenPaths.splash) {
    debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.splash}.');
    initialDeeplink.state ??= state.uri.toString(); // Store the initial deeplink
    return ScreenPaths.splash;
  }

  if (appLogic.isBootstrapComplete && state.uri.path == ScreenPaths.splash) {
    debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.home}');
    return ScreenPaths.home;
  }

  if (!kIsWeb) debugPrint('Navigate to: ${state.uri}');
  return null; // Do nothing if no redirect is required
}

final redirectProvider = Provider<String? Function(GoRouterState)>((ref) {
  final appLogic = ref.watch(appLogicProvider);
  final initialDeeplinkNotifier = ref.read(initialDeeplinkProvider.notifier);

  return (GoRouterState state) {
    // Prevent navigation away from `/` if app is starting up
    if (!appLogic.isBootstrapComplete && state.uri.path != ScreenPaths.splash) {
      debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.splash}.');
      initialDeeplinkNotifier.state ??= state.uri.toString();
      return ScreenPaths.splash;
    }

    if (appLogic.isBootstrapComplete && state.uri.path == ScreenPaths.splash) {
      debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.home}');
      return ScreenPaths.home;
    }

    if (!kIsWeb) debugPrint('Navigate to: ${state.uri}');
    return null; // Do nothing if no redirect is required
  };
});
