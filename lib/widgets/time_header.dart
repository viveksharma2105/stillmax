import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/app_list_provider.dart';
import 'analog_clock.dart';
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
    final settings = ref.watch(settingsProvider).valueOrNull;
    final clockStyle = settings?.clockStyle ?? 'digital';
    final timeText = DateFormat('HH:mm').format(now);
    final dateText = DateFormat('EEEE, MMMM d').format(now).toUpperCase();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (clockStyle == 'analog')
                AnalogClock(time: now, size: 120)
              else
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: clockStyle == 'digital_thin'
                        ? FontWeight.w200
                        : FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                dateText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const Positioned(top: 0, right: 16, child: WeatherWidget()),
      ],
    );
  }
}
