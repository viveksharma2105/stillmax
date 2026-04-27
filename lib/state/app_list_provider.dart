import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../services/app_service.dart';
import '../theme/app_theme.dart';

part 'app_list_provider.g.dart';

String appIdentityKey(AppInfo app) => app.instanceKey;

bool storedKeyMatchesApp(String storedKey, AppInfo app) {
  return storedKey == appIdentityKey(app) || storedKey == app.packageName;
}

bool identityCollectionContainsApp(Iterable<String> storedKeys, AppInfo app) {
  for (final key in storedKeys) {
    if (storedKeyMatchesApp(key, app)) {
      return true;
    }
  }
  return false;
}

AppInfo appInfoFromDbRow({
  required String storedIdentity,
  required String name,
  required List<int> icon,
}) {
  final parts = parseAppIdentityKey(storedIdentity);
  return AppInfo(
    name: name,
    packageName: parts.packageName,
    instanceId: parts.instanceId,
    userSerial: parts.userSerial,
    userUid: parts.userUid,
    className: parts.className,
    icon: Uint8List.fromList(icon),
  );
}

enum GridColumnCount { three, four, five }

enum IconSizeSetting { small, medium, large }

enum LabelFontSize { small, medium, large }

enum DockIconCount { three, four, five }

enum DoubleTapAction { nothing, lock, assistant }

enum SwipeLeftAction { drawer, camera }

enum PinchAction { nothing, recents }

enum StarredResult { added, removed, limitReached, unchanged }

final appServiceProvider = Provider<AppService>((ref) => AppService());

@collection
class AppInfoDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String packageName;

  late String appName;

  late List<int> icon;

  late int position;
}

@collection
class DockApp {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String packageName;

  late String appName;

  late List<int> icon;

  late int position;
}

@collection
class SettingsDb {
  Id id = 1;
  late int gridColumns;
  late int iconSize;
  late bool showLabels;
  late int fontSize;
  late int dockIconCount;
  late bool showDockLabels;
  late int doubleTapAction;
  late int swipeLeftAction;
  late int pinchAction;
  late bool showRecents;
  bool showWeatherWidget = true;
  late int iconShape; // 0=circle, 1=rounded, 2=teardrop, 3=squarish
  late double fontScaleFactor;
  late bool hapticsEnabled;
  late String clockStyle; // 'digital', 'digital_thin', 'analog'
  late int iconTheme; // AppIconTheme index
  late double
  clockSpacing; // spacing between clock header and favourites (default 40.0)
  late double
  sidebarSpacing; // vertical offset of sidebar from top edge, default 100.0
  late double
  favoritesSpacing; // vertical spacing between favorites section header and app list, default 8.0
  late double
  sidebarHorizontalOffset; // horizontal offset of sidebar from right edge, default 16.0
  int? leftWidgetSlotId; // appWidgetId for left slot in TimeHeader PageView
  int? rightWidgetSlotId; // appWidgetId for right slot in TimeHeader PageView
}

@collection
class PageLayoutDb {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late int pageIndex;
  late List<String> packageNames;
}

@collection
class FolderDb {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String folderId;
  late String name;
  late int pageIndex;
  late double x;
  late double y;
  late bool inDock;
}

@collection
class FolderAppDb {
  Id id = Isar.autoIncrement;
  late String folderId;
  late String packageName;
  late String appName;
  late List<int> icon;
  late int position;
}

@collection
class RecentAppDb {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String packageName;
  late String appName;
  late List<int> icon;
  late int position;
}

@collection
class CustomAppNameDb {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String packageName;
  late String customName;
}

@collection
class IconPackDb {
  Id id = 1;
  late String selectedPackageName;
  late String selectedPackLabel;
}

@collection
class OnboardingDb {
  Id id = 1;
  late bool hasOnboarded;
}

@collection
class StarredAppDb {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String packageName;
  late int position;
}

@collection
class BlackBoxSettingsDb {
  Id id = 1; // Singleton
  late String passwordHash; // SHA-256 hash of 6-digit PIN
  late bool isEnabled;
}

@collection
class HiddenAppDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String packageName;

  late String appName;

  late List<int> icon;
}

@collection
class WeatherCacheDb {
  Id id = 1;
  late String city;
  late double temperature;
  late String condition;
  late String conditionCode;
  late DateTime lastFetched;
}

@collection
class HomeWidgetDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int appWidgetId;

  late String label;
  late String providerPackage;
  late String providerClass;
  late int minWidth;
  late int minHeight;
  late int position;
}

enum IconShape { circle, rounded, teardrop, squarish }

