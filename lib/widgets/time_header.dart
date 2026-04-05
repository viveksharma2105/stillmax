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
    final hourString = DateFormat('HH').format(now);
    final minuteString = DateFormat('mm').format(now);
    final dateText = DateFormat('EEEE, MMMM d').format(now).toUpperCase();

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Clock and date — left aligned
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: statusBarHeight + 16,
              bottom: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (clockStyle == 'analog')
                  AnalogClock(time: now, size: 120)
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        hourString,
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: clockStyle == 'digital_thin'
                              ? FontWeight.w200
                              : FontWeight.w700,
                          color: const Color(0xFFE53935), // red
                          height: 1.0,
                        ),
                      ),
                      Text(
                        ':$minuteString',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: clockStyle == 'digital_thin'
                              ? FontWeight.w200
                              : FontWeight.w700,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ],
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
          // Weather — absolutely positioned top right
          Positioned(
            top: statusBarHeight + 16,
            right: 16,
            child: const WeatherWidget(),
          ),
        ],
      ),
    );
  }
}
