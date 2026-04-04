import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_list_provider.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FlutterError.onError = (details) async {
    final dir = await getApplicationDocumentsDirectory();
    await File(
      '${dir.path}/crash.log',
    ).writeAsString(details.exceptionAsString());
    runApp(const ProviderScope(child: StillmaxApp()));
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(() async {
      final dir = await getApplicationDocumentsDirectory();
      await File('${dir.path}/crash.log').writeAsString(error.toString());
      runApp(const ProviderScope(child: StillmaxApp()));
    }());
    return true;
  };

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const ProviderScope(child: StillmaxApp()));
}

class StillmaxApp extends StatelessWidget {
  const StillmaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final scale =
            ref.watch(settingsProvider).valueOrNull?.fontScaleFactor ?? 1.0;
        final hasOnboarded =
            ref.watch(onboardingProvider).valueOrNull?.hasOnboarded ?? false;
        return MaterialApp(
          title: 'Stillmax',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(fontScaleFactor: scale),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: child ?? const SizedBox.shrink(),
          ),
          home: hasOnboarded ? const HomeScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}