SettingsDb _defaultSettingsDb() {
  return SettingsDb()
    ..gridColumns = 4
    ..iconSize = 56
    ..showLabels = true
    ..fontSize = 1
    ..dockIconCount = 5
    ..showDockLabels = false
    ..doubleTapAction = 0
    ..swipeLeftAction = 0
    ..pinchAction = 0
    ..showRecents = true
    ..showWeatherWidget = true
    ..iconShape = 1
    ..fontScaleFactor = 1.0
    ..hapticsEnabled = true
    ..clockStyle = 'digital'
    ..iconTheme = AppIconTheme.defaultTheme.index
    ..clockSpacing = 40.0
    ..sidebarSpacing = 100.0
    ..favoritesSpacing = 8.0
    ..sidebarHorizontalOffset = 16.0;
}

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([
    AppInfoDbSchema,
    DockAppSchema,
    SettingsDbSchema,
    PageLayoutDbSchema,
    FolderDbSchema,
    FolderAppDbSchema,
    RecentAppDbSchema,
    CustomAppNameDbSchema,
    IconPackDbSchema,
    OnboardingDbSchema,
    StarredAppDbSchema,
    BlackBoxSettingsDbSchema,
    HiddenAppDbSchema,
    WeatherCacheDbSchema,
    HomeWidgetDbSchema,
  ], directory: dir.path);
});

final settingsProvider = StreamProvider<SettingsDb>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  final existing = await isar.settingsDbs.get(1);
  if (existing != null) yield existing;
  yield* isar.settingsDbs.watchObject(1, fireImmediately: true).map((v) {
    return v ?? (existing ?? _defaultSettingsDb());
  });
});

final pageLayoutsProvider = StreamProvider<List<PageLayoutDb>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield await isar.pageLayoutDbs.where().findAll();
  yield* isar.pageLayoutDbs
      .watchLazy(fireImmediately: true)
      .asyncMap((_) => isar.pageLayoutDbs.where().findAll());
});

final foldersProvider = StreamProvider<List<FolderDb>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield await isar.folderDbs.where().findAll();
  yield* isar.folderDbs
      .watchLazy(fireImmediately: true)
      .asyncMap((_) => isar.folderDbs.where().findAll());
});

final recentsProvider = StreamProvider<List<RecentAppDb>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield await isar.recentAppDbs.where().sortByPosition().findAll();
  yield* isar.recentAppDbs
      .watchLazy(fireImmediately: true)
      .asyncMap((_) => isar.recentAppDbs.where().sortByPosition().findAll());
});

final batteryProvider = StreamProvider<Map<String, dynamic>>((ref) async* {
  final service = ref.watch(appServiceProvider);
  while (true) {
    try {
      yield await service.getBatteryInfo();
    } catch (_) {
      yield {'level': 100, 'charging': false};
    }
    await Future<void>.delayed(const Duration(seconds: 60));
  }
});

final nowProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  while (true) {
    final now = DateTime.now();
    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 1,
    );
    await Future<void>.delayed(nextMinute.difference(now));
    yield DateTime.now();
  }
});

const _wallpaperOverrideFileName = 'stillmax_wallpaper_override.jpg';
const _systemWallpaperCacheFileName = 'stillmax_system_wallpaper_cache.bin';
const kMaxWallpaperBytes = 8 * 1024 * 1024;

Future<File> _wallpaperOverrideFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_wallpaperOverrideFileName');
}

Future<File> _systemWallpaperCacheFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_systemWallpaperCacheFileName');
}

Future<Uint8List?> _loadWallpaperOverrideBytes() async {
  try {
    final file = await _wallpaperOverrideFile();
    if (!await file.exists()) {
      return null;
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty || bytes.length > kMaxWallpaperBytes) {
      return null;
    }
    return bytes;
  } catch (_) {
    return null;
  }
}

Future<Uint8List?> _loadSystemWallpaperCacheBytes() async {
  try {
    final file = await _systemWallpaperCacheFile();
    if (!await file.exists()) {
      return null;
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty || bytes.length > kMaxWallpaperBytes) {
      return null;
    }
    return bytes;
  } catch (_) {
    return null;
  }
}

Future<void> _saveSystemWallpaperCacheBytes(Uint8List bytes) async {
  try {
    if (bytes.isEmpty || bytes.length > kMaxWallpaperBytes) {
      return;
    }
    final file = await _systemWallpaperCacheFile();
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  } catch (_) {
    // Best-effort cache write.
  }
}

