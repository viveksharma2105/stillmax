import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../services/app_service.dart';
import '../theme/app_theme.dart';

part 'app_list_provider.g.dart';

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
    ..iconShape = 1
    ..fontScaleFactor = 1.0
    ..hapticsEnabled = true
    ..clockStyle = 'digital'
    ..iconTheme = AppIconTheme.defaultTheme.index
    ..clockSpacing = 40.0
    ..sidebarSpacing = 100.0
    ..favoritesSpacing = 8.0;
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

final wallpaperBytesProvider = FutureProvider<Uint8List?>((ref) async {
  final service = ref.watch(appServiceProvider);
  return service.getWallpaperBytes();
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
  while (true) {
    try {
      yield await service.getActiveMediaSession();
    } catch (_) {
      yield null;
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

  Future<StarredResult> toggleStarred(String packageName) async {
    final normalized = packageName.trim();
    if (normalized.isEmpty) return StarredResult.unchanged;

    final current = [...state];
    final isar = await ref.read(isarProvider.future);

    if (current.contains(normalized)) {
      current.remove(normalized);
      state = current;
      await isar.writeTxn(() async {
        await isar.starredAppDbs.deleteByPackageName(normalized);
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

  return apps
      .map((app) {
        final custom = customNames[app.packageName];
        if (custom == null || custom.trim().isEmpty) {
          return app;
        }
        return AppInfo(
          name: custom,
          packageName: app.packageName,
          icon: app.icon,
        );
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
          (row) => AppInfo(
            name: row.appName,
            packageName: row.packageName,
            icon: Uint8List.fromList(row.icon),
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
      if (persisted[i].packageName != apps[i].packageName ||
          persisted[i].appName != apps[i].name) {
        return false;
      }
    }
    return true;
  }

  Future<List<AppInfo>> refreshApps() async {
    final isar = await ref.read(isarProvider.future);
    final service = ref.read(appServiceProvider);

    final installedApps = await service.getInstalledApps();
    final uniqueInstalledByPackage = <String, AppInfo>{};
    for (final app in installedApps) {
      final packageName = app.packageName.trim();
      if (packageName.isEmpty) continue;
      uniqueInstalledByPackage.putIfAbsent(packageName, () => app);
    }
    final uniqueInstalledApps = uniqueInstalledByPackage.values.toList();

    final persisted = await isar.appInfoDbs.where().sortByPosition().findAll();

    if (uniqueInstalledApps.isEmpty && persisted.isNotEmpty) {
      final fallback = await _loadPersistedApps();
      state = AsyncValue.data(fallback);
      return fallback;
    }

    final installedByPackage = <String, AppInfo>{
      for (final app in uniqueInstalledApps) app.packageName: app,
    };

    final orderedApps = <AppInfo>[];
    final seenPackages = <String>{};

    for (final persistedApp in persisted) {
      final installed = installedByPackage[persistedApp.packageName];
      if (installed != null) {
        orderedApps.add(installed);
        seenPackages.add(installed.packageName);
      }
    }

    for (final app in uniqueInstalledApps) {
      if (!seenPackages.contains(app.packageName)) {
        orderedApps.add(app);
      }
    }

    final dedupedOrderedApps = <AppInfo>[];
    final dedupedPackages = <String>{};
    for (final app in orderedApps) {
      if (dedupedPackages.add(app.packageName)) {
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
              ..packageName = app.packageName
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
            .packageNameEqualTo(app.packageName)
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
        next[dock.position] = AppInfo(
          name: dock.appName,
          packageName: dock.packageName,
          icon: Uint8List.fromList(dock.icon),
        );
      }
    }
    state = next;
  }

  Future<void> addToDock(AppInfo app, int position) async {
    if (position < 0 || position >= 5) return;

    final next = [...state];
    for (var i = 0; i < next.length; i++) {
      if (next[i]?.packageName == app.packageName) {
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
    final installedByPackage = {
      for (final app in installedApps) app.packageName: app,
    };

    final next = List<AppInfo?>.filled(5, null, growable: false);
    for (var i = 0; i < state.length; i++) {
      final docked = state[i];
      if (docked == null) continue;
      next[i] = installedByPackage[docked.packageName];
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
      if (a[i]?.packageName != b[i]?.packageName) {
        return false;
      }
    }
    return true;
  }

  Future<void> _persistState(List<AppInfo?> next) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.dockApps.clear();
      final seenPackages = <String>{};
      for (var i = 0; i < next.length; i++) {
        final app = next[i];
        if (app == null || !seenPackages.add(app.packageName)) continue;
        await isar.dockApps.putByPackageName(
          DockApp()
            ..packageName = app.packageName
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

  Future<bool> setWallpaperFromImagePath(String path) async {
    final service = ref.read(appServiceProvider);
    final result = await service.setWallpaperFromPath(path);
    if (result) {
      // Invalidate the wallpaperBytesProvider to refresh the UI
      ref.invalidate(wallpaperBytesProvider);
    }
    return result;
  }

  Future<bool> resetWallpaper() async {
    final service = ref.read(appServiceProvider);
    // Pass empty string to reset/clear the wallpaper
    final result = await service.setWallpaperFromPath('');
    if (result) {
      // Invalidate the wallpaperBytesProvider to refresh the UI
      ref.invalidate(wallpaperBytesProvider);
    }
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
