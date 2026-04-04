import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';

class WidgetPickerSheet extends ConsumerWidget {
  const WidgetPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetsFuture = ref.watch(availableWidgetsProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Widget', style: AppTypography.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'Choose a widget to place on home.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: widgetsFuture.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No widgets available',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.06,
                          ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _WidgetTile(
                          info: item,
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final success = await _selectWidget(ref, item);
                            if (!context.mounted) {
                              return;
                            }
                            if (success) {
                              Navigator.of(context).pop();
                            } else {
                              messenger
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not add widget. Try another one.',
                                    ),
                                  ),
                                );
                            }
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Failed to load widgets',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _selectWidget(WidgetRef ref, AvailableWidgetInfo info) async {
    final appService = ref.read(appServiceProvider);
    final widgetsNotifier = ref.read(homeWidgetsProvider.notifier);

    final appWidgetId = await appService.allocateWidgetId();
    if (appWidgetId == null) {
      return false;
    }

    final bound = await appService.bindWidget(
      appWidgetId,
      info.packageName,
      info.className,
    );
    if (!bound) {
      await appService.deleteWidgetId(appWidgetId);
      return false;
    }

    final canCreateView = await appService.createWidgetView(appWidgetId);
    if (!canCreateView) {
      await appService.deleteWidgetId(appWidgetId);
      return false;
    }

    await widgetsNotifier.addWidget(
      appWidgetId: appWidgetId,
      label: info.label,
      providerPackage: info.packageName,
      providerClass: info.className,
      minWidth: info.minWidth,
      minHeight: info.minHeight,
    );
    return true;
  }
}

final availableWidgetsProvider = FutureProvider<List<AvailableWidgetInfo>>((
  ref,
) {
  return ref.watch(appServiceProvider).getAvailableWidgets();
});

class _WidgetTile extends StatelessWidget {
  const _WidgetTile({required this.info, required this.onTap});

  final AvailableWidgetInfo info;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => unawaited(onTap()),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: info.preview != null && info.preview!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            info.preview!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            gaplessPlayback: true,
                          ),
                        )
                      : Icon(
                          Icons.widgets_outlined,
                          color: AppColors.onSurfaceVariant,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                info.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
