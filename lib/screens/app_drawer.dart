import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../services/icon_resolver.dart';
import '../services/icon_theme_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alphabet_sidebar.dart';
import '../widgets/glass_card.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({
    super.key,
    required this.onClose,
    this.initialLetter,
    this.showAppsInitially = false,
  });

  final VoidCallback onClose;
  final String? initialLetter;
  final bool showAppsInitially;

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  final AppService _service = AppService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Map<String, GlobalKey> _sectionKeys = {};
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final ValueNotifier<String> _effectiveSearchQuery = ValueNotifier<String>('');
  Timer? _searchDebounce;
  Timer? _initialFocusTimer;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.initialLetter == null) {
        _initialFocusTimer = Timer(const Duration(milliseconds: 140), () {
          if (!mounted) {
            return;
          }
          _searchFocusNode.requestFocus();
        });
      } else {
        _initialFocusTimer = Timer(const Duration(milliseconds: 220), () {
          if (!mounted) {
            return;
          }
          _scrollToLetter(widget.initialLetter!);
        });
      }
    });
  }

  void _onSheetChanged() {
    // Close drawer when dragged below 60% of screen
    if (_sheetController.size < 0.6) {
      _dismissDrawer();
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    _initialFocusTimer?.cancel();
    _searchDebounce?.cancel();
    _effectiveSearchQuery.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _launchAndClose(AppInfo app) async {
    final hapticsEnabled =
        ref.read(settingsProvider).valueOrNull?.hapticsEnabled ?? true;
    if (hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
    await _service.launchApp(app);
    if (mounted) {
      _resetSearch();
      widget.onClose();
    }
  }

  void _dismissDrawer() {
    _searchFocusNode.unfocus();
    _resetSearch();
    widget.onClose();
  }

  void _resetSearch() {
    _searchDebounce?.cancel();
    _searchDebounce = null;
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
    }
    _effectiveSearchQuery.value = '';
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    if (value.trim().isEmpty) {
      _effectiveSearchQuery.value = '';
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 80), () {
      if (!mounted) {
        return;
      }
      _effectiveSearchQuery.value = value;
    });
  }

  void _scrollToLetter(String letter) {
    final key = _sectionKeys[letter];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Map<String, List<AppInfo>> _groupAppsByLetter(List<AppInfo> source) {
    if (source.isEmpty) {
      return const <String, List<AppInfo>>{};
    }

    final sorted = [...source]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final grouped = <String, List<AppInfo>>{};
    for (final app in sorted) {
      final name = app.name.trim();
      final letter = name.isEmpty ? '#' : name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => <AppInfo>[]).add(app);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map<String, List<AppInfo>>.fromEntries(entries);
  }

  void _syncSectionKeys(Iterable<String> letters) {
    final active = letters.toSet();
    _sectionKeys.removeWhere((key, _) => !active.contains(key));
    for (final letter in active) {
      _sectionKeys.putIfAbsent(letter, () => GlobalKey());
    }
  }

  List<AppInfo> _filterApps(List<AppInfo> source, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return const <AppInfo>[];
    }

    return source
        .where((app) => app.name.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  Widget _buildAlphabetSidebar(Set<String> availableLetters) {
    return AlphabetSidebar(
      letters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split(''),
      availableLetters: availableLetters,
      onLetterChanged: _scrollToLetter,
      fontScaleFactor: 1.0,
      isScrolling: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allApps = ref.watch(displayAppsProvider);
    final iconTheme = ref.watch(iconThemeProvider);
    final wallpaper = ref.watch(wallpaperBytesProvider).valueOrNull;
    final scrollPhysics = allApps.length > 40
        ? const ClampingScrollPhysics()
        : const BouncingScrollPhysics();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _dismissDrawer,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: wallpaper != null && wallpaper.isNotEmpty
                  ? Image.memory(
                      wallpaper,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    )
                  : Container(color: AppColors.background),
            ),
          ),
          Positioned.fill(child: Container(color: const Color(0x88000000))),
          Positioned.fill(
            child: RepaintBoundary(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.95,
              minChildSize: 0.5,
              maxChildSize: 0.98,
              snap: true,
              snapSizes: const [0.95],
              builder: (context, scrollController) {
                return GlassCard(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _SimpleSearchBar(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onChanged: _onSearchChanged,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _dismissDrawer,
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white.withValues(alpha: 0.76),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ValueListenableBuilder<String>(
                          valueListenable: _effectiveSearchQuery,
                          builder: (context, effectiveQuery, _) {
                            if (effectiveQuery.trim().isEmpty) {
                              _syncSectionKeys(const <String>[]);
                              return const _EmptyState();
                            }

                            final filteredApps = _filterApps(
                              allApps,
                              effectiveQuery,
                            );
                            final groupedApps = _groupAppsByLetter(
                              filteredApps,
                            );
                            _syncSectionKeys(groupedApps.keys);

                            return Stack(
                              children: [
                                _GroupedAppList(
                                  groupedApps: groupedApps,
                                  iconTheme: iconTheme,
                                  onLaunch: _launchAndClose,
                                  scrollController: scrollController,
                                  physics: scrollPhysics,
                                  sectionKeys: _sectionKeys,
                                ),
                                if (groupedApps.isNotEmpty)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: _buildAlphabetSidebar(
                                      groupedApps.keys.toSet(),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleSearchBar extends StatelessWidget {
  const _SimpleSearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            onChanged: onChanged,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onSurface,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Search apps',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 15,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: Colors.white.withValues(alpha: 0.72),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 38),
              suffixIcon: hasText
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                        focusNode.requestFocus();
                      },
                      splashRadius: 18,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 36),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 48,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            DefaultTextStyle(
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
              child: const Text(
                'Type to search apps',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupedAppList extends StatelessWidget {
  const _GroupedAppList({
    required this.groupedApps,
    required this.iconTheme,
    required this.onLaunch,
    required this.scrollController,
    required this.physics,
    required this.sectionKeys,
  });

  final Map<String, List<AppInfo>> groupedApps;
  final AppIconTheme iconTheme;
  final Future<void> Function(AppInfo app) onLaunch;
  final ScrollController scrollController;
  final ScrollPhysics physics;
  final Map<String, GlobalKey> sectionKeys;

  @override
  Widget build(BuildContext context) {
    // Populate section keys for each letter
    for (final letter in groupedApps.keys) {
      sectionKeys.putIfAbsent(letter, () => GlobalKey());
    }

    return CustomScrollView(
      controller: scrollController,
      primary: false,
      physics: physics,
      slivers: [
        for (final entry in groupedApps.entries) ...[
          SliverPersistentHeader(
            pinned: true,
            delegate: _SectionHeaderDelegate(
              letter: entry.key,
              sectionKey: sectionKeys[entry.key],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _AppItem(
                app: entry.value[index],
                iconTheme: iconTheme,
                onTap: () => unawaited(onLaunch(entry.value[index])),
              ),
              childCount: entry.value.length,
            ),
          ),
        ],
        if (groupedApps.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.app_blocking_outlined,
                    size: 48,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  DefaultTextStyle(
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                    child: const Text('No apps found'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SectionHeaderDelegate({required this.letter, this.sectionKey});

  final String letter;
  final GlobalKey? sectionKey;

  @override
  double get minExtent => 32;

  @override
  double get maxExtent => 32;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      key: sectionKey,
      color: AppColors.surface.withValues(alpha: 0.82),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      alignment: Alignment.centerLeft,
      child: Text(
        letter,
        style: AppTypography.labelLarge.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate oldDelegate) {
    return oldDelegate.letter != letter;
  }
}

class _AppItem extends StatelessWidget {
  const _AppItem({
    required this.app,
    required this.iconTheme,
    required this.onTap,
  });

  final AppInfo app;
  final AppIconTheme iconTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget buildIcon() {
      switch (iconTheme) {
        case AppIconTheme.fun:
          final iconData = funIconMap[app.packageName] ?? funFallbackIcon;
          final bgColor = getColorFromPackageName(app.packageName);
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
            ),
            child: Icon(iconData, size: 20, color: Colors.white),
          );

        case AppIconTheme.cute:
          final iconData = cuteIconMap[app.packageName] ?? cuteFallbackIcon;
          final bgColor = getPastelColorFromPackageName(app.packageName);
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
            ),
            child: Icon(
              iconData,
              size: 20,
              color: Colors.black.withValues(alpha: 0.7),
            ),
          );

        case AppIconTheme.dark:
        case AppIconTheme.defaultTheme:
          final iconColorFilter = IconThemeService.getColorFilterForTheme(
            iconTheme,
          );
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: app.icon.isNotEmpty
                ? ColorFiltered(
                    colorFilter: iconColorFilter,
                    child: Image.memory(
                      app.icon,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    color: AppColors.surfaceContainerHigh,
                    child: const Icon(Icons.apps, size: 20),
                  ),
          );
      }
    }

    return SizedBox(
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                buildIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    app.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 16,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
