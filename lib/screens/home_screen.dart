import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alphabet_sidebar.dart';
import '../widgets/app_list_tile.dart';
import '../widgets/time_header.dart';
import 'stillmax_settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _appsScrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{};

  Timer? _scrollIdleTimer;
  bool _isAppsScrolling = false;

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

    final key = _sectionKeys[letter];
    if (key == null || !mounted) {
      return;
    }

    final contextForLetter = key.currentContext;
    if (contextForLetter == null) {
      return;
    }

    Scrollable.ensureVisible(
      contextForLetter,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      alignment: 0.06,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = ref.watch(groupedAppsProvider);
    final apps = ref.watch(displayAppsProvider);
    final starredPackages = ref.watch(starredAppsProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;

    final letters = grouped.keys.toList(growable: false);
    final sidebarLetters = [
      '★',
      ...List<String>.generate(
        26,
        (index) => String.fromCharCode(65 + index),
        growable: false,
      ),
    ];
    final availableSidebarLetters = {
      '★', // Star is always active
      ...letters.where((letter) => RegExp(r'^[A-Z]$').hasMatch(letter)),
    };

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

    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Clock + weather (fixed, never scrolls)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: TimeHeader(),
            ),

            const SizedBox(height: 16),

            // 2. Favourites header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.secondary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'FAVOURITES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.60),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 3. Favourites list — exactly as many tiles as starred apps (max 5)
            // NO fixed height container — let it size to its content naturally
            if (starredApps.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      color: Colors.white.withValues(alpha: 0.45),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: starredApps
                      .map(
                        (app) => AppListTile(
                          app: app,
                          starred: true,
                          showDivider: false,
                        ),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(height: 12),

            // 4. All Apps header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'AZ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ALL APPS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.60),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // 5. All apps list — fills ALL remaining space, scrollable
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _appsScrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _calculateTotalItems(grouped, letters),
                    itemBuilder: (context, index) {
                      return _buildListItem(
                        index,
                        grouped,
                        letters,
                        starredPackages,
                        scale,
                      );
                    },
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
        ),
      ),
    );
  }

  int _calculateTotalItems(
    Map<String, List<AppInfo>> grouped,
    List<String> letters,
  ) {
    var count = 0;
    for (final letter in letters) {
      count++; // Header
      count += grouped[letter]?.length ?? 0; // Apps in this letter group
    }
    count++; // Stillmax Settings tile at the end
    return count;
  }

  Widget _buildListItem(
    int index,
    Map<String, List<AppInfo>> grouped,
    List<String> letters,
    List<String> starredPackages,
    double scale,
  ) {
    var currentIndex = 0;

    // Iterate through each letter group
    for (var i = 0; i < letters.length; i++) {
      final letter = letters[i];
      final letterApps = grouped[letter] ?? const <AppInfo>[];

      // Check if this index is the header
      if (currentIndex == index) {
        return _LetterHeader(
          letter: letter,
          keyWidget: Container(key: _sectionKeys[letter]),
          scale: scale,
        );
      }
      currentIndex++;

      // Check if this index is one of the apps in this letter group
      if (index < currentIndex + letterApps.length) {
        final appIndex = index - currentIndex;
        final app = letterApps[appIndex];
        final isStarred = starredPackages.contains(app.packageName);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppListTile(app: app, starred: isStarred, showDivider: false),
        );
      }
      currentIndex += letterApps.length;
    }

    // Last item: Stillmax Settings tile
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Divider(color: Colors.white.withValues(alpha: 0.12), thickness: 0.5),
          const SizedBox(height: 16),
          _SettingsTile(scale: scale),
        ],
      ),
    );
  }
}

class _LetterHeader extends StatelessWidget {
  const _LetterHeader({
    required this.letter,
    required this.keyWidget,
    required this.scale,
  });

  final String letter;
  final Widget keyWidget;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
      child: Row(
        children: [
          keyWidget,
          Text(
            letter,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.secondary.withValues(alpha: 0.15),
          highlightColor: AppColors.secondary.withValues(alpha: 0.08),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const StillmaxSettingsScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.secondary,
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stillmax Settings',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Personalise your launcher',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.30),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
