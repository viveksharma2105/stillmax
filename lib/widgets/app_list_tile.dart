import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../services/icon_resolver.dart';
import '../services/icon_theme_service.dart';
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
    final iconTheme = ref.watch(iconThemeProvider);

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
        items: const [
          PopupMenuItem<String>(value: 'open', child: Text('Open')),
          PopupMenuItem<String>(value: 'app_info', child: Text('App info')),
          PopupMenuItem<String>(value: 'uninstall', child: Text('Uninstall')),
        ],
      );

      switch (selected) {
        case 'open':
          await launch();
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

    // Build app icon widget with theme support
    Widget buildIcon() {
      switch (iconTheme) {
        case AppIconTheme.fun:
          // Fun theme: FontAwesome icons with colored backgrounds
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
          // Cute theme: Lucide icons with pastel backgrounds
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
          // Default and dark theme: Use original APK icons
          if (app.icon.isEmpty) {
            // Show first letter if icon is missing
            final firstLetter = app.name.isNotEmpty
                ? app.name[0].toUpperCase()
                : '?';
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondary,
              ),
              child: Center(
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }

          final iconColorFilter = IconThemeService.getColorFilterForTheme(
            iconTheme,
          );

          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surfaceContainerHigh,
            ),
            clipBehavior: Clip.antiAlias,
            child: ColorFiltered(
              colorFilter: iconColorFilter,
              child: Image.memory(
                app.icon,
                key: ValueKey(app.packageName),
                fit: BoxFit.cover,
                gaplessPlayback: true,
                cacheWidth: 80,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to letter if image fails to load
                  final firstLetter = app.name.isNotEmpty
                      ? app.name[0].toUpperCase()
                      : '?';
                  return Container(
                    color: AppColors.secondary,
                    child: Center(
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
      }
    }

    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => unawaited(openMenu(details)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: AppColors.secondary.withValues(alpha: 0.15),
            highlightColor: AppColors.secondary.withValues(alpha: 0.08),
            onTap: () => unawaited(launch()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildIcon(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      app.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 * scale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
