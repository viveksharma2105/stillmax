import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import 'weather_widget.dart';

final liveTimeProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  ).asBroadcastStream();
});

class TimeHeader extends ConsumerWidget {
  const TimeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(liveTimeProvider).valueOrNull ?? DateTime.now();
    final scale =
        ref.watch(settingsProvider).valueOrNull?.fontScaleFactor ?? 1.0;
    final timeText = DateFormat('HH:mm').format(now);
    final dateText = DateFormat('EEEE, MMMM d').format(now).toUpperCase();

    return SizedBox(
      height: 146,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeText,
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 64 * scale,
                    fontWeight: FontWeight.w700,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dateText,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13 * scale,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(top: 8, right: 0, child: WeatherWidget()),
        ],
      ),
    );
  }
}
