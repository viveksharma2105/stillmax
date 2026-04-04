import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';

class AppListTile extends ConsumerWidget {
  const AppListTile({
    super.key,
    required this.app,
    required this.starred,
    this.showDivider = true,
  });

  final AppInfo app;
  final bool starred;
  final bool showDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final scale = settings?.fontScaleFactor ?? 1.0;
    final hapticsEnabled = settings?.hapticsEnabled ?? true;
    final starredPackages = ref.watch(starredAppsProvider);
    final canAddStarred = starred || starredPackages.length < kMaxStarredApps;

    Future<void> toggleStarredWithFeedback() async {
      final action = await ref
          .read(starredAppsProvider.notifier)
          .toggleStarred(app.packageName);
      if (!context.mounted) {
        return;
      }
      if (action == StarredResult.limitReached) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Favourites limit reached. Remove an app first.'),
            ),
          );
      }
    }

    Future<void> launch() async {
      if (hapticsEnabled) {
        await HapticFeedback.selectionClick();
      }
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
        items: [
          const PopupMenuItem<String>(value: 'open', child: Text('Open')),
          PopupMenuItem<String>(
            value: starred ? 'unstar' : 'star',
            enabled: starred || canAddStarred,
            child: Text(starred ? 'Remove from starred' : 'Add to starred'),
          ),
          const PopupMenuItem<String>(
            value: 'app_info',
            child: Text('App info'),
          ),
          const PopupMenuItem<String>(
            value: 'uninstall',
            child: Text('Uninstall'),
          ),
        ],
      );

      switch (selected) {
        case 'open':
          await launch();
          break;
        case 'star':
        case 'unstar':
          await toggleStarredWithFeedback();
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

    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => unawaited(openMenu(details)),
        child: Material(
          color: AppColors.background.withValues(alpha: 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => unawaited(launch()),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.surfaceContainerHigh,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: app.icon.isNotEmpty
                                ? Image.memory(
                                    app.icon,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  )
                                : const Icon(Icons.apps),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            app.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 15 * scale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: canAddStarred
                              ? () => unawaited(toggleStarredWithFeedback())
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Opacity(
                              opacity: starred || canAddStarred ? 1 : 0.3,
                              child: Icon(
                                starred ? Icons.star : Icons.star_border,
                                size: 18,
                                color: starred
                                    ? AppColors.secondary
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (showDivider)
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: AppColors.outlineVariant.withValues(alpha: 0.24),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