bool _sameBytes(Uint8List a, Uint8List b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Uint8List? _asUint8List(dynamic value) {
  if (value == null) return null;
  if (value is Uint8List) return value;
  if (value is List<int>) return Uint8List.fromList(value);
  return null;
}

bool _sameOptionalBytes(Uint8List? a, Uint8List? b) {
  if (a == null || b == null) return a == b;
  return _sameBytes(a, b);
}

Map<String, dynamic>? _coerceMediaSessionPayload(
  Map<String, dynamic>? payload,
) {
  if (payload == null) return null;

  final albumArt = _asUint8List(payload['albumArt']);
  if (payload['albumArt'] == albumArt) {
    return payload;
  }

  final normalized = Map<String, dynamic>.from(payload);
  if (albumArt == null) {
    normalized.remove('albumArt');
  } else {
    normalized['albumArt'] = albumArt;
  }
  return normalized;
}

bool _sameMediaSessionPayload(
  Map<String, dynamic>? previous,
  Map<String, dynamic>? next,
) {
  if (identical(previous, next)) return true;
  if (previous == null || next == null) return previous == next;

  final sameMetadata =
      (previous['trackName'] as String?) == (next['trackName'] as String?) &&
      (previous['artistName'] as String?) == (next['artistName'] as String?) &&
      (previous['packageName'] as String?) ==
          (next['packageName'] as String?) &&
      (previous['isPlaying'] as bool? ?? false) ==
          (next['isPlaying'] as bool? ?? false) &&
      (previous['error'] as String?) == (next['error'] as String?);

  if (!sameMetadata) {
    return false;
  }

  return _sameOptionalBytes(
    _asUint8List(previous['albumArt']),
    _asUint8List(next['albumArt']),
  );
}

Future<void> _refreshSystemWallpaperCacheInBackground(
  Ref ref,
  Uint8List cachedBytes,
) async {
  try {
    final service = ref.read(appServiceProvider);
    final refreshed = await service.getWallpaperBytes();
    if (refreshed == null ||
        refreshed.isEmpty ||
        refreshed.length > kMaxWallpaperBytes) {
      return;
    }
    if (_sameBytes(cachedBytes, refreshed)) {
      return;
    }
    await _saveSystemWallpaperCacheBytes(refreshed);
    ref.invalidate(wallpaperBytesProvider);
  } catch (_) {
    // Best-effort background refresh.
  }
}

Future<bool> _saveWallpaperOverrideFromPath(String path) async {
  try {
    if (path.trim().isEmpty) {
      return false;
    }
    final source = File(path);
    if (!await source.exists()) {
      return false;
    }
    final target = await _wallpaperOverrideFile();
    await target.parent.create(recursive: true);
    await source.copy(target.path);
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> _clearWallpaperOverrideFile() async {
  try {
    final file = await _wallpaperOverrideFile();
    if (await file.exists()) {
      await file.delete();
    }
  } catch (_) {
    // Best-effort cleanup.
  }
}

final wallpaperBytesProvider = FutureProvider<Uint8List?>((ref) async {
  try {
    final overrideBytes = await _loadWallpaperOverrideBytes();
    if (overrideBytes != null &&
        overrideBytes.isNotEmpty &&
        overrideBytes.length <= kMaxWallpaperBytes) {
      return overrideBytes;
    }

    final cachedSystemBytes = await _loadSystemWallpaperCacheBytes();
    if (cachedSystemBytes != null &&
        cachedSystemBytes.isNotEmpty &&
        cachedSystemBytes.length <= kMaxWallpaperBytes) {
      unawaited(
        _refreshSystemWallpaperCacheInBackground(ref, cachedSystemBytes),
      );
      return cachedSystemBytes;
    }

    final service = ref.watch(appServiceProvider);
    final bytes = await service.getWallpaperBytes();
    if (bytes != null &&
        bytes.isNotEmpty &&
        bytes.length <= kMaxWallpaperBytes) {
      await _saveSystemWallpaperCacheBytes(bytes);
      return bytes;
    }
    return null;
  } catch (_) {
    return null;
  }
});

final notificationProvider = StreamProvider<Set<String>>((ref) async* {
  final service = ref.watch(appServiceProvider);

  while (true) {
    try {
      final packages = await service.getNotificationPackages();
      yield packages.toSet();
    } catch (_) {
      yield const <String>{};
    }
    await Future<void>.delayed(const Duration(seconds: 5));
  }
});

final notificationCountsProvider = StreamProvider<Map<String, int>>((
  ref,
) async* {
  final service = ref.watch(appServiceProvider);
  while (true) {
    try {
      yield await service.getNotificationCounts();
    } catch (_) {
      yield const <String, int>{};
    }
    await Future<void>.delayed(const Duration(seconds: 5));
  }
});

final mediaSessionProvider = StreamProvider<Map<String, dynamic>?>((
  ref,
) async* {
  final service = ref.watch(appServiceProvider);
  Map<String, dynamic>? previousPayload;

  while (true) {
    Map<String, dynamic>? nextPayload;
    try {
      nextPayload = _coerceMediaSessionPayload(
        await service.getActiveMediaSession(),
      );
    } catch (_) {
      nextPayload = null;
    }

    if (!_sameMediaSessionPayload(previousPayload, nextPayload)) {
      previousPayload = nextPayload;
      yield nextPayload;
    }

    await Future<void>.delayed(const Duration(seconds: 2));
  }
});

final iconPackProvider = StreamProvider<IconPackDb?>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield await isar.iconPackDbs.get(1);
  yield* isar.iconPackDbs.watchObject(1, fireImmediately: true);
});

final installedIconPacksProvider = FutureProvider<List<IconPackInfo>>((ref) {
  return ref.watch(appServiceProvider).getInstalledIconPacks();
});

final customAppNamesProvider = StreamProvider<Map<String, String>>((
  ref,
) async* {
  final isar = await ref.watch(isarProvider.future);

  Future<Map<String, String>> load() async {
    final rows = await isar.customAppNameDbs.where().findAll();
    return {
      for (final row in rows)
        if (row.packageName.isNotEmpty && row.customName.isNotEmpty)
          row.packageName: row.customName,
    };
  }

  yield await load();
  yield* isar.customAppNameDbs
      .watchLazy(fireImmediately: true)
      .asyncMap((_) => load());
});

final onboardingProvider = StreamProvider<OnboardingDb?>((ref) async* {
  final isar = await ref.watch(isarProvider.future);

  Future<OnboardingDb?> load() async => isar.onboardingDbs.get(1);

  yield await load();
  yield* isar.onboardingDbs.watchObject(1, fireImmediately: true);
});

class HomeWidgetEntry {
  const HomeWidgetEntry({
    required this.appWidgetId,
    required this.label,
    required this.providerPackage,
    required this.providerClass,
    required this.minWidth,
    required this.minHeight,
    required this.position,
  });

  final int appWidgetId;
  final String label;
  final String providerPackage;
  final String providerClass;
  final int minWidth;
  final int minHeight;
  final int position;
}

final widgetListProvider =
    AsyncNotifierProvider<WidgetListNotifier, List<HomeWidgetEntry>>(
      WidgetListNotifier.new,
    );

final homeWidgetsProvider = widgetListProvider;

class WidgetListNotifier extends AsyncNotifier<List<HomeWidgetEntry>> {
  Future<List<HomeWidgetEntry>> _loadFromIsar() async {
    final isar = await ref.read(isarProvider.future);
    final rows = await isar.homeWidgetDbs.where().sortByPosition().findAll();
    return rows
        .map(
          (row) => HomeWidgetEntry(
            appWidgetId: row.appWidgetId,
            label: row.label,
            providerPackage: row.providerPackage,
            providerClass: row.providerClass,
            minWidth: row.minWidth,
            minHeight: row.minHeight,
            position: row.position,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<HomeWidgetEntry>> build() async {
    return _loadFromIsar();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _loadFromIsar());
  }

  Future<void> addWidget({
    required int appWidgetId,
    required String label,
    required String providerPackage,
    required String providerClass,
    required int minWidth,
    required int minHeight,
  }) async {
    final current = state.valueOrNull ?? await _loadFromIsar();
    if (current.any((entry) => entry.appWidgetId == appWidgetId)) {
      return;
    }

    final isar = await ref.read(isarProvider.future);
    final nextPosition = current.length;
    await isar.writeTxn(
      () => isar.homeWidgetDbs.putByAppWidgetId(
        HomeWidgetDb()
          ..appWidgetId = appWidgetId
          ..label = label
          ..providerPackage = providerPackage
          ..providerClass = providerClass
          ..minWidth = minWidth
          ..minHeight = minHeight
          ..position = nextPosition,
      ),
    );
    await refresh();
  }

  Future<void> removeWidget(int appWidgetId) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.homeWidgetDbs.deleteByAppWidgetId(appWidgetId);
      final remaining = await isar.homeWidgetDbs
          .where()
          .sortByPosition()
          .findAll();
      for (var i = 0; i < remaining.length; i++) {
        if (remaining[i].position == i) continue;
        remaining[i].position = i;
        await isar.homeWidgetDbs.put(remaining[i]);
      }
    });
    await refresh();
  }

  Future<void> reorderWidgets(int oldIndex, int newIndex) async {
    final current = [...(state.valueOrNull ?? await _loadFromIsar())];
    if (oldIndex < 0 || oldIndex >= current.length) return;
    if (newIndex < 0 || newIndex >= current.length) return;

    final item = current.removeAt(oldIndex);
    current.insert(newIndex, item);

    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      for (var i = 0; i < current.length; i++) {
        final entry = current[i];
        final row = await isar.homeWidgetDbs.getByAppWidgetId(
          entry.appWidgetId,
        );
        if (row == null) continue;
        row.position = i;
        await isar.homeWidgetDbs.put(row);
      }
    });
    await refresh();
  }
}

