import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_theme.dart';
import 'core/services/app_lifecycle.dart';
import 'core/services/app_navigation.dart';
import 'core/services/local_storage.dart';
import 'core/utils/provider_logger.dart';

/// This class is responsible for initializing the app.
abstract class AppInit {
  // Initializes the app.
  static Future<ProviderContainer> init() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    // Show splash screen.
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Put game into full screen mode on mobile devices.
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Lock the game to portrait mode on mobile devices.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    final provider = ProviderContainer(
      overrides: [],
      observers: [ProviderLogger()],
    );

    try {
    // Register app lifecycle listener.
    provider.read(appLifecycleProvider);

      // Initialize local storage.
      await provider.read(localStorageProvider).init();

      await provider.read(appThemeProvider).init();
    } catch (e, s) {
      debugPrint('${e.toString()}, ${s.toString()}');
    }

    // Remove splash screen.
    FlutterNativeSplash.remove();

    return provider;
  }
}

/// This is the root widget of the app.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final appTheme = ref.watch(appThemeProvider);
      return MaterialApp.router(
      routerConfig: AppNavigation.router,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appTheme.themeMode,
      );
    }
    );
  }
}
