import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Provider((ref) => AppLogger());

class AppLogger extends Logger {
  AppLogger()
      : super(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            printTime: true,
          ),
        );

  @override
  void e(message, {error, StackTrace? stackTrace, DateTime? time}) {
    super.e(message, error: error, stackTrace: stackTrace, time: time);
    if (kDebugMode) {
      debugPrint('report error to crashlytics');
    }
  }

  @override
  void w(message, {error, StackTrace? stackTrace, DateTime? time}) {
    super.w(message, error: error, stackTrace: stackTrace, time: time);
    if (kDebugMode) {
      debugPrint('report warning to crashlytics');
    }
  }

  @override
  void i(message, {error, StackTrace? stackTrace, DateTime? time}) {
    super.i(message, error: error, stackTrace: stackTrace, time: time);
    if (kDebugMode) {
      debugPrint('report info to crashlytics');
    }
  }

  @override
  void d(message, {error, StackTrace? stackTrace, DateTime? time}) {
    super.d(message, error: error, stackTrace: stackTrace, time: time);
    if (kDebugMode) {
      debugPrint('report debug to crashlytics');
    }
  }

  @override
  void t(message, {error, StackTrace? stackTrace, DateTime? time}) {
    super.t(message, error: error, stackTrace: stackTrace, time: time);
    if (kDebugMode) {
      debugPrint('report trace to crashlytics');
    }
  }

  @override
  void f(message, {error, StackTrace? stackTrace, DateTime? time}) {
    super.f(message, error: error, stackTrace: stackTrace, time: time);
    if (kDebugMode) {
      debugPrint('report fatal to crashlytics');
    }
  }
}