final iconThemeProvider = NotifierProvider<IconThemeNotifier, AppIconTheme>(
  IconThemeNotifier.new,
);

class IconThemeNotifier extends Notifier<AppIconTheme> {
  @override
  AppIconTheme build() {
    unawaited(_loadTheme());
    return AppIconTheme.defaultTheme;
  }

  Future<void> _loadTheme() async {
    final isar = await ref.read(isarProvider.future);
    final settings = await isar.settingsDbs.get(1);
    if (settings == null) {
      await isar.writeTxn(() async {
        await isar.settingsDbs.put(_defaultSettingsDb());
      });
      state = AppIconTheme.defaultTheme;
      return;
    }

    final index = settings.iconTheme;
    if (index < 0 || index >= AppIconTheme.values.length) {
      state = AppIconTheme.defaultTheme;
      return;
    }
    state = AppIconTheme.values[index];
  }

  Future<void> setTheme(AppIconTheme theme) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.iconTheme = theme.index;
      await isar.settingsDbs.put(settings);
    });
    state = theme;
  }
}

final starredAppsProvider = NotifierProvider<StarredAppsNotifier, List<String>>(
  StarredAppsNotifier.new,
);

class StarredAppsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    unawaited(_load());
    return const <String>[];
  }

  Future<void> _load() async {
    final isar = await ref.read(isarProvider.future);
    final rows = await isar.starredAppDbs.where().sortByPosition().findAll();
    state = rows.map((row) => row.packageName).toList(growable: false);
  }

  Future<StarredResult> toggleStarred(AppInfo app) async {
    final normalized = appIdentityKey(app).trim();
    if (normalized.isEmpty) return StarredResult.unchanged;

    final current = [...state];
    final isar = await ref.read(isarProvider.future);

    int findStoredIndex() {
      for (var i = 0; i < current.length; i++) {
        if (storedKeyMatchesApp(current[i], app)) {
          return i;
        }
      }
      return -1;
    }

    final existingIndex = findStoredIndex();

    if (existingIndex >= 0) {
      final storedKey = current[existingIndex];
      current.removeAt(existingIndex);
      state = current;
      await isar.writeTxn(() async {
        await isar.starredAppDbs.deleteByPackageName(storedKey);
        if (storedKey != normalized) {
          await isar.starredAppDbs.deleteByPackageName(normalized);
        }
        for (var i = 0; i < current.length; i++) {
          final row = await isar.starredAppDbs.getByPackageName(current[i]);
          if (row == null || row.position == i) continue;
          row.position = i;
          await isar.starredAppDbs.put(row);
        }
      });
      return StarredResult.removed;
    }

    if (current.length >= kMaxStarredApps) {
      return StarredResult.limitReached;
    }

    current.add(normalized);
    state = current;
    await isar.writeTxn(() async {
      final existing = await isar.starredAppDbs
          .where()
          .sortByPosition()
          .findAll();
      final nextPosition = existing.isEmpty ? 0 : existing.last.position + 1;
      await isar.starredAppDbs.putByPackageName(
        StarredAppDb()
          ..packageName = normalized
          ..position = nextPosition,
      );
    });
    return StarredResult.added;
  }
}

