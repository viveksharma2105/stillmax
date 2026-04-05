import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alphabet_sidebar.dart';
import '../widgets/app_list_tile.dart';
import '../widgets/time_header.dart';
import 'app_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _appsScrollController = ScrollController();

  Timer? _scrollIdleTimer;
  bool _isAppsScrolling = false;
  bool _showAppDrawer = false;
  String? _drawerInitialLetter;

  @override
  void initState() {
    super.initState();
    _appsScrollController.addListener(_onAppsScroll);
    // Set system UI for edge-to-edge
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
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

  void _openAppDrawer({String? letter}) {
    setState(() {
      _drawerInitialLetter = letter;
      _showAppDrawer = true;
    });
  }

  void _closeAppDrawer() {
    if (!mounted) return;
    setState(() {
      _showAppDrawer = false;
      _drawerInitialLetter = null;
    });
  }

  void _jumpToLetter(String letter) {
    if (letter == '★') {
      // Scroll to top for star
      _appsScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      return;
    }

    // Open drawer with this letter
    _openAppDrawer(letter: letter);
  }

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(displayAppsProvider);
    final starredPackages = ref.watch(starredAppsProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;
    final clockSpacing = (settings?.clockSpacing ?? 40.0).clamp(0.0, 200.0);
    final layoutAdjustMode = ref.watch(layoutAdjustModeProvider);

    final navBarHeight = MediaQuery.of(context).padding.bottom;

    final sidebarLetters = [
      '★',
      ...List<String>.generate(
        26,
        (index) => String.fromCharCode(65 + index),
        growable: false,
      ),
    ];
    // All letters are available since they open the drawer
    final availableSidebarLetters = sidebarLetters.toSet();

    final starredApps = apps
        .where((app) => starredPackages.contains(app.packageName))
        .toList(growable: false);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF090909),
          body: Column(
            children: [
              // ZONE 1 — Fixed header, never scrolls
              const TimeHeader(),

              // ZONE 2 — Everything else scrolls
              Expanded(
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    // Swipe up detection (negative velocity = upward)
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity! < -300) {
                      _openAppDrawer();
                    }
                  },
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: _appsScrollController,
                        primary: false,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // Space after clock (adjustable)
                          SliverToBoxAdapter(
                            child: SizedBox(height: clockSpacing),
                          ),

                          // Favourites section header
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppColors.secondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'FAVOURITES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(
                                        alpha: 0.60,
                                      ),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Spacing after favourites header
                          const SliverToBoxAdapter(child: SizedBox(height: 8)),

                          // Starred app tiles
                          if (starredApps.isEmpty)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'No favourites yet. Manage favourites in Stillmax Settings.',
                                    style: TextStyle(
                                      fontSize: 12 * scale,
                                      color: Colors.white.withValues(
                                        alpha: 0.45,
                                      ),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: AppListTile(
                                    app: starredApps[index],
                                    starred: true,
                                    showDivider: false,
                                  ),
                                );
                              }, childCount: starredApps.length),
                            ),

                          // Spacing after favourites
                          const SliverToBoxAdapter(child: SizedBox(height: 12)),

                          // Bottom padding for navigation bar
                          SliverToBoxAdapter(
                            child: SizedBox(height: navBarHeight + 80),
                          ),
                        ],
                      ),

                      // Alphabet sidebar - stays pinned
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: navBarHeight + 80,
                        child: AlphabetSidebar(
                          letters: sidebarLetters,
                          availableLetters: availableSidebarLetters,
                          onLetterChanged: _jumpToLetter,
                          fontScaleFactor: scale,
                          isScrolling: _isAppsScrolling,
                        ),
                      ),

                      // Layout adjustment mode overlay
                      if (layoutAdjustMode)
                        Positioned.fill(
                          child: _LayoutAdjustmentOverlay(
                            currentSpacing: clockSpacing,
                            onSpacingChanged: (newSpacing) async {
                              await ref
                                  .read(settingsNotifierProvider)
                                  .updateClockSpacing(newSpacing);
                            },
                            onDone: () {
                              ref
                                      .read(layoutAdjustModeProvider.notifier)
                                      .state =
                                  false;
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showAppDrawer)
          AppDrawer(
            onClose: _closeAppDrawer,
            initialLetter: _drawerInitialLetter,
          ),
      ],
    );
  }
}

class _LayoutAdjustmentOverlay extends StatefulWidget {
  const _LayoutAdjustmentOverlay({
    required this.currentSpacing,
    required this.onSpacingChanged,
    required this.onDone,
  });

  final double currentSpacing;
  final ValueChanged<double> onSpacingChanged;
  final VoidCallback onDone;

  @override
  State<_LayoutAdjustmentOverlay> createState() =>
      _LayoutAdjustmentOverlayState();
}

class _LayoutAdjustmentOverlayState extends State<_LayoutAdjustmentOverlay> {
  late double _tempSpacing;

  @override
  void initState() {
    super.initState();
    _tempSpacing = widget.currentSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    // TimeHeader is approximately 120px tall (statusBarHeight + 8 + clock height + weather)
    // Let's calculate the position for the drag handle
    final timeHeaderHeight = statusBarHeight + 112;
    final handleTop = timeHeaderHeight + _tempSpacing;

    return Stack(
      children: [
        // Semi-transparent overlay
        Container(color: Colors.black.withValues(alpha: 0.6)),

        // Drag handle line and pill
        Positioned(
          left: 0,
          right: 0,
          top: handleTop,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _tempSpacing = (_tempSpacing + details.delta.dy).clamp(
                  0.0,
                  200.0,
                );
              });
              widget.onSpacingChanged(_tempSpacing);
            },
            child: Column(
              children: [
                // "Drag to adjust" label
                Text(
                  'Drag to adjust spacing',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Drag handle pill
                Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 2),
                // Full-width line
                Container(
                  height: 2,
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),

        // Done button at bottom
        Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 24,
          child: ElevatedButton(
            onPressed: widget.onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
