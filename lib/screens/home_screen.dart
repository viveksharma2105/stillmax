import 'dart:async';
import 'dart:math' show min;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alphabet_sidebar.dart';
import '../widgets/app_list_tile.dart';
import '../widgets/time_header.dart';
import 'app_drawer.dart';
import 'stillmax_settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const double _homeSidebarTouchWidth = 62.0;
  static const double _homeSidebarItemWidth = 38.0;
  static const double _homeSidebarEdgeActivationSlop = 34.0;

  final ScrollController _appsScrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    for (int i = 0; i < 26; i++) String.fromCharCode(65 + i): GlobalKey(),
  };

  Timer? _scrollIdleTimer;
  bool _isAppsScrolling = false;
  bool _showAppDrawer = false;
  String? _drawerInitialLetter;
  bool _isAllAppsMode = false;
  double? _swipeUpStartX;
  double _downwardDragDy = 0.0;
  String? _pendingSectionLetter;
  bool _sectionJumpScheduled = false;
  int _sectionJumpRetryCount = 0;
  StreamSubscription<void>? _homeSubscription;

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

    // Subscribe to home button events
    final appService = ref.read(appServiceProvider);
    _homeSubscription = appService.onHomePressed.listen((_) {
      if (mounted && _showAppDrawer) {
        _closeAppDrawer();
      }
    });
  }

  @override
  void dispose() {
    _scrollIdleTimer?.cancel();
    _homeSubscription?.cancel();
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

  void _openStillmaxSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StillmaxSettingsScreen()),
    );
  }

  void _goToFavorites() {
    final alreadyAtFavorites = !_isAllAppsMode;
    final hasClients = _appsScrollController.hasClients;
    final atTop = !hasClients || _appsScrollController.offset <= 0.5;

    if (alreadyAtFavorites && atTop) {
      return;
    }

    if (!alreadyAtFavorites) {
      setState(() {
        _isAllAppsMode = false;
      });
    }

    if (hasClients) {
      if (atTop) {
        _appsScrollController.jumpTo(0);
      } else {
        _appsScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _scheduleSectionJumpIfNeeded() {
    if (_sectionJumpScheduled) {
      return;
    }

    _sectionJumpScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sectionJumpScheduled = false;
      if (!mounted) {
        return;
      }

      final targetLetter = _pendingSectionLetter;
      if (targetLetter == null) {
        return;
      }

      final sectionContext = _sectionKeys[targetLetter]?.currentContext;
      if (sectionContext == null) {
        if (_sectionJumpRetryCount < 1) {
          // Retry once on next frame in case section keys mount slightly later.
          _sectionJumpRetryCount++;
          _scheduleSectionJumpIfNeeded();
          return;
        }

        _pendingSectionLetter = null;
        _sectionJumpRetryCount = 0;
        return;
      }

      _pendingSectionLetter = null;
      _sectionJumpRetryCount = 0;
      Scrollable.ensureVisible(
        sectionContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: 0,
      );
    });
  }

  void _scrollToSection(String letter) {
    _pendingSectionLetter = letter;
    _sectionJumpRetryCount = 0;

    if (!_isAllAppsMode) {
      setState(() {
        _isAllAppsMode = true;
      });
    }

    _scheduleSectionJumpIfNeeded();
  }

  double _sidebarProtectedBoundary(
    double screenWidth,
    double sidebarHorizontalOffset,
  ) {
    const guardPx = 20.0;
    final rightProtectionBoundary =
        screenWidth -
        (sidebarHorizontalOffset +
            _homeSidebarTouchWidth +
            _homeSidebarEdgeActivationSlop +
            guardPx);
    return min(screenWidth * 0.75, rightProtectionBoundary);
  }

  void _onSidebarLetterTap(String letter) {
    if (letter == '#') {
      _openStillmaxSettings();
      return;
    }

    if (letter == '★') {
      _goToFavorites();
      return;
    }

    _scrollToSection(letter);
  }

  void _onSidebarLetterPreview(String letter) {
    if (letter == '#') {
      return;
    }

    if (letter == '★') {
      final alreadyFavorites = !_isAllAppsMode;
      if (alreadyFavorites) {
        return;
      }
      _goToFavorites();
      return;
    }

    _scrollToSection(letter);
  }

  void _onSidebarInteractionEnd() {}

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(displayAppsProvider);
    final starredPackages = ref.watch(starredAppsProvider);
    final wallpaper = ref.watch(wallpaperBytesProvider).valueOrNull;
    final hasValidWallpaper =
        wallpaper != null &&
        wallpaper.isNotEmpty &&
        wallpaper.length <= kMaxWallpaperBytes;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;
    final clockSpacing = (settings?.clockSpacing ?? 40.0).clamp(0.0, 200.0);
    final favoritesSpacing = (settings?.favoritesSpacing ?? 8.0).clamp(
      0.0,
      100.0,
    );
    final sidebarSpacing = (settings?.sidebarSpacing ?? 16.0).clamp(0.0, 100.0);
    final sidebarHorizontalOffset = (settings?.sidebarHorizontalOffset ?? 16.0)
        .clamp(0.0, 100.0);
    final layoutAdjustMode = ref.watch(layoutAdjustModeProvider);

    final navBarHeight = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    final alphabetLetters = List<String>.generate(
      26,
      (index) => String.fromCharCode(65 + index),
      growable: false,
    );
    final sidebarLetters = ['★', ...alphabetLetters, '#'];
    // All letters are available since they all filter now
    final availableSidebarLetters = {
      '★',
      ...List.generate(26, (i) => String.fromCharCode(65 + i)),
      '#',
    };

    final groupedApps = {
      for (final letter in alphabetLetters) letter: <AppInfo>[],
    };
    final otherApps = <AppInfo>[];
    for (final app in apps) {
      final trimmed = app.name.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final firstChar = trimmed[0].toUpperCase();
      if (groupedApps.containsKey(firstChar)) {
        groupedApps[firstChar]!.add(app);
      } else {
        otherApps.add(app);
      }
    }

    final List<AppInfo> favoriteApps;
    final String sectionTitle;

    if (!_isAllAppsMode) {
      favoriteApps = apps
          .where((app) => identityCollectionContainsApp(starredPackages, app))
          .toList();
      sectionTitle = 'FAVOURITES';
    } else {
      favoriteApps = const <AppInfo>[];
      sectionTitle = 'ALL APPS';
    }

    return PopScope(
      canPop: !_showAppDrawer,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _showAppDrawer) {
          _closeAppDrawer();
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: hasValidWallpaper
                ? Image.memory(
                    wallpaper,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFF090909));
                    },
                  )
                : Container(color: const Color(0xFF090909)),
          ),
          Positioned.fill(child: Container(color: const Color(0x66000000))),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: const SizedBox.expand(),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: _openStillmaxSettings,
              child: Column(
                children: [
                  // ZONE 1 — Fixed header, never scrolls
                  Padding(
                    padding: EdgeInsets.only(top: clockSpacing),
                    child: const TimeHeader(),
                  ),

                  // ZONE 2 — Favorites list (static, no scroll)
                  Expanded(
                    child: Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragDown: (details) {
                            _swipeUpStartX = details.globalPosition.dx;
                            _downwardDragDy = 0.0;
                          },
                          onVerticalDragUpdate: (details) {
                            _downwardDragDy =
                                (_downwardDragDy + details.delta.dy).clamp(
                                  0.0,
                                  5000.0,
                                );
                          },
                          onVerticalDragCancel: () {
                            _swipeUpStartX = null;
                            _downwardDragDy = 0.0;
                          },
                          onVerticalDragEnd: (details) {
                            final startX = _swipeUpStartX;
                            _swipeUpStartX = null;
                            final dragDistance = _downwardDragDy;
                            _downwardDragDy = 0.0;
                            final velocity = details.primaryVelocity;

                            if (startX == null) {
                              return;
                            }

                            final allowedBoundary = _sidebarProtectedBoundary(
                              screenWidth,
                              sidebarHorizontalOffset,
                            );
                            if (startX > allowedBoundary) {
                              return;
                            }

                            if (_isAllAppsMode) {
                              final atTop =
                                  !_appsScrollController.hasClients ||
                                  _appsScrollController.offset <= 4.0;

                              // In all-apps list at top (A), downward slide returns to favourites.
                              if (atTop &&
                                  ((velocity != null && velocity > 100) ||
                                      dragDistance > 24.0)) {
                                _goToFavorites();
                              }
                              return;
                            }

                            if (velocity != null && velocity < -100) {
                              _openAppDrawer();
                            }
                          },
                          child: ListView(
                            controller: _appsScrollController,
                            physics: !_isAllAppsMode
                                ? const NeverScrollableScrollPhysics()
                                : const ClampingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              SizedBox(height: favoritesSpacing),

                              // Section header with crossfade transition
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  top: 4,
                                  bottom: 2,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Row(
                                    key: ValueKey(sectionTitle),
                                    children: [
                                      if (!_isAllAppsMode) ...[
                                        Icon(
                                          Icons.star,
                                          color: AppColors.secondary,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Text(
                                        sectionTitle,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(
                                            alpha: 0.35,
                                          ),
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // App tiles
                              if (!_isAllAppsMode)
                                if (favoriteApps.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
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
                                  )
                                else
                                  ...favoriteApps.map(
                                    (app) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: AppListTile(
                                        app: app,
                                        starred: identityCollectionContainsApp(
                                          starredPackages,
                                          app,
                                        ),
                                        showDivider: false,
                                      ),
                                    ),
                                  )
                              else if (groupedApps.values.every(
                                    (letterApps) => letterApps.isEmpty,
                                  ) &&
                                  otherApps.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'No apps available',
                                      style: TextStyle(
                                        fontSize: 12 * scale,
                                        color: Colors.white.withValues(
                                          alpha: 0.45,
                                        ),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...alphabetLetters.expand((letter) {
                                  final letterApps = groupedApps[letter]!;
                                  if (letterApps.isEmpty) {
                                    return const <Widget>[];
                                  }
                                  return [
                                    Padding(
                                      key: _sectionKeys[letter],
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 8,
                                        bottom: 2,
                                      ),
                                      child: Text(
                                        letter,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(
                                            alpha: 0.35,
                                          ),
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    ...letterApps.map(
                                      (app) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: AppListTile(
                                          app: app,
                                          starred:
                                              identityCollectionContainsApp(
                                                starredPackages,
                                                app,
                                              ),
                                          showDivider: false,
                                        ),
                                      ),
                                    ),
                                  ];
                                }),
                                if (otherApps.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 8,
                                      bottom: 2,
                                    ),
                                    child: Text(
                                      'OTHER',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(
                                          alpha: 0.35,
                                        ),
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  ...otherApps.map(
                                    (app) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: AppListTile(
                                        app: app,
                                        starred: identityCollectionContainsApp(
                                          starredPackages,
                                          app,
                                        ),
                                        showDivider: false,
                                      ),
                                    ),
                                  ),
                                ],

                              const SizedBox(height: 12),
                              SizedBox(height: navBarHeight + 80),
                            ],
                          ),
                        ),

                        // Alphabet sidebar - stays pinned
                        Positioned(
                          right: 0,
                          top: sidebarSpacing,
                          bottom: navBarHeight + 80,
                          child: AlphabetSidebar(
                            letters: sidebarLetters,
                            availableLetters: availableSidebarLetters,
                            onLetterChanged: _onSidebarLetterTap,
                            onLetterTap: _onSidebarLetterTap,
                            onLetterPreview: _onSidebarLetterPreview,
                            onInteractionEnd: _onSidebarInteractionEnd,
                            underflowLetter: '★',
                            fontScaleFactor: scale,
                            isScrolling: _isAppsScrolling,
                            touchWidth: _homeSidebarTouchWidth,
                            itemWidth: _homeSidebarItemWidth,
                            rightInset: sidebarHorizontalOffset,
                            edgeActivationSlop: _homeSidebarEdgeActivationSlop,
                          ),
                        ),

                        // Layout adjustment mode overlay with fade transition
                        if (layoutAdjustMode)
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: layoutAdjustMode ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: IgnorePointer(
                                ignoring: !layoutAdjustMode,
                                child: _LayoutAdjustmentOverlay(
                                  currentClockSpacing: clockSpacing,
                                  currentFavoritesSpacing: favoritesSpacing,
                                  currentSidebarSpacing: sidebarSpacing,
                                  currentSidebarHorizontalOffset:
                                      sidebarHorizontalOffset,
                                  onClockSpacingChanged: (newSpacing) async {
                                    await ref
                                        .read(settingsNotifierProvider)
                                        .updateClockSpacing(newSpacing);
                                  },
                                  onFavoritesSpacingChanged:
                                      (newSpacing) async {
                                        await ref
                                            .read(settingsNotifierProvider)
                                            .updateFavoritesSpacing(newSpacing);
                                      },
                                  onSidebarSpacingChanged: (newSpacing) async {
                                    await ref
                                        .read(settingsNotifierProvider)
                                        .updateSidebarSpacing(newSpacing);
                                  },
                                  onSidebarHorizontalOffsetChanged:
                                      (newOffset) async {
                                        await ref
                                            .read(settingsNotifierProvider)
                                            .updateSidebarHorizontalOffset(
                                              newOffset,
                                            );
                                      },
                                  onDone: () {
                                    ref
                                            .read(
                                              layoutAdjustModeProvider.notifier,
                                            )
                                            .state =
                                        false;
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                child: child,
              );
            },
            child: _showAppDrawer
                ? AppDrawer(
                    key: const ValueKey('drawer'),
                    onClose: _closeAppDrawer,
                    initialLetter: _drawerInitialLetter,
                    showAppsInitially: false,
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}

class _LayoutAdjustmentOverlay extends StatefulWidget {
  const _LayoutAdjustmentOverlay({
    required this.currentClockSpacing,
    required this.currentFavoritesSpacing,
    required this.currentSidebarSpacing,
    required this.currentSidebarHorizontalOffset,
    required this.onClockSpacingChanged,
    required this.onFavoritesSpacingChanged,
    required this.onSidebarSpacingChanged,
    required this.onSidebarHorizontalOffsetChanged,
    required this.onDone,
  });

  final double currentClockSpacing;
  final double currentFavoritesSpacing;
  final double currentSidebarSpacing;
  final double currentSidebarHorizontalOffset;
  final ValueChanged<double> onClockSpacingChanged;
  final ValueChanged<double> onFavoritesSpacingChanged;
  final ValueChanged<double> onSidebarSpacingChanged;
  final ValueChanged<double> onSidebarHorizontalOffsetChanged;
  final VoidCallback onDone;

  @override
  State<_LayoutAdjustmentOverlay> createState() =>
      _LayoutAdjustmentOverlayState();
}

class _LayoutAdjustmentOverlayState extends State<_LayoutAdjustmentOverlay> {
  late double _tempClockSpacing;
  late double _tempFavoritesSpacing;
  late double _tempSidebarSpacing;
  late double _tempSidebarHorizontalOffset;
  String _selectedSpacingType = 'time'; // 'time', 'favorites', 'sidebar'
  Timer? _adjustTimer;

  @override
  void initState() {
    super.initState();
    _tempClockSpacing = widget.currentClockSpacing;
    _tempFavoritesSpacing = widget.currentFavoritesSpacing;
    _tempSidebarSpacing = widget.currentSidebarSpacing;
    _tempSidebarHorizontalOffset = widget.currentSidebarHorizontalOffset;
  }

  void _startContinuousAdjust(double delta) {
    _adjustTimer?.cancel();
    _adjustTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      _updateSelectedSpacing(delta);
    });
  }

  void _stopContinuousAdjust() {
    _adjustTimer?.cancel();
    _adjustTimer = null;
  }

  @override
  void dispose() {
    _adjustTimer?.cancel();
    super.dispose();
  }

  double get _currentSelectedSpacing {
    switch (_selectedSpacingType) {
      case 'time':
        return _tempClockSpacing;
      case 'favorites':
        return _tempFavoritesSpacing;
      case 'sidebar':
        return _tempSidebarSpacing;
      case 'sidebar-horizontal':
        return _tempSidebarHorizontalOffset;
      default:
        return _tempClockSpacing;
    }
  }

  void _updateSelectedSpacing(double delta) {
    setState(() {
      switch (_selectedSpacingType) {
        case 'time':
          _tempClockSpacing = (_tempClockSpacing + delta).clamp(0.0, 200.0);
          widget.onClockSpacingChanged(_tempClockSpacing);
          break;
        case 'favorites':
          _tempFavoritesSpacing = (_tempFavoritesSpacing + delta).clamp(
            0.0,
            100.0,
          );
          widget.onFavoritesSpacingChanged(_tempFavoritesSpacing);
          break;
        case 'sidebar':
          _tempSidebarSpacing = (_tempSidebarSpacing + delta).clamp(0.0, 100.0);
          widget.onSidebarSpacingChanged(_tempSidebarSpacing);
          break;
        case 'sidebar-horizontal':
          _tempSidebarHorizontalOffset = (_tempSidebarHorizontalOffset + delta)
              .clamp(0.0, 100.0);
          widget.onSidebarHorizontalOffsetChanged(_tempSidebarHorizontalOffset);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    // TimeHeader is approximately 120px tall (statusBarHeight + 8 + clock height + weather)
    // Let's calculate the position for the drag handle
    final timeHeaderHeight = statusBarHeight + 112;
    final handleTop = timeHeaderHeight + _tempClockSpacing;

    return Stack(
      children: [
        // Semi-transparent overlay
        Container(color: const Color(0x88000000)),

        // Selection chips at the top
        Positioned(
          left: 16,
          right: 16,
          top: statusBarHeight + 16,
          child: Column(
            children: [
              // Chip buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSpacingChip('time', 'Time'),
                  const SizedBox(width: 8),
                  _buildSpacingChip('favorites', 'Favorites'),
                  const SizedBox(width: 8),
                  _buildSpacingChip('sidebar', 'Sidebar'),
                ],
              ),
              const SizedBox(height: 12),
              // Current value display
              Text(
                '${_currentSelectedSpacing.toStringAsFixed(1)} px',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Drag handle line and pill with arrow buttons
        Positioned(
          left: 0,
          right: 0,
          top: handleTop,
          child: Column(
            children: [
              // Up arrow button
              GestureDetector(
                onTap: () => _updateSelectedSpacing(-5.0),
                onLongPress: () {}, // Absorb to prevent settings opening
                onLongPressStart: (_) => _startContinuousAdjust(-2.0),
                onLongPressEnd: (_) => _stopContinuousAdjust(),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: AppColors.secondary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Drag handle with gesture detector
              GestureDetector(
                onVerticalDragUpdate: (details) =>
                    _updateSelectedSpacing(details.delta.dy),
                child: Column(
                  children: [
                    // Drag handle pill
                    Container(
                      width: 80,
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
              const SizedBox(height: 8),
              // Down arrow button
              GestureDetector(
                onTap: () => _updateSelectedSpacing(5.0),
                onLongPress: () {}, // Absorb to prevent settings opening
                onLongPressStart: (_) => _startContinuousAdjust(2.0),
                onLongPressEnd: (_) => _stopContinuousAdjust(),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.secondary,
                    size: 40,
                  ),
                ),
              ),

              // Show left/right arrows only when sidebar is selected
              if (_selectedSpacingType == 'sidebar') ...[
                const SizedBox(height: 24),
                // Horizontal adjustment label
                Text(
                  'Horizontal Position',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Left and Right arrow buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left arrow button
                    GestureDetector(
                      onTap: () {
                        setState(
                          () => _selectedSpacingType = 'sidebar-horizontal',
                        );
                        _updateSelectedSpacing(-5.0);
                        setState(() => _selectedSpacingType = 'sidebar');
                      },
                      onLongPress: () {}, // Absorb to prevent settings opening
                      onLongPressStart: (_) {
                        setState(
                          () => _selectedSpacingType = 'sidebar-horizontal',
                        );
                        _startContinuousAdjust(-2.0);
                      },
                      onLongPressEnd: (_) {
                        _stopContinuousAdjust();
                        setState(() => _selectedSpacingType = 'sidebar');
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: AppColors.secondary,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Current horizontal value display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_tempSidebarHorizontalOffset.toStringAsFixed(1)} px',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right arrow button
                    GestureDetector(
                      onTap: () {
                        setState(
                          () => _selectedSpacingType = 'sidebar-horizontal',
                        );
                        _updateSelectedSpacing(5.0);
                        setState(() => _selectedSpacingType = 'sidebar');
                      },
                      onLongPress: () {}, // Absorb to prevent settings opening
                      onLongPressStart: (_) {
                        setState(
                          () => _selectedSpacingType = 'sidebar-horizontal',
                        );
                        _startContinuousAdjust(2.0);
                      },
                      onLongPressEnd: (_) {
                        _stopContinuousAdjust();
                        setState(() => _selectedSpacingType = 'sidebar');
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: AppColors.secondary,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpacingChip(String type, String label) {
    final isSelected = _selectedSpacingType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedSpacingType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
