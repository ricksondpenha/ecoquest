import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/app_lifecycle.dart';

/// This class is responsible for initializing the app.
abstract class AppInit {
  // Initializes the app.
  static Future<ProviderContainer> init() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    // Put game into full screen mode on mobile devices.
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Lock the game to portrait mode on mobile devices.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final provider = ProviderContainer(
      overrides: [],
      observers: [],
    );

    // Register app lifecycle listener.
    provider.read(appLifecycleProvider);
    

    return provider;
  }
}

/// This is the root widget of the app.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppNavigation().router,
    );
  }
}
