import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class AppConstants {
  // Platform
  static const isWeb = kIsWeb;
  static final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  static final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  // Sizing
  static const vspace8 = SizedBox(height: 8.0);
  static const vspace16 = SizedBox(height: 16.0);

  static const hspace8 = SizedBox(width: 8.0);
  static const hspace16 = SizedBox(width: 16.0);

  static const padding8 = EdgeInsets.all(8.0);
  static const padding16 = EdgeInsets.all(16.0);
}