final blackBoxSettingsProvider = StreamProvider<BlackBoxSettingsDb?>((
  ref,
) async* {
  final isar = await ref.watch(isarProvider.future);
  yield await isar.blackBoxSettingsDbs.get(1);
  yield* isar.blackBoxSettingsDbs.watchObject(1, fireImmediately: true);
});

final hiddenAppsProvider =
    AsyncNotifierProvider<HiddenAppsNotifier, List<HiddenAppDb>>(
      HiddenAppsNotifier.new,
    );

class HiddenAppsNotifier extends AsyncNotifier<List<HiddenAppDb>> {
  @override
  Future<List<HiddenAppDb>> build() async {
    final isar = await ref.read(isarProvider.future);
    final rows = await isar.hiddenAppDbs.where().findAll();
    return rows;
  }

  Future<void> _load() async {
    final isar = await ref.read(isarProvider.future);
    final rows = await isar.hiddenAppDbs.where().findAll();
    state = AsyncValue.data(rows);
  }

  Future<void> hideApp(AppInfo app) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.hiddenAppDbs.putByPackageName(
        HiddenAppDb()
          ..packageName = appIdentityKey(app)
          ..appName = app.name
          ..icon = app.icon,
      );
    });
    await _load();
  }

  Future<void> unhideApp(String packageName) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.hiddenAppDbs.deleteByPackageName(packageName);
    });
    await _load();
  }

  Future<void> refresh() async {
    await _load();
  }
}

