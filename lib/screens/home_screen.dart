import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alphabet_sidebar.dart';
import '../widgets/app_list_tile.dart';
import '../widgets/home_widget_view.dart';
import '../widgets/time_header.dart';
import '../widgets/widget_picker_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const double _appTileExtent = 72;
  static const double _letterHeaderExtent = 24;

  final ScrollController _appsScrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{};
  final GlobalKey _topSectionsKey = GlobalKey();

  Timer? _scrollIdleTimer;
  bool _isAppsScrolling = false;
  double _topSectionsHeight = 0;

  @override
  void initState() {
    super.initState();
    _appsScrollController.addListener(_onAppsScroll);
  }

  @override
  void dispose() {
    _scrollIdleTimer?.cancel();
    _appsScrollController
      ..removeListener(_onAppsScroll)
      ..dispose();
    super.dispose();
  }

  void _onAppsScroll() {
    if (!_isAppsScrolling) {
      setState(() => _isAppsScrolling = true);
    }

    _scrollIdleTimer?.cancel();
    _scrollIdleTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) {
        return;
      }
      setState(() => _isAppsScrolling = false);
    });
  }

  void _measureTopSections() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final contextForTop = _topSectionsKey.currentContext;
      if (contextForTop == null) {
        return;
      }
      final render = contextForTop.findRenderObject();
      if (render is! RenderBox) {
        return;
      }
      final next = render.size.height;
      if ((next - _topSectionsHeight).abs() < 1) {
        return;
      }
      setState(() => _topSectionsHeight = next);
    });
  }

  Future<void> _openWidgetPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background.withValues(alpha: 0),
      isScrollControlled: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.86,
        child: WidgetPickerSheet(),
      ),
    );
  }

  Future<void> _jumpToLetter(String letter) async {
    final key = _sectionKeys[letter];
    if (key == null || !mounted) {
      return;
    }

    final contextForLetter = key.currentContext;
    if (contextForLetter == null) {
      return;
    }

    await Scrollable.ensureVisible(
      contextForLetter,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      alignment: 0.06,
    );
  }

  Future<void> _removeHomeWidget(HomeWidgetEntry entry) async {
    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.background.withValues(alpha: 0),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          decoration: BoxDecoration(
            color: AppColors.glassDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Remove Widget', style: AppTypography.titleLarge),
              const SizedBox(height: 10),
              Text(
                entry.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Remove'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    final service = ref.read(appServiceProvider);
    final widgetsNotifier = ref.read(homeWidgetsProvider.notifier);
    await service.deleteWidgetId(entry.appWidgetId);
    await widgetsNotifier.removeWidget(entry.appWidgetId);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = ref.watch(groupedAppsProvider);
    final apps = ref.watch(displayAppsProvider);
    final starredPackages = ref.watch(starredAppsProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;
    final homeWidgets = ref.watch(homeWidgetsProvider);

    final letters = grouped.keys.toList(growable: false);
    final sidebarLetters = List<String>.generate(
      26,
      (index) => String.fromCharCode(65 + index),
      growable: false,
    );
    final availableSidebarLetters = letters
        .where((letter) => RegExp(r'^[A-Z]$').hasMatch(letter))
        .toSet();

    final starredApps = apps
        .where((app) => starredPackages.contains(app.packageName))
        .toList(growable: false);

    _sectionKeys
      ..removeWhere((key, _) => !letters.contains(key))
      ..addEntries(
        letters
            .where((letter) => !_sectionKeys.containsKey(letter))
            .map((letter) => MapEntry<String, GlobalKey>(letter, GlobalKey())),
      );

    _measureTopSections();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight - _topSectionsHeight;
            final minListViewport = (_appTileExtent * 5) + _letterHeaderExtent;
            final listViewportHeight = math.max(
              0.0,
              math.min(minListViewport, availableHeight),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  key: _topSectionsKey,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      const TimeHeader(),
                      const SizedBox(height: 32),
                      const SizedBox(height: 24),
                      _AddWidgetCard(onTap: _openWidgetPicker, scale: scale),
                      const SizedBox(height: 20),
                      if (homeWidgets.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.widgets_outlined,
                          label: 'Widgets',
                          scale: scale,
                        ),
                        const SizedBox(height: 10),
                        for (final entry in homeWidgets) ...[
                          GestureDetector(
                            onLongPress: () =>
                                unawaited(_removeHomeWidget(entry)),
                            child: Container(
                              height: _widgetHeight(entry),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh
                                    .withValues(alpha: 0.42),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.outlineVariant.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: HomeWidgetView(
                                widgetId: entry.appWidgetId,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                      const SizedBox(height: 16),
                      _SectionHeader(
                        icon: Icons.star,
                        label: 'Favourites',
                        scale: scale,
                      ),
                      const SizedBox(height: 10),
                      _StarredRow(apps: starredApps, scale: scale),
                      const SizedBox(height: 18),
                      _SectionHeader(
                        icon: Icons.sort_by_alpha,
                        label: 'All Apps',
                        scale: scale,
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                SizedBox(
                  height: listViewportHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            final edgeStop = rect.height <= 0
                                ? 0.08
                                : (14 / rect.height)
                                      .clamp(0.03, 0.2)
                                      .toDouble();
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.onSurface.withValues(alpha: 0),
                                AppColors.onSurface,
                                AppColors.onSurface,
                                AppColors.onSurface.withValues(alpha: 0),
                              ],
                              stops: [0, edgeStop, 1 - edgeStop, 1],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstIn,
                          child: CustomScrollView(
                            controller: _appsScrollController,
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              for (final letter in letters) ...[
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _LetterHeaderDelegate(
                                    letter: letter,
                                    keyWidget: Container(
                                      key: _sectionKeys[letter],
                                    ),
                                    scale: scale,
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    0,
                                  ),
                                  sliver: SliverList.builder(
                                    itemCount: grouped[letter]?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final letterApps =
                                          grouped[letter] ?? const <AppInfo>[];
                                      final app = letterApps[index];
                                      final isStarred = starredPackages
                                          .contains(app.packageName);
                                      return AppListTile(
                                        app: app,
                                        starred: isStarred,
                                        showDivider:
                                            index != letterApps.length - 1,
                                      );
                                    },
                                  ),
                                ),
                              ],
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 80),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (letters.isNotEmpty)
                        AlphabetSidebar(
                          letters: sidebarLetters,
                          availableLetters: availableSidebarLetters,
                          onLetterChanged: _jumpToLetter,
                          fontScaleFactor: scale,
                          isScrolling: _isAppsScrolling,
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _widgetHeight(HomeWidgetEntry entry) {
    final base = entry.minHeight.toDouble();
    if (base <= 0) {
      return 160;
    }
    return base.clamp(120, 280).toDouble();
  }
}

class _StarredRow extends ConsumerWidget {
  const _StarredRow({required this.apps, required this.scale});

  final List<AppInfo> apps;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (apps.isEmpty) {
      return Container(
        height: 52,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Long press any app to add it to favourites',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 12 * scale,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final app = apps[index];
          return _StarredAppChip(app: app, scale: scale);
        },
      ),
    );
  }
}

class _StarredAppChip extends ConsumerWidget {
  const _StarredAppChip({required this.app, required this.scale});

  final AppInfo app;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> launch() async {
      await ref.read(appServiceProvider).launchApp(app.packageName);
    }

    Future<void> openMenu(LongPressStartDetails details) async {
      final renderObject = Overlay.of(context).context.findRenderObject();
      if (renderObject is! RenderBox) {
        return;
      }

      final selected = await showMenu<String>(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(
            details.globalPosition.dx,
            details.globalPosition.dy,
            1,
            1,
          ),
          Offset.zero & renderObject.size,
        ),
        color: AppColors.surfaceContainerHigh,
        items: const [
          PopupMenuItem<String>(value: 'open', child: Text('Open')),
          PopupMenuItem<String>(
            value: 'unstar',
            child: Text('Remove from favourites'),
          ),
          PopupMenuItem<String>(value: 'app_info', child: Text('App info')),
          PopupMenuItem<String>(value: 'uninstall', child: Text('Uninstall')),
        ],
      );

      switch (selected) {
        case 'open':
          await launch();
          break;
        case 'unstar':
          await ref
              .read(starredAppsProvider.notifier)
              .toggleStarred(app.packageName);
          break;
        case 'app_info':
          await ref.read(appServiceProvider).openAppInfo(app.packageName);
          break;
        case 'uninstall':
          await ref.read(appServiceProvider).uninstallApp(app.packageName);
          break;
        default:
          break;
      }
    }

    return GestureDetector(
      onLongPressStart: (details) => unawaited(openMenu(details)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => unawaited(launch()),
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: app.icon.isNotEmpty
                    ? Image.memory(
                        app.icon,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      )
                    : const Icon(Icons.apps),
              ),
              const SizedBox(height: 8),
              Text(
                app.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.2,
                  fontSize: 11 * scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.scale,
  });

  final IconData icon;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.onSurface,
            letterSpacing: 0.8,
            fontSize: 14 * scale,
          ),
        ),
      ],
    );
  }
}

class _AddWidgetCard extends StatelessWidget {
  const _AddWidgetCard({required this.onTap, required this.scale});

  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedRoundedRectPainter(),
        child: Container(
          height: 56,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.onSurface.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.secondary, size: 18),
              const SizedBox(width: 8),
              Text(
                'ADD WIDGET',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.secondary,
                  letterSpacing: 0.8,
                  fontSize: 13 * scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 12.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);

    final paint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dash = 7.0;
    const gap = 5.0;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LetterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _LetterHeaderDelegate({
    required this.letter,
    required this.keyWidget,
    required this.scale,
  });

  final String letter;
  final Widget keyWidget;
  final double scale;

  @override
  double get minExtent => 24;

  @override
  double get maxExtent => 24;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.92),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          keyWidget,
          Text(
            letter,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 11 * scale,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _LetterHeaderDelegate oldDelegate) {
    return oldDelegate.letter != letter ||
        oldDelegate.keyWidget != keyWidget ||
        oldDelegate.scale != scale;
  }
}
