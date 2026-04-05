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
  const AppDrawer({super.key, required this.onClose, this.initialLetter});

  final VoidCallback onClose;
  final String? initialLetter;

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  final AppService _service = AppService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Only auto-focus search bar if no initial letter is provided
      if (widget.initialLetter == null) {
        _searchFocusNode.requestFocus();
      } else {
        _scrollToLetter(widget.initialLetter!);
      }
    });
  }

  @override
  void dispose() {
    ref.read(searchQueryProvider.notifier).state = '';
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
    await _service.launchApp(app.packageName);
    if (mounted) {
      ref.read(searchQueryProvider.notifier).state = '';
      widget.onClose();
    }
  }

  void _dismissDrawer() {
    ref.read(searchQueryProvider.notifier).state = '';
    widget.onClose();
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

  Widget _buildAlphabetSidebar(List<AppInfo> apps) {
    final sorted = [...apps]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final grouped = _groupAppsByLetter(sorted);

    final allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split('');
    final availableLetters = grouped.keys.toSet();

    return AlphabetSidebar(
      letters: allLetters,
      availableLetters: availableLetters,
      onLetterChanged: _scrollToLetter,
      fontScaleFactor: 1.0,
      isScrolling: false,
    );
  }

  Map<String, List<AppInfo>> _groupAppsByLetter(List<AppInfo> source) {
    final grouped = <String, List<AppInfo>>{};
    for (final app in source) {
      final name = app.name.trim();
      final letter = name.isEmpty ? '#' : name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => <AppInfo>[]).add(app);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map<String, List<AppInfo>>.fromEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(filteredAppsProvider);
    final allApps = ref.watch(displayAppsProvider);
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
            child: wallpaper != null && wallpaper.isNotEmpty
                ? Image.memory(
                    wallpaper,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  )
                : Container(color: AppColors.background),
          ),
          Positioned.fill(child: Container(color: const Color(0x99000000))),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: const SizedBox.expand(),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.95,
              minChildSize: 0.75,
              maxChildSize: 0.98,
              snap: true,
              snapSizes: const [0.95],
              builder: (context, scrollController) {
                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutBack,
                  tween: Tween<double>(begin: 16, end: 0),
                  builder: (context, offsetY, child) {
                    return Transform.translate(
                      offset: Offset(0, offsetY),
                      child: child,
                    );
                  },
                  child: GlassCard(
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
                          child: _SearchBar(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: (value) {
                              ref.read(searchQueryProvider.notifier).state =
                                  value;
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Stack(
                            children: [
                              _GroupedAppList(
                                apps: apps,
                                onLaunch: _launchAndClose,
                                scrollController: scrollController,
                                physics: scrollPhysics,
                                sectionKeys: _sectionKeys,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: _buildAlphabetSidebar(apps),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: GlassCardLight(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          onChanged: onChanged,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurface),
          decoration: const InputDecoration(
            hintText: 'Search apps',
            prefixIcon: Icon(Icons.search, size: 20),
            prefixIconConstraints: BoxConstraints(minWidth: 36),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

class _GroupedAppList extends StatelessWidget {
  const _GroupedAppList({
    required this.apps,
    required this.onLaunch,
    required this.scrollController,
    required this.physics,
    required this.sectionKeys,
  });

  final List<AppInfo> apps;
  final Future<void> Function(AppInfo app) onLaunch;
  final ScrollController scrollController;
  final ScrollPhysics physics;
  final Map<String, GlobalKey> sectionKeys;

  @override
  Widget build(BuildContext context) {
    final sorted = [...apps]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final grouped = _groupAppsByLetter(sorted);

    // Populate section keys for each letter
    for (final letter in grouped.keys) {
      sectionKeys.putIfAbsent(letter, () => GlobalKey());
    }

    return CustomScrollView(
      controller: scrollController,
      primary: false,
      physics: physics,
      slivers: [
        for (final entry in grouped.entries) ...[
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
                onTap: () => unawaited(onLaunch(entry.value[index])),
              ),
              childCount: entry.value.length,
            ),
          ),
        ],
        if (grouped.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No apps found')),
          ),
      ],
    );
  }

  Map<String, List<AppInfo>> _groupAppsByLetter(List<AppInfo> source) {
    final grouped = <String, List<AppInfo>>{};
    for (final app in source) {
      final name = app.name.trim();
      final letter = name.isEmpty ? '#' : name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => <AppInfo>[]).add(app);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map<String, List<AppInfo>>.fromEntries(entries);
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

class _AppItem extends ConsumerWidget {
  const _AppItem({required this.app, required this.onTap});

  final AppInfo app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = ref.watch(iconThemeProvider);

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
