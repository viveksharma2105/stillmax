import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';

class BlackBoxVaultScreen extends ConsumerStatefulWidget {
  const BlackBoxVaultScreen({super.key, this.showWelcome = false});

  final bool showWelcome;

  @override
  ConsumerState<BlackBoxVaultScreen> createState() =>
      _BlackBoxVaultScreenState();
}

class _BlackBoxVaultScreenState extends ConsumerState<BlackBoxVaultScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController _gridAnimationController;
  StreamSubscription<void>? _homeSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _gridAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _gridAnimationController.forward();
    if (widget.showWelcome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWelcomeInfo();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final appService = ref.read(appServiceProvider);
      _homeSubscription = appService.onHomePressed.listen((_) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    });
  }

  @override
  void dispose() {
    _homeSubscription?.cancel();
    _gridAnimationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Close vault only when app truly goes to background
    // (hidden = user switched apps, detached = app is being terminated)
    // Don't close on inactive/paused as these fire for permission dialogs, app switcher, etc.
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void _showWelcomeInfo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOut,
        ),
        child: AlertDialog(
          backgroundColor: AppColors.glassDark,
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.secondary),
              const SizedBox(width: 12),
              const Text('Black Box Ready'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your hidden apps vault is set up!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text('To access your hidden apps:'),
              SizedBox(height: 8),
              Text('• Tap the media player card 4 times quickly'),
              SizedBox(height: 4),
              Text(
                '• The media player is on the left page of the clock header',
              ),
              SizedBox(height: 16),
              Text(
                'Hidden apps won\'t appear anywhere in the launcher - not in search, favorites, or the app list.',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchHiddenApp(HiddenAppDb app) async {
    try {
      final appService = ref.read(appServiceProvider);
      // Launch with FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS so hidden apps don't appear in recents
      await appService.launchAppHidden(app.packageName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to launch ${app.appName}')),
        );
      }
    }
  }

  Future<void> _unhideApp(HiddenAppDb app) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.glassDark,
        title: const Text('Unhide App'),
        content: Text('Move "${app.appName}" back to the main app list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Unhide'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await ref.read(hiddenAppsProvider.notifier).unhideApp(app.packageName);
  }

  Future<void> _addAppsToVault() async {
    final allApps = ref.read(appListProvider).valueOrNull ?? [];
    final hiddenApps = ref.read(hiddenAppsProvider).valueOrNull ?? [];
    final hiddenPackages = hiddenApps.map((h) => h.packageName).toSet();

    // Filter to show only visible apps (not already hidden)
    final visibleApps = allApps
        .where((app) => !hiddenPackages.contains(app.packageName))
        .toList();

    final selected = await showModalBottomSheet<List<AppInfo>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _AppPickerSheet(apps: visibleApps),
    );

    if (selected == null || selected.isEmpty || !mounted) return;

    final notifier = ref.read(hiddenAppsProvider.notifier);
    for (final app in selected) {
      await notifier.hideApp(app);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hiddenAppsAsync = ref.watch(hiddenAppsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 20, color: AppColors.secondary),
            const SizedBox(width: 8),
            const Text('Black Box'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAppsToVault,
            tooltip: 'Add apps',
          ),
        ],
      ),
      body: SafeArea(
        child: hiddenAppsAsync.when(
          data: (hiddenApps) => hiddenApps.isEmpty
              ? _buildEmptyState()
              : _buildAppGrid(hiddenApps),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_off_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No hidden apps',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add apps to your vault',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addAppsToVault,
            icon: const Icon(Icons.add),
            label: const Text('Add Apps'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppGrid(List<HiddenAppDb> apps) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        // Staggered animation delay based on index
        final delay = index * 50; // 50ms between each tile
        return _AnimatedAppTile(
          delay: delay,
          controller: _gridAnimationController,
          child: _HiddenAppTile(
            app: app,
            onTap: () => unawaited(_launchHiddenApp(app)),
            onLongPress: () => unawaited(_unhideApp(app)),
          ),
        );
      },
    );
  }
}

class _AnimatedAppTile extends StatelessWidget {
  const _AnimatedAppTile({
    required this.delay,
    required this.controller,
    required this.child,
  });

  final int delay;
  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        (delay / 600).clamp(0.0, 1.0),
        ((delay + 300) / 600).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
}

class _HiddenAppTile extends StatelessWidget {
  const _HiddenAppTile({
    required this.app,
    required this.onTap,
    required this.onLongPress,
  });

  final HiddenAppDb app;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surfaceContainerHigh,
            ),
            clipBehavior: Clip.antiAlias,
            child: app.icon.isNotEmpty
                ? Image.memory(Uint8List.fromList(app.icon), fit: BoxFit.cover)
                : const Icon(Icons.apps, color: Colors.white54),
          ),
          const SizedBox(height: 6),
          Text(
            app.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppPickerSheet extends ConsumerStatefulWidget {
  const _AppPickerSheet({required this.apps});

  final List<AppInfo> apps;

  @override
  ConsumerState<_AppPickerSheet> createState() => _AppPickerSheetState();
}

class _AppPickerSheetState extends ConsumerState<_AppPickerSheet> {
  final Set<String> _selected = {};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredApps = widget.apps
        .where(
          (app) =>
              _searchQuery.isEmpty ||
              app.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Apps to Hide',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (_selected.isNotEmpty)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(
                          widget.apps
                              .where((a) => _selected.contains(a.packageName))
                              .toList(),
                        ),
                        child: Text('Add (${_selected.length})'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search apps...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh.withValues(
                      alpha: 0.42,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredApps.length,
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                final isSelected = _selected.contains(app.packageName);
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.surfaceContainerHigh,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: app.icon.isNotEmpty
                        ? Image.memory(
                            Uint8List.fromList(app.icon),
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.apps),
                  ),
                  title: Text(app.name),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      setState(() {
                        if (isSelected) {
                          _selected.remove(app.packageName);
                        } else {
                          _selected.add(app.packageName);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(app.packageName);
                      } else {
                        _selected.add(app.packageName);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