final blackBoxNotifierProvider = Provider<BlackBoxNotifier>(
  (ref) => BlackBoxNotifier(ref),
);

class BlackBoxNotifier {
  BlackBoxNotifier(this.ref);
  final Ref ref;

  Future<bool> isPasswordSet() async {
    final isar = await ref.read(isarProvider.future);
    final settings = await isar.blackBoxSettingsDbs.get(1);
    return settings != null && settings.passwordHash.isNotEmpty;
  }

  Future<void> setPassword(String pin) async {
    final isar = await ref.read(isarProvider.future);
    final hash = _hashPin(pin);
    await isar.writeTxn(() async {
      await isar.blackBoxSettingsDbs.put(
        BlackBoxSettingsDb()
          ..id = 1
          ..passwordHash = hash
          ..isEnabled = true,
      );
    });
  }

  Future<bool> verifyPassword(String pin) async {
    final isar = await ref.read(isarProvider.future);
    final settings = await isar.blackBoxSettingsDbs.get(1);
    if (settings == null || settings.passwordHash.isEmpty) {
      return false;
    }
    return settings.passwordHash == _hashPin(pin);
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

final groupedAppsProvider = Provider<Map<String, List<AppInfo>>>((ref) {
  final sortedApps = [...ref.watch(displayAppsProvider)]
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  final grouped = <String, List<AppInfo>>{};
  for (final app in sortedApps) {
    final name = app.name.trim();
    final first = name.isEmpty ? '#' : name[0].toUpperCase();
    final letter = RegExp(r'^[A-Z]$').hasMatch(first) ? first : '#';
    grouped.putIfAbsent(letter, () => <AppInfo>[]).add(app);
  }

  final keys = grouped.keys.toList()
    ..sort((a, b) {
      if (a == '#') return 1;
      if (b == '#') return -1;
      return a.compareTo(b);
    });

  return {
    for (final key in keys)
      key: List<AppInfo>.unmodifiable(grouped[key] ?? const <AppInfo>[]),
  };
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final layoutAdjustModeProvider = StateProvider<bool>((ref) => false);

final displayAppsProvider = Provider<List<AppInfo>>((ref) {
  final apps = ref.watch(appListProvider).valueOrNull ?? const <AppInfo>[];
  final customNames =
      ref.watch(customAppNamesProvider).valueOrNull ?? const <String, String>{};
  final hiddenAppsAsync = ref.watch(hiddenAppsProvider);

  // Wait for hidden apps to load - return empty list during loading to prevent flicker
  final hiddenApps = hiddenAppsAsync.valueOrNull ?? const <HiddenAppDb>[];
  final hiddenPackages = hiddenApps.map((h) => h.packageName).toSet();

  return apps
      .where((app) => !identityCollectionContainsApp(hiddenPackages, app))
      .map((app) {
        final custom =
            customNames[appIdentityKey(app)] ?? customNames[app.packageName];
        if (custom == null || custom.trim().isEmpty) {
          return app;
        }
        return app.copyWith(name: custom);
      })
      .toList(growable: false);
});

final filteredAppsProvider = Provider<List<AppInfo>>((ref) {
  final apps = ref.watch(displayAppsProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) return apps;

  return apps.where((app) => app.name.toLowerCase().contains(query)).toList();
});

final appListProvider = AsyncNotifierProvider<AppListNotifier, List<AppInfo>>(
  AppListNotifier.new,
);

class AppListNotifier extends AsyncNotifier<List<AppInfo>> {
  StreamSubscription<AppEvent>? _appEventSubscription;

  @override
  Future<List<AppInfo>> build() async {
    final service = ref.read(appServiceProvider);
    _appEventSubscription = service.watchAppEvents().listen((event) {
      if (event.type == 'packages_changed') {
        unawaited(refreshApps());
      }
    });

    ref.onDispose(() => _appEventSubscription?.cancel());

    final cachedApps = await _loadPersistedApps();
    if (cachedApps.isNotEmpty) {
      state = AsyncValue.data(cachedApps);
      unawaited(refreshApps());
      return cachedApps;
    }

    return refreshApps();
  }

  Future<List<AppInfo>> _loadPersistedApps() async {
    final isar = await ref.read(isarProvider.future);
    final persisted = await isar.appInfoDbs.where().sortByPosition().findAll();
    return persisted
        .map(
          (row) => appInfoFromDbRow(
            storedIdentity: row.packageName,
            name: row.appName,
            icon: row.icon,
          ),
        )
        .toList(growable: false);
  }

  bool _matchesPersistedOrderAndNames(
    List<AppInfoDb> persisted,
    List<AppInfo> apps,
  ) {
    if (persisted.length != apps.length) return false;
    for (var i = 0; i < persisted.length; i++) {
      if (persisted[i].packageName != appIdentityKey(apps[i]) ||
          persisted[i].appName != apps[i].name) {
        return false;
      }
    }
    return true;
  }

  Future<List<AppInfo>> refreshApps() async {
    try {
      final isar = await ref.read(isarProvider.future);
      final service = ref.read(appServiceProvider);

      final installedApps = await service.getInstalledApps();
      final uniqueInstalledByIdentity = <String, AppInfo>{};
      for (final app in installedApps) {
        final packageName = app.packageName.trim();
        final identity = appIdentityKey(app).trim();
        if (packageName.isEmpty || identity.isEmpty) continue;
        uniqueInstalledByIdentity.putIfAbsent(identity, () => app);
      }
      final uniqueInstalledApps = uniqueInstalledByIdentity.values.toList();

      final persisted = await isar.appInfoDbs
          .where()
          .sortByPosition()
          .findAll();

      if (uniqueInstalledApps.isEmpty && persisted.isNotEmpty) {
        final fallback = await _loadPersistedApps();
        state = AsyncValue.data(fallback);
        return fallback;
      }

      final installedByIdentity = <String, AppInfo>{
        for (final app in uniqueInstalledApps) appIdentityKey(app): app,
      };

      final orderedApps = <AppInfo>[];
      final seenIdentities = <String>{};

      for (final persistedApp in persisted) {
        final installed = installedByIdentity[persistedApp.packageName];
        if (installed != null) {
          orderedApps.add(installed);
          seenIdentities.add(appIdentityKey(installed));
        }
      }

      for (final app in uniqueInstalledApps) {
        if (!seenIdentities.contains(appIdentityKey(app))) {
          orderedApps.add(app);
        }
      }

      final dedupedOrderedApps = <AppInfo>[];
      final dedupedIdentities = <String>{};
      for (final app in orderedApps) {
        if (dedupedIdentities.add(appIdentityKey(app))) {
          dedupedOrderedApps.add(app);
        }
      }

      if (!_matchesPersistedOrderAndNames(persisted, dedupedOrderedApps)) {
        await isar.writeTxn(() async {
          await isar.appInfoDbs.clear();
          for (var i = 0; i < dedupedOrderedApps.length; i++) {
            final app = dedupedOrderedApps[i];
            await isar.appInfoDbs.putByPackageName(
              AppInfoDb()
                ..packageName = appIdentityKey(app)
                ..appName = app.name
                ..icon = app.icon
                ..position = i,
            );
          }
        });
      }

      await ref
          .read(dockAppsProvider.notifier)
          .syncWithInstalledApps(dedupedOrderedApps);

      state = AsyncValue.data(dedupedOrderedApps);
      return dedupedOrderedApps;
    } catch (_) {
      final current = state.valueOrNull;
      if (current != null && current.isNotEmpty) {
        return current;
      }

      try {
        final fallback = await _loadPersistedApps();
        if (fallback.isNotEmpty) {
          state = AsyncValue.data(fallback);
        }
        return fallback;
      } catch (_) {
        return current ?? const <AppInfo>[];
      }
    }
  }

  Future<void> reorderApps(int oldIndex, int newIndex) async {
    final current = [...(state.value ?? await refreshApps())];
    if (oldIndex < 0 || oldIndex >= current.length) return;
    if (newIndex < 0 || newIndex >= current.length) return;

    final item = current.removeAt(oldIndex);
    current.insert(newIndex, item);

    state = AsyncValue.data(current);

    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      for (var i = 0; i < current.length; i++) {
        final app = current[i];
        final db = await isar.appInfoDbs
            .filter()
            .packageNameEqualTo(appIdentityKey(app))
            .findFirst();
        if (db != null) {
          db.position = i;
          await isar.appInfoDbs.put(db);
        }
      }
    });
  }
}

final dockAppsProvider =
    StateNotifierProvider<DockAppsNotifier, List<AppInfo?>>(
      (ref) => DockAppsNotifier(ref),
    );

class DockAppsNotifier extends StateNotifier<List<AppInfo?>> {
  DockAppsNotifier(this.ref) : super(List<AppInfo?>.filled(5, null)) {
    unawaited(_init());
  }

  final Ref ref;

  Future<void> _init() async {
    final isar = await ref.read(isarProvider.future);
    final persisted = await isar.dockApps.where().sortByPosition().findAll();
    final next = List<AppInfo?>.filled(5, null, growable: false);
    for (final dock in persisted) {
      if (dock.position >= 0 && dock.position < 5) {
        next[dock.position] = appInfoFromDbRow(
          storedIdentity: dock.packageName,
          name: dock.appName,
          icon: dock.icon,
        );
      }
    }
    state = next;
  }

  Future<void> addToDock(AppInfo app, int position) async {
    if (position < 0 || position >= 5) return;

    final next = [...state];
    for (var i = 0; i < next.length; i++) {
      if (next[i] != null && appIdentityKey(next[i]!) == appIdentityKey(app)) {
        next[i] = null;
      }
    }
    next[position] = app;
    state = next;

    await _persistState(next);
  }

  Future<void> removeFromDock(int position) async {
    if (position < 0 || position >= 5) return;

    final next = [...state]..[position] = null;
    state = next;

    await _persistState(next);
  }

  Future<void> syncWithInstalledApps(List<AppInfo> installedApps) async {
    final installedByIdentity = {
      for (final app in installedApps) appIdentityKey(app): app,
    };

    final next = List<AppInfo?>.filled(5, null, growable: false);
    for (var i = 0; i < state.length; i++) {
      final docked = state[i];
      if (docked == null) continue;
      next[i] = installedByIdentity[appIdentityKey(docked)];
    }

    if (_sameDock(state, next)) {
      return;
    }

    state = next;
    await _persistState(next);
  }

  bool _sameDock(List<AppInfo?> a, List<AppInfo?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final aKey = a[i] == null ? null : appIdentityKey(a[i]!);
      final bKey = b[i] == null ? null : appIdentityKey(b[i]!);
      if (aKey != bKey) {
        return false;
      }
    }
    return true;
  }

  Future<void> _persistState(List<AppInfo?> next) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.dockApps.clear();
      final seenIdentities = <String>{};
      for (var i = 0; i < next.length; i++) {
        final app = next[i];
        if (app == null || !seenIdentities.add(appIdentityKey(app))) continue;
        await isar.dockApps.putByPackageName(
          DockApp()
            ..packageName = appIdentityKey(app)
            ..appName = app.name
            ..icon = app.icon
            ..position = i,
        );
      }
    });
  }
}

