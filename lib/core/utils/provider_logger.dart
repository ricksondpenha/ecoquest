import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_logger.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    AppLogger().i(
        'provider: ${provider.name ?? provider.runtimeType},\nnewValue: $newValue');
  }
}
