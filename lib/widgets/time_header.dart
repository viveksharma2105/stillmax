import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import 'analog_clock.dart';
import 'home_widget_view.dart';
import 'widget_picker_sheet.dart';
import 'weather_widget.dart';

final liveTimeProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final controller = StreamController<DateTime>();

  void tick() {
    if (!controller.isClosed) {
      controller.add(DateTime.now());
    }
  }

  tick(); // Emit immediately
  final timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

class TimeHeader extends ConsumerStatefulWidget {
  const TimeHeader({super.key});

  @override
  ConsumerState<TimeHeader> createState() => _TimeHeaderState();
}

class _TimeHeaderState extends ConsumerState<TimeHeader> {
  late final PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickWidgetForSlot(bool leftSlot) async {
    final selected = await showModalBottomSheet<AvailableWidgetInfo>(
      context: context,
      backgroundColor: AppColors.background.withValues(alpha: 0),
      isScrollControlled: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.86,
        child: WidgetPickerSheet(),
      ),
    );
    if (selected == null || !mounted) return;

    final appService = ref.read(appServiceProvider);
    final widgetsNotifier = ref.read(widgetListProvider.notifier);
    final settingsNotifier = ref.read(settingsNotifierProvider);

    final appWidgetId = await appService.allocateWidgetId();
    if (appWidgetId == null || !mounted) return;
    final bound = await appService.bindWidget(
      appWidgetId,
      selected.packageName,
      selected.className,
    );
    if (!bound) {
      await appService.deleteWidgetId(appWidgetId);
      return;
    }
    if (!mounted) return;
    final created = await appService.createWidgetView(appWidgetId);
    if (!created) {
      await appService.deleteWidgetId(appWidgetId);
      return;
    }
    if (!mounted) return;
    await widgetsNotifier.addWidget(
      appWidgetId: appWidgetId,
      label: selected.label,
      providerPackage: selected.packageName,
      providerClass: selected.className,
      minWidth: selected.minWidth,
      minHeight: selected.minHeight,
    );
    if (!mounted) return;
    if (leftSlot) {
      await settingsNotifier.setLeftWidgetSlot(appWidgetId);
    } else {
      await settingsNotifier.setRightWidgetSlot(appWidgetId);
    }
  }

  Future<void> _removeSlotWidget(int widgetId, bool leftSlot) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.glassDark,
        title: const Text('Remove Widget'),
        content: const Text('Delete this widget slot?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (shouldRemove != true || !mounted) return;
    await ref.read(appServiceProvider).deleteWidgetId(widgetId);
    if (!mounted) return;
    await ref.read(widgetListProvider.notifier).removeWidget(widgetId);
    if (!mounted) return;
    if (leftSlot) {
      await ref.read(settingsNotifierProvider).setLeftWidgetSlot(null);
    } else {
      await ref.read(settingsNotifierProvider).setRightWidgetSlot(null);
    }
  }

  Widget _buildSlot({required int? widgetId, required bool leftSlot}) {
    if (widgetId == null) {
      return GestureDetector(
        onTap: () => _pickWidgetForSlot(leftSlot),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: Colors.white.withValues(alpha: 0.3),
            strokeWidth: 2,
            dashWidth: 8,
            gapWidth: 4,
            radius: 12,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.widgets_outlined,
                  size: 40,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add widget',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: HomeWidgetView(widgetId: widgetId),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () => _removeSlotWidget(widgetId, leftSlot),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(liveTimeProvider).valueOrNull ?? DateTime.now();
    final settings = ref.watch(settingsProvider).valueOrNull;
    final clockStyle = settings?.clockStyle ?? 'digital';
    final leftWidgetSlotId = settings?.leftWidgetSlotId;
    final rightWidgetSlotId = settings?.rightWidgetSlotId;
    final hourString = DateFormat('HH').format(now);
    final minuteString = DateFormat('mm').format(now);
    final dateText = DateFormat('EEEE, MMMM d').format(now).toUpperCase();

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: statusBarHeight + 8.0,
                    bottom: 16,
                  ),
                  child: _buildSlot(widgetId: leftWidgetSlotId, leftSlot: true),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: statusBarHeight + 8.0,
                    bottom: 16,
                  ),
                  child: Stack(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (clockStyle == 'analog')
                              AnalogClock(time: now, size: 160)
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    hourString,
                                    style: TextStyle(
                                      fontSize: 96,
                                      fontWeight: clockStyle == 'digital_thin'
                                          ? FontWeight.w200
                                          : FontWeight.w700,
                                      color: const Color(0xFFE53935),
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    ':$minuteString',
                                    style: TextStyle(
                                      fontSize: 96,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.55),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: WeatherWidget(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: statusBarHeight + 8.0,
                    bottom: 16,
                  ),
                  child: _buildSlot(
                    widgetId: rightWidgetSlotId,
                    leftSlot: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final active = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.secondary
                      : Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.gapWidth,
    required this.radius,
  });
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double gapWidth;
  final double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = dashWidth < metric.length - distance
            ? dashWidth
            : metric.length - distance;
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.gapWidth != gapWidth ||
      oldDelegate.radius != radius;
}
