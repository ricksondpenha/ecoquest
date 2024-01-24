import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage.dart';

final appThemeProvider = ChangeNotifierProvider<AppTheme>((ref) {
  return AppTheme(localStorage: ref.read(localStorageProvider));
});

class AppTheme extends ChangeNotifier {
  final LocalStorage _localStorage;

  AppTheme({required LocalStorage localStorage}) : _localStorage = localStorage;

  static String themeModeKey = 'isDarkMode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  static final lightTheme = ThemeData(
    colorSchemeSeed: Colors.orange,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,

  );

  static final darkTheme = ThemeData(
    colorSchemeSeed: Colors.orange,
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  init() async {
    final isDarkMode = await _localStorage.getBool(themeModeKey);
    if (isDarkMode != null) {
      _themeMode = isDarkMode == true ? ThemeMode.dark : ThemeMode.light;
    }
  }
}
