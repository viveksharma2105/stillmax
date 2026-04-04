import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/app_service.dart';
import '../services/icon_cache.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class GridAppIcon extends StatefulWidget {
  const GridAppIcon({
    super.key,
    required this.app,
    required this.showNotification,
    required this.notificationCount,
    required this.iconShape,
    required this.heroTag,
    this.iconPackPackage,
    required this.isEditing,
    required this.wiggleRadians,
    required this.onTap,
    required this.iconSize,
    required this.showLabel,
    required this.labelFontSize,
    this.onLongPressStart,
  });

  final AppInfo app;
  final bool showNotification;
  final int notificationCount;
  final IconShape iconShape;
  final String heroTag;
  final String? iconPackPackage;
  final bool isEditing;
  final double wiggleRadians;
  final VoidCallback onTap;
  final double iconSize;
  final bool showLabel;
  final double labelFontSize;
  final GestureLongPressStartCallback? onLongPressStart;

  @override
  State<GridAppIcon> createState() => _GridAppIconState();
}

class _GridAppIconState extends State<GridAppIcon> {
  bool _pressed = false;
  final _service = AppService();
  final _cache = IconCache();
  Uint8List? _effectiveIcon;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  void initState() {
    super.initState();
    _effectiveIcon = widget.app.icon;
    unawaited(_resolveIconPack());
  }

  @override
  void didUpdateWidget(covariant GridAppIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.app.packageName != widget.app.packageName ||
        oldWidget.iconPackPackage != widget.iconPackPackage) {
      _effectiveIcon = widget.app.icon;
      unawaited(_resolveIconPack());
    }
  }

  Future<void> _resolveIconPack() async {
    final pack = widget.iconPackPackage;
    if (pack == null || pack.trim().isEmpty) {
      if (mounted) setState(() => _effectiveIcon = widget.app.icon);
      return;
    }

    final key = '$pack:${widget.app.packageName}';
    final cached = _cache.get(key);
    if (cached != null && cached.isNotEmpty) {
      if (mounted) setState(() => _effectiveIcon = cached);
      return;
    }

    final packed = await _service.getIconFromPack(pack, widget.app.packageName);
    if (!mounted) return;
    if (packed != null && packed.isNotEmpty) {
      _cache.put(key, packed);
      setState(() => _effectiveIcon = packed);
    } else {
      setState(() => _effectiveIcon = widget.app.icon);
    }
  }

  BoxShape _shapeForIcon() {
    return switch (widget.iconShape) {
      IconShape.circle => BoxShape.circle,
      IconShape.rounded => BoxShape.rectangle,
      IconShape.teardrop => BoxShape.rectangle,
      IconShape.squarish => BoxShape.rectangle,
    };
  }

  BorderRadius _borderRadiusForIcon() {
    return switch (widget.iconShape) {
      IconShape.circle => BorderRadius.circular(widget.iconSize),
      IconShape.rounded => BorderRadius.circular(20),
      IconShape.teardrop => const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(8),
      ),
      IconShape.squarish => BorderRadius.circular(10),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: widget.isEditing ? widget.wiggleRadians : 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        onLongPressStart: widget.onLongPressStart,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 80),
          curve: _pressed ? Curves.easeOut : Curves.elasticOut,
          scale: _pressed ? 0.92 : 1,
          child: GlassCardLight(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: widget.heroTag,
                        child: ClipRRect(
                          borderRadius: _borderRadiusForIcon(),
                          child: Container(
                            width: widget.iconSize,
                            height: widget.iconSize,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              shape: _shapeForIcon(),
                            ),
                            child:
                                _effectiveIcon != null &&
                                    _effectiveIcon!.isNotEmpty
                                ? Image.memory(
                                    _effectiveIcon!,
                                    width: widget.iconSize,
                                    height: widget.iconSize,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  )
                                : Icon(Icons.apps, size: widget.iconSize),
                          ),
                        ),
                      ),
                      if (widget.showLabel) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.app.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: widget.labelFontSize,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.showNotification)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        widget.notificationCount > 99
                            ? '99+'
                            : '${widget.notificationCount.clamp(1, 99)}',
                        textAlign: TextAlign.center,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSecondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                          height: 1,
                        ),
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

class DockSlot extends StatefulWidget {
  const DockSlot({
    super.key,
    required this.app,
    required this.showNotification,
    this.notificationCount = 0,
    required this.onAcceptPackage,
    this.onTap,
    this.onLongPressStart,
  });

  final AppInfo? app;
  final bool showNotification;
  final int notificationCount;
  final ValueChanged<String> onAcceptPackage;
  final VoidCallback? onTap;
  final GestureLongPressStartCallback? onLongPressStart;

  @override
  State<DockSlot> createState() => _DockSlotState();
}

class FolderIcon extends StatelessWidget {
  const FolderIcon({
    super.key,
    required this.name,
    required this.apps,
    required this.onTap,
  });

  final String name;
  final List<AppInfo> apps;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCardLight(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: apps.take(4).map((app) {
                return Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.surfaceContainerHighest,
                  ),
                  child: app.icon.isNotEmpty
                      ? Image.memory(app.icon, fit: BoxFit.cover)
                      : const Icon(Icons.apps, size: 14),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _DockSlotState extends State<DockSlot> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        setState(() => _hovering = true);
        return true;
      },
      onLeave: (_) => setState(() => _hovering = false),
      onAcceptWithDetails: (details) {
        setState(() => _hovering = false);
        widget.onAcceptPackage(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final highlighted = _hovering || candidateData.isNotEmpty;

        Widget content = const SizedBox.shrink();
        if (widget.app != null) {
          content = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onLongPressStart: widget.onLongPressStart,
            child: Stack(
              children: [
                Center(
                  child: widget.app!.icon.isNotEmpty
                      ? Image.memory(widget.app!.icon, width: 32, height: 32)
                      : const Icon(Icons.apps, size: 24),
                ),
                if (widget.showNotification)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 15),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        widget.notificationCount > 99
                            ? '99+'
                            : '${widget.notificationCount.clamp(1, 99)}',
                        textAlign: TextAlign.center,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSecondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 8,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return SizedBox(
          width: 56,
          height: 56,
          child: GlassCard(
            borderRadius: BorderRadius.circular(AppRadius.md),
            backgroundColor: highlighted
                ? AppColors.primary.withValues(alpha: 0.22)
                : AppColors.glassLight,
            borderColor: highlighted
                ? AppColors.primary.withValues(alpha: 0.65)
                : Colors.white.withValues(alpha: 0.08),
            child: content,
          ),
        );
      },
    );
  }
}
