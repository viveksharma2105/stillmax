import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/app_service.dart';
import '../services/icon_resolver.dart';
import '../services/icon_theme_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widget_picker_sheet.dart';

class StillmaxSettingsScreen extends ConsumerStatefulWidget {
  const StillmaxSettingsScreen({super.key});

  @override
  ConsumerState<StillmaxSettingsScreen> createState() =>
      _StillmaxSettingsScreenState();
}

class _StillmaxSettingsScreenState
    extends ConsumerState<StillmaxSettingsScreen> {
  Future<void> _addHeaderWidgetSlot(bool leftSlot) async {
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
    if (!await appService.bindWidget(
          appWidgetId,
          selected.packageName,
          selected.className,
        ) ||
        !await appService.createWidgetView(appWidgetId)) {
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

  Future<void> _removeHeaderWidgetSlot(int widgetId, bool leftSlot) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.glassDark,
        title: const Text('Remove Widget'),
        content: const Text('Remove this widget slot?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
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

  Future<void> _addFavourite() async {
    final apps = ref.read(displayAppsProvider);
    final starredPackages = ref.read(starredAppsProvider);

    final selected = await showModalBottomSheet<AppInfo>(
      context: context,
      backgroundColor: AppColors.background.withValues(alpha: 0),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: _AppPickerSheet(
            apps: apps,
            currentStarred: starredPackages.toSet(),
          ),
        );
      },
    );

    if (selected == null || !mounted) {
      return;
    }

    final result = await ref
        .read(starredAppsProvider.notifier)
        .toggleStarred(selected.packageName);

    if (!mounted) {
      return;
    }

    if (result == StarredResult.limitReached) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Favourites limit reached')));
    }
  }

  Future<void> _removeFavourite(String packageName) async {
    await ref.read(starredAppsProvider.notifier).toggleStarred(packageName);
  }

  Future<void> _updateClockStyle(String style) async {
    final notifier = ref.read(settingsNotifierProvider);
    await notifier.updateClockStyle(style);
  }

  Future<void> _updateFontSize(double scale) async {
    final notifier = ref.read(settingsNotifierProvider);
    await notifier.updateFontScale(scale);
  }

  Future<void> _updateIconTheme(AppIconTheme theme) async {
    await ref.read(iconThemeProvider.notifier).setTheme(theme);
  }

  Future<void> _enterLayoutAdjustMode() async {
    ref.read(layoutAdjustModeProvider.notifier).state = true;
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;
    final clockStyle = settings?.clockStyle ?? 'digital';
    final leftWidgetSlotId = settings?.leftWidgetSlotId;
    final rightWidgetSlotId = settings?.rightWidgetSlotId;
    final iconTheme = ref.watch(iconThemeProvider);
    final iconColorFilter = IconThemeService.getColorFilterForTheme(iconTheme);
    final starredPackages = ref.watch(starredAppsProvider);
    final apps = ref.watch(displayAppsProvider);
    final starredApps = apps
        .where((app) => starredPackages.contains(app.packageName))
        .toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Stillmax Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favourites Manager
              _SectionTitle(title: 'Manage Favourites', scale: scale),
              Text(
                'Up to 5 apps',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12 * scale,
                ),
              ),
              const SizedBox(height: 12),
              if (starredApps.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh.withValues(
                      alpha: 0.42,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'No favourites yet',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14 * scale,
                    ),
                  ),
                )
              else
                for (final app in starredApps)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(
                        alpha: 0.42,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.surfaceContainerHigh,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: app.icon.isNotEmpty
                                ? ColorFiltered(
                                    colorFilter: iconColorFilter,
                                    child: Image.memory(
                                      app.icon,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.apps),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            app.name,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 15 * scale,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () =>
                              unawaited(_removeFavourite(app.packageName)),
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: starredApps.length >= kMaxStarredApps
                      ? null
                      : () => unawaited(_addFavourite()),
                  icon: const Icon(Icons.add),
                  label: const Text('Add app to favourites'),
                ),
              ),
              const SizedBox(height: 32),

              // Layout Section
              _SectionTitle(title: 'Layout', scale: scale),
              Text(
                'Adjust spacing between sections',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12 * scale,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => unawaited(_enterLayoutAdjustMode()),
                  icon: const Icon(Icons.tune),
                  label: const Text('Adjust Layout Spacing'),
                ),
              ),
              const SizedBox(height: 32),

              // Header Widget Slots
              _SectionTitle(title: 'Header Widget Slots', scale: scale),
              const SizedBox(height: 12),
              _HeaderWidgetSlotCard(
                title: 'Left Widget Slot',
                widgetId: leftWidgetSlotId,
                onAdd: () => unawaited(_addHeaderWidgetSlot(true)),
                onRemove: leftWidgetSlotId == null
                    ? null
                    : () => unawaited(
                        _removeHeaderWidgetSlot(leftWidgetSlotId, true),
                      ),
                scale: scale,
              ),
              const SizedBox(height: 12),
              _HeaderWidgetSlotCard(
                title: 'Right Widget Slot',
                widgetId: rightWidgetSlotId,
                onAdd: () => unawaited(_addHeaderWidgetSlot(false)),
                onRemove: rightWidgetSlotId == null
                    ? null
                    : () => unawaited(
                        _removeHeaderWidgetSlot(rightWidgetSlotId, false),
                      ),
                scale: scale,
              ),
              const SizedBox(height: 32),

              // Icon Theme Section
              _SectionTitle(title: 'Icon Theme', scale: scale),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 100 / 90,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final theme in AppIconTheme.values)
                    _IconThemeCard(
                      theme: theme,
                      selected: theme == iconTheme,
                      previewApps: apps.take(3).toList(growable: false),
                      onTap: () => unawaited(_updateIconTheme(theme)),
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // Clock Style Section
              _SectionTitle(title: 'Clock Style', scale: scale),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ClockStyleOption(
                      label: 'Digital',
                      value: 'digital',
                      selected: clockStyle == 'digital',
                      onTap: () => unawaited(_updateClockStyle('digital')),
                      scale: scale,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ClockStyleOption(
                      label: 'Digital Thin',
                      value: 'digital_thin',
                      selected: clockStyle == 'digital_thin',
                      onTap: () => unawaited(_updateClockStyle('digital_thin')),
                      scale: scale,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ClockStyleOption(
                      label: 'Analog',
                      value: 'analog',
                      selected: clockStyle == 'analog',
                      onTap: () => unawaited(_updateClockStyle('analog')),
                      scale: scale,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Font Section
              _SectionTitle(title: 'App Font Size', scale: scale),
              const SizedBox(height: 12),
              _FontSizeOption(
                label: 'Small',
                value: 0.85,
                selected: (scale - 0.85).abs() < 0.01,
                onTap: () => unawaited(_updateFontSize(0.85)),
                scale: scale,
              ),
              const SizedBox(height: 8),
              _FontSizeOption(
                label: 'Medium',
                value: 1.0,
                selected: (scale - 1.0).abs() < 0.01,
                onTap: () => unawaited(_updateFontSize(1.0)),
                scale: scale,
              ),
              const SizedBox(height: 8),
              _FontSizeOption(
                label: 'Large',
                value: 1.15,
                selected: (scale - 1.15).abs() < 0.01,
                onTap: () => unawaited(_updateFontSize(1.15)),
                scale: scale,
              ),
              const SizedBox(height: 32),

              // About Section
              _SectionTitle(title: 'About', scale: scale),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
                tileColor: AppColors.surfaceContainerHigh.withValues(
                  alpha: 0.42,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.scale});

  final String title;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        color: AppColors.onSurface,
        fontSize: 18 * scale,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _HeaderWidgetSlotCard extends StatelessWidget {
  const _HeaderWidgetSlotCard({
    required this.title,
    required this.widgetId,
    required this.onAdd,
    required this.onRemove,
    required this.scale,
  });

  final String title;
  final int? widgetId;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(fontSize: 15 * scale),
                ),
                const SizedBox(height: 4),
                Text(
                  widgetId == null ? 'None' : 'Widget #$widgetId',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12 * scale,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onAdd, child: const Text('Add')),
          if (onRemove != null)
            TextButton(onPressed: onRemove, child: const Text('Remove')),
        ],
      ),
    );
  }
}

