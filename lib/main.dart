import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/provider/app_provider.dart';
import 'package:solution_one/router.dart';
import 'package:solution_one/view_model/app_shortcuts.dart';
import 'package:solution_one/view_model/styles/app_scaffold.dart';
import 'package:solution_one/view_model/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize AppLogic during app startup
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(appLogicProvider).bootstrap(ref);
    });

    return MaterialApp.router(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      shortcuts: AppShortcuts.defaults,
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      theme: ThemeData(
        fontFamily: $styles.body.fontFamily,
        useMaterial3: true,
      ),
    );
  }
}

AppStyle get $styles => WondersAppScaffold.style;