final wallpaperNotifierProvider = Provider<WallpaperNotifier>(
  (ref) => WallpaperNotifier(ref),
);

class WallpaperNotifier {
  WallpaperNotifier(this.ref);

  final Ref ref;

  Future<void> _refreshWallpaperWithRetry() async {
    ref.invalidate(wallpaperBytesProvider);
    try {
      await ref.read(wallpaperBytesProvider.future);
    } catch (_) {
      // Ignore transient failures from native wallpaper provider.
    }
  }

  Future<bool> setWallpaperFromImagePath(String path) async {
    final result = await _saveWallpaperOverrideFromPath(path);
    if (result) {
      await _refreshWallpaperWithRetry();
    }
    return result;
  }

  Future<bool> resetWallpaper() async {
    await _clearWallpaperOverrideFile();

    final service = ref.read(appServiceProvider);
    final result = await service.resetWallpaperToDefault();
    await _refreshWallpaperWithRetry();
    return result;
  }
}

final settingsNotifierProvider = Provider<SettingsNotifier>(
  (ref) => SettingsNotifier(ref),
);

class SettingsNotifier {
  SettingsNotifier(this.ref);

  final Ref ref;

  Future<void> updateClockStyle(String style) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1);
      if (settings != null) {
        settings.clockStyle = style;
        await isar.settingsDbs.put(settings);
      } else {
        final next = _defaultSettingsDb()..clockStyle = style;
        await isar.settingsDbs.put(next);
      }
    });
  }

  Future<void> updateShowWeatherWidget(bool enabled) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.showWeatherWidget = enabled;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> updateFontScale(double scale) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.fontScaleFactor = scale;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> updateClockSpacing(double spacing) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.clockSpacing = spacing;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> updateFavoritesSpacing(double spacing) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.favoritesSpacing = spacing;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> updateSidebarSpacing(double spacing) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.sidebarSpacing = spacing;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> updateSidebarHorizontalOffset(double offset) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.sidebarHorizontalOffset = offset;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> setLeftWidgetSlot(int? widgetId) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.leftWidgetSlotId = widgetId;
      await isar.settingsDbs.put(settings);
    });
  }

  Future<void> setRightWidgetSlot(int? widgetId) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final settings = await isar.settingsDbs.get(1) ?? _defaultSettingsDb();
      settings.rightWidgetSlotId = widgetId;
      await isar.settingsDbs.put(settings);
    });
  }
}