class _ClockStyleOption extends StatelessWidget {
  const _ClockStyleOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.scale,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: AppColors.secondary, width: 2)
              : null,
        ),
        child: Column(
          children: [
            Text(
              value == 'digital'
                  ? '10:22'
                  : value == 'digital_thin'
                  ? '10:22'
                  : '⏰',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: value == 'analog' ? 32 * scale : 24 * scale,
                fontWeight: value == 'digital_thin'
                    ? FontWeight.w200
                    : FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconThemeCard extends StatelessWidget {
  const _IconThemeCard({
    required this.theme,
    required this.selected,
    required this.previewApps,
    required this.onTap,
  });

  final AppIconTheme theme;
  final bool selected;
  final List<AppInfo> previewApps;
  final VoidCallback onTap;

  Widget _buildIconWithTheme(AppInfo app) {
    switch (theme) {
      case AppIconTheme.defaultTheme:
        return app.icon.isNotEmpty
            ? Image.memory(
                app.icon,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                cacheWidth: 80,
              )
            : const Icon(Icons.apps, size: 16);

      case AppIconTheme.dark:
        final filter = IconThemeService.getColorFilterForTheme(theme);
        return app.icon.isNotEmpty
            ? ColorFiltered(
                colorFilter: filter,
                child: Image.memory(
                  app.icon,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  cacheWidth: 80,
                ),
              )
            : const Icon(Icons.apps, size: 16);

      case AppIconTheme.fun:
        final iconData = funIconMap[app.packageName] ?? funFallbackIcon;
        final bgColor = getColorFromPackageName(app.packageName);
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(child: FaIcon(iconData, size: 16, color: Colors.white)),
        );

      case AppIconTheme.cute:
        final iconData = cuteIconMap[app.packageName] ?? cuteFallbackIcon;
        final bgColor = getPastelColorFromPackageName(app.packageName);
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Icon(
              iconData,
              size: 16,
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: AppColors.secondary, width: 2)
              : Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final app in previewApps)
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color:
                              theme == AppIconTheme.fun ||
                                  theme == AppIconTheme.cute
                              ? Colors.transparent
                              : AppColors.surfaceContainerHigh,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _buildIconWithTheme(app),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  IconThemeService.getThemeName(theme),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (selected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.secondary,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppPickerSheet extends ConsumerStatefulWidget {
  const _AppPickerSheet({required this.apps, required this.currentStarred});

  final List<AppInfo> apps;
  final Set<String> currentStarred;

  @override
  ConsumerState<_AppPickerSheet> createState() => _AppPickerSheetState();
}

class _AppPickerSheetState extends ConsumerState<_AppPickerSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;
    final iconTheme = ref.watch(iconThemeProvider);

    final filteredApps = widget.apps
        .where((app) {
          if (_searchQuery.isEmpty) {
            return !widget.currentStarred.contains(app.packageName);
          }
          return !widget.currentStarred.contains(app.packageName) &&
              app.name.toLowerCase().contains(_searchQuery.toLowerCase());
        })
        .toList(growable: false);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
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
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 15 * scale,
                  ),
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
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.surfaceContainerHigh,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: app.icon.isNotEmpty
                          ? ColorFiltered(
                              colorFilter:
                                  IconThemeService.getColorFilterForTheme(
                                    iconTheme,
                                  ),
                              child: Image.memory(app.icon, fit: BoxFit.cover),
                            )
                          : const Icon(Icons.apps),
                    ),
                  ),
                  title: Text(
                    app.name,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.onSurface,
                      fontSize: 15 * scale,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(app),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FontSizeOption extends StatelessWidget {
  const _FontSizeOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.scale,
  });

  final String label;
  final double value;
  final bool selected;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: AppColors.secondary, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? AppColors.secondary
                  : AppColors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onSurface,
                fontSize: 15 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
