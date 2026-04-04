import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _saveSettings(WidgetRef ref, SettingsDb next) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.collection<SettingsDb>().put(next);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final iconPack = ref.watch(iconPackProvider).valueOrNull;
    final iconPacks =
        ref.watch(installedIconPacksProvider).valueOrNull ?? const [];
    final appService = ref.watch(appServiceProvider);
    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Home Screen',
            children: [
              _ActionRow(
                title: 'Icon shape',
                value: settings.iconShape,
                onChanged: (v) async =>
                    _saveSettings(ref, settings..iconShape = v),
              ),
              ListTile(
                title: const Text('Icon pack'),
                subtitle: Text(iconPack?.selectedPackLabel ?? 'System default'),
                trailing: iconPacks.isEmpty
                    ? const Text('None')
                    : DropdownButton<String>(
                        value: iconPack?.selectedPackageName.isEmpty ?? true
                            ? '__system__'
                            : iconPack!.selectedPackageName,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '__system__',
                            child: Text('System default'),
                          ),
                          ...iconPacks.map(
                            (pack) => DropdownMenuItem<String>(
                              value: pack.packageName,
                              child: Text(
                                pack.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) async {
                          final isar = await ref.read(isarProvider.future);
                          await isar.writeTxn(() async {
                            if (value == null || value == '__system__') {
                              await isar.iconPackDbs.put(
                                IconPackDb()
                                  ..selectedPackageName = ''
                                  ..selectedPackLabel = 'System default',
                              );
                              return;
                            }
                            final selected = iconPacks.firstWhere(
                              (p) => p.packageName == value,
                            );
                            await isar.iconPackDbs.put(
                              IconPackDb()
                                ..selectedPackageName = selected.packageName
                                ..selectedPackLabel = selected.label,
                            );
                          });
                        },
                      ),
              ),
              _ToggleRow(
                title: 'Show labels',
                value: settings.showLabels,
                onChanged: (v) async {
                  await _saveSettings(ref, settings..showLabels = v);
                },
              ),
              _SliderRow(
                title: 'Grid columns',
                value: settings.gridColumns.toDouble(),
                min: 3,
                max: 5,
                divisions: 2,
                label: '${settings.gridColumns}',
                onChanged: (v) async {
                  await _saveSettings(ref, settings..gridColumns = v.round());
                },
              ),
              _SliderRow(
                title: 'Icon size',
                value: settings.iconSize.toDouble(),
                min: 40,
                max: 72,
                divisions: 8,
                label: '${settings.iconSize}',
                onChanged: (v) async {
                  await _saveSettings(ref, settings..iconSize = v.round());
                },
              ),
              _SliderRow(
                title: 'Font scale',
                value: settings.fontScaleFactor,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                label: settings.fontScaleFactor.toStringAsFixed(1),
                onChanged: (v) async =>
                    _saveSettings(ref, settings..fontScaleFactor = v),
              ),
              _ActionRow(
                title: 'Icon shape preview',
                value: settings.iconShape,
                entries: const [
                  _ActionEntry(0, 'Circle'),
                  _ActionEntry(1, 'Rounded'),
                  _ActionEntry(2, 'Teardrop'),
                  _ActionEntry(3, 'Squarish'),
                ],
                onChanged: (v) async =>
                    _saveSettings(ref, settings..iconShape = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Dock',
            children: [
              _ToggleRow(
                title: 'Show dock labels',
                value: settings.showDockLabels,
                onChanged: (v) async {
                  await _saveSettings(ref, settings..showDockLabels = v);
                },
              ),
              _ToggleRow(
                title: 'Show recents row',
                value: settings.showRecents,
                onChanged: (v) async {
                  await _saveSettings(ref, settings..showRecents = v);
                },
              ),
              _ToggleRow(
                title: 'Haptics',
                value: settings.hapticsEnabled,
                onChanged: (v) async {
                  await _saveSettings(ref, settings..hapticsEnabled = v);
                  if (v) {
                    await HapticFeedback.selectionClick();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Gestures',
            children: [
              _ActionRow(
                title: 'Double tap',
                value: settings.doubleTapAction,
                entries: const [
                  _ActionEntry(0, 'Nothing'),
                  _ActionEntry(1, 'Lock'),
                  _ActionEntry(2, 'Assistant'),
                ],
                onChanged: (v) async =>
                    _saveSettings(ref, settings..doubleTapAction = v),
              ),
              _ActionRow(
                title: 'Swipe left',
                value: settings.swipeLeftAction,
                entries: const [
                  _ActionEntry(0, 'App drawer'),
                  _ActionEntry(4, 'Camera'),
                ],
                onChanged: (v) async =>
                    _saveSettings(ref, settings..swipeLeftAction = v),
              ),
              _ActionRow(
                title: 'Pinch',
                value: settings.pinchAction,
                entries: const [
                  _ActionEntry(0, 'Nothing'),
                  _ActionEntry(3, 'Recents'),
                ],
                onChanged: (v) async =>
                    _saveSettings(ref, settings..pinchAction = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Quick Controls',
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: appService.getQuickSettings(),
                builder: (context, snapshot) {
                  final quick =
                      snapshot.data ??
                      {
                        'wifiEnabled': false,
                        'bluetoothEnabled': false,
                        'brightness': 128,
                      };
                  final wifiEnabled = quick['wifiEnabled'] == true;
                  final bluetoothEnabled = quick['bluetoothEnabled'] == true;
                  final brightness = (quick['brightness'] as int?) ?? 128;

                  return Column(
                    children: [
                      _ToggleRow(
                        title: 'Wi-Fi',
                        value: wifiEnabled,
                        onChanged: (v) async {
                          await appService.toggleWifi(v);
                          if (settings.hapticsEnabled) {
                            await HapticFeedback.selectionClick();
                          }
                        },
                      ),
                      _ToggleRow(
                        title: 'Bluetooth',
                        value: bluetoothEnabled,
                        onChanged: (v) async {
                          await appService.toggleBluetooth(v);
                          if (settings.hapticsEnabled) {
                            await HapticFeedback.selectionClick();
                          }
                        },
                      ),
                      _SliderRow(
                        title: 'Brightness',
                        value: brightness.toDouble(),
                        min: 10,
                        max: 255,
                        divisions: 49,
                        label: '$brightness',
                        onChanged: (v) async {
                          await appService.setBrightness(v.round());
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleLarge),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) =>
      SwitchListTile(title: Text(title), value: value, onChanged: onChanged);
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  });
  final String title;
  final double value, min, max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(title: Text(title), trailing: Text(label)),
      Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    ],
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.entries = const [
      _ActionEntry(0, 'Nothing'),
      _ActionEntry(1, 'Lock'),
      _ActionEntry(2, 'Assistant'),
      _ActionEntry(3, 'Recents'),
      _ActionEntry(4, 'Camera'),
    ],
  });
  final String title;
  final int value;
  final List<_ActionEntry> entries;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    final selectedValue = entries.any((entry) => entry.value == value)
        ? value
        : entries.first.value;

    return ListTile(
      title: Text(title),
      trailing: DropdownButton<int>(
        value: selectedValue,
        items: [
          for (final entry in entries)
            DropdownMenuItem(value: entry.value, child: Text(entry.label)),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _ActionEntry {
  const _ActionEntry(this.value, this.label);

  final int value;
  final String label;
}
