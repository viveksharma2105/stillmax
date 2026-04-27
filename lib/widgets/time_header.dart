import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../screens/black_box_password_screen.dart';
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
  int _mediaCardTapCount = 0;
  bool _isPlayPausePressed = false;
  Timer? _tapResetTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _tapResetTimer?.cancel();
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

  void _onMediaCardTap() {
    _tapResetTimer?.cancel();
    _mediaCardTapCount++;

    if (_mediaCardTapCount >= 4) {
      _mediaCardTapCount = 0;
      _openBlackBox();
    } else {
      _tapResetTimer = Timer(const Duration(seconds: 2), () {
        _mediaCardTapCount = 0;
      });
    }
  }

  Future<void> _openBlackBox() async {
    try {
      final notifier = ref.read(blackBoxNotifierProvider);
      final isPasswordSet = await notifier.isPasswordSet();
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlackBoxPasswordScreen(
            mode: isPasswordSet ? BlackBoxMode.verify : BlackBoxMode.setup,
          ),
        ),
      );
    } catch (e) {
      // Silently handle errors - likely from password check failing
      debugPrint('Error opening Black Box: $e');
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

  Widget _buildMediaPlayerCard(Map<String, dynamic>? mediaInfo) {
    if (mediaInfo == null || mediaInfo.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 48,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              'No media playing',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    final title = mediaInfo['trackName'] as String? ?? 'Unknown';
    final artist = mediaInfo['artistName'] as String? ?? 'Unknown Artist';
    final isPlaying = mediaInfo['isPlaying'] as bool? ?? false;
    final albumArtBytes = mediaInfo['albumArt'] as Uint8List?;
    final albumArtCacheSize = (72 * MediaQuery.devicePixelRatioOf(context))
        .round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Album art (left side)
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: albumArtBytes != null && albumArtBytes.isNotEmpty
                  ? Image.memory(
                      albumArtBytes,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      cacheWidth: albumArtCacheSize,
                      cacheHeight: albumArtCacheSize,
                    )
                  : const Icon(
                      Icons.music_note,
                      size: 36,
                      color: Colors.white54,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Song info + controls (right side)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  artist,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Playback controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                      iconSize: 28,
                      onPressed: () {
                        ref
                            .read(appServiceProvider)
                            .sendMediaAction('previous');
                      },
                    ),
                    Listener(
                      onPointerDown: (_) {
                        setState(() => _isPlayPausePressed = true);
                      },
                      onPointerUp: (_) {
                        setState(() => _isPlayPausePressed = false);
                      },
                      onPointerCancel: (_) {
                        setState(() => _isPlayPausePressed = false);
                      },
                      child: AnimatedScale(
                        scale: _isPlayPausePressed ? 0.9 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOutBack,
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              final scaleAnimation = Tween<double>(
                                begin: 0.88,
                                end: 1.0,
                              ).animate(animation);

                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: scaleAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              key: ValueKey<bool>(isPlaying),
                              color: Colors.white,
                            ),
                          ),
                          iconSize: 36,
                          onPressed: () {
                            ref
                                .read(appServiceProvider)
                                .sendMediaAction(isPlaying ? 'pause' : 'play');
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      iconSize: 28,
                      onPressed: () {
                        ref.read(appServiceProvider).sendMediaAction('next');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(liveTimeProvider).valueOrNull ?? DateTime.now();
    final settings = ref.watch(settingsProvider).valueOrNull;
    final clockStyle = settings?.clockStyle ?? 'digital';
    final showWeatherWidget = settings?.showWeatherWidget ?? true;
    final rightWidgetSlotId = settings?.rightWidgetSlotId;
    final hourString = DateFormat('HH').format(now);
    final minuteString = DateFormat('mm').format(now);
    final dateText = DateFormat('EEEE, MMMM d').format(now).toUpperCase();
    final mediaInfo = ref.watch(mediaSessionProvider).valueOrNull;

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                // Reset tap count when navigating away from media player page
                if (index != 0) {
                  _tapResetTimer?.cancel();
                  _mediaCardTapCount = 0;
                }
              },
              children: [
                GestureDetector(
                  onTap: _onMediaCardTap,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: statusBarHeight + 8.0,
                      bottom: 16,
                    ),
                    child: _buildMediaPlayerCard(mediaInfo),
                  ),
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
                      if (showWeatherWidget)
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
