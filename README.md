# Stillmax Launcher

Stillmax is an Android launcher built with **Flutter + Riverpod + Isar**, with native Android integration through Method Channels.

This README is intentionally simple and practical.

---

## Quick start (5 minutes)

### 1) Install dependencies

```bash
flutter pub get
```

### 2) (Only when Isar models change) regenerate files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3) Run app

```bash
flutter run -d <device-id>
```

### 4) Build release APK

```bash
flutter build apk --release
```

APK path:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Install manually:

```bash
adb -s <device-id> install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## What Stillmax includes

- Home launcher screen
- Favorites section + alphabet filter sidebar
- Swipe-up app drawer with search
- Wallpaper override + default reset
- Weather widget (location-based)
- Media card with play/pause/next/prev controls
- Android widget slots in header
- Black Box hidden-app vault with PIN
- Dual/work/cloned app instance support

---

## Project structure (simple)

### Main app code

```text
lib/
├── main.dart                         # app entry + onboarding gate
├── state/
│   └── app_list_provider.dart        # providers, notifiers, Isar models
├── services/
│   ├── app_service.dart              # Dart ↔ Android bridge
│   ├── icon_theme_service.dart
│   ├── icon_resolver.dart
│   └── icon_cache.dart
├── screens/
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── app_drawer.dart
│   ├── stillmax_settings_screen.dart
│   ├── black_box_password_screen.dart
│   ├── black_box_vault_screen.dart
│   └── settings_screen.dart          # legacy/alternate
└── widgets/
    ├── time_header.dart
    ├── weather_widget.dart
    ├── widget_picker_sheet.dart
    ├── home_widget_view.dart
    ├── alphabet_sidebar.dart
    ├── app_list_tile.dart
    ├── icon_grid.dart
    ├── analog_clock.dart
    └── glass_card.dart
```

### Android native code

```text
android/app/src/main/java/com/stillmax/
├── MainActivity.java
├── StillmaxNotificationListenerService.java
├── MediaNotificationListener.java
└── StillmaxDeviceAdminReceiver.java
```

### Important config/docs

```text
README.md
DESIGN.md
plan.md
pubspec.yaml
android/app/src/main/AndroidManifest.xml
```

---

## Read code in this order (best)

1. `lib/main.dart`
2. `lib/screens/home_screen.dart`
3. `lib/screens/app_drawer.dart`
4. `lib/state/app_list_provider.dart`
5. `lib/services/app_service.dart`
6. `android/app/src/main/java/com/stillmax/MainActivity.java`

---

## Architecture (one-screen view)

```text
Flutter UI (screens/widgets)
        ↓
Riverpod state (providers/notifiers)
        ↓
AppService (Method/Event channel wrapper)
        ↓
MainActivity + Android services
        ↓
Android system APIs (launcher, widgets, media, wallpaper, location, notifications)
```

---

## Core flows (short and clear)

## 1) Startup flow

- `main.dart` loads app.
- Reads onboarding state from Isar.
- Shows:
  - `OnboardingScreen` if first run
  - `HomeScreen` otherwise

## 2) Onboarding + permissions

Final onboarding step asks for:

- Notification runtime permission (`POST_NOTIFICATIONS`, Android 13+)
- Notification listener access (required for media/notification features)

## 3) App list flow

- Flutter asks Android for installed apps.
- Android returns app identity with:
  - `packageName`, `instanceId`, `userSerial`, `className`
- Flutter persists order in Isar and refreshes on package-change events.

## 4) Home + drawer flow

- Home shows wallpaper + blur + header + favorites list.
- Drawer opens via swipe-up (current gesture rules are in `home_screen.dart`).
- Drawer search is debounced and grouped by alphabet.

## 5) Wallpaper flow

- “Replace Wallpaper” saves a local Stillmax override image.
- Background provider first tries override image.
- If no override, it reads system wallpaper bytes from native layer.
- Reset clears override and restores Android default behavior.

## 6) Weather flow

- Gets device location from native.
- Calls wttr.in API.
- Resolves city name.
- Caches weather in Isar and refreshes periodically.

## 7) Widget flow

- User picks widget from picker sheet.
- Native allocates + binds widget ID.
- Widget metadata saved in Isar.
- Rendered via Android platform view (`home_widget_view.dart`).

## 8) Black Box flow

- User sets 6-digit PIN.
- PIN hash stored in Isar.
- Hidden apps are excluded from normal app views.
- Vault screen can launch/unhide those apps.

---

## State and storage

## Key providers (Riverpod)

- `appListProvider` → installed app list
- `displayAppsProvider` → visible apps (hidden removed + custom names)
- `starredAppsProvider` → favorites
- `dockAppsProvider` → dock apps
- `wallpaperBytesProvider` → current background bytes
- `mediaSessionProvider` → active media session
- `notificationCountsProvider` → notification counters
- `settingsProvider` / `settingsNotifierProvider` → launcher settings
- `hiddenAppsProvider` / `blackBoxNotifierProvider` → Black Box

## Isar collections

- `AppInfoDb`
- `DockApp`
- `SettingsDb`
- `PageLayoutDb`
- `FolderDb`
- `FolderAppDb`
- `RecentAppDb`
- `CustomAppNameDb`
- `IconPackDb`
- `OnboardingDb`
- `StarredAppDb`
- `BlackBoxSettingsDb`
- `HiddenAppDb`
- `WeatherCacheDb`
- `HomeWidgetDb`

---

## Native API surface (from Flutter)

Method channel: `com.stillmax/app_service`

Important methods:

- Apps: `getInstalledApps`, `launchApp`, `launchAppHidden`, `openAppInfo`, `uninstallApp`
- Wallpaper: `setWallpaperFromPath`, `getWallpaperBytes`, `resetWallpaperToDefault`
- Notifications/media: `getNotificationPackages`, `getNotificationCounts`, `getActiveMediaSession`, `sendMediaAction`
- Permissions/settings: `requestNotificationPermission`, `isNotificationListenerEnabled`, `openNotificationListenerSettings`
- Widgets: `getAvailableWidgets`, `allocateWidgetId`, `bindWidget`, `createWidgetView`, `deleteWidgetId`
- System: `getBatteryInfo`, `expandStatusBar`, `toggleWifi`, `toggleBluetooth`, `toggleFlashlight`, `setBrightness`, `getQuickSettings`
- Location: `getDeviceLocation`, `getLocationName`

Event channels:

- `com.stillmax/app_events`
- `com.stillmax/home_events`

---

## Permissions used

From `AndroidManifest.xml`:

- Launcher/package visibility:
  - `QUERY_ALL_PACKAGES`
- Wallpaper/media:
  - `SET_WALLPAPER`, `READ_MEDIA_IMAGES` (plus legacy read storage)
- Notifications/media:
  - `POST_NOTIFICATIONS`
  - Notification listener services
- Weather/location:
  - `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
- Quick controls/system:
  - Wi-Fi / Bluetooth / flashlight / settings related permissions

---

## First install checklist

1. Install app
2. Set Stillmax as default launcher (Home app)
3. Complete onboarding
4. Allow notification permission
5. Enable notification listener access
6. (Recommended) enable location permission for accurate weather

---

## Known limitations

- Some OEMs block non-system quick toggles (Wi-Fi/Bluetooth, etc.).
- Weather quality depends on permission + GPS/network quality.
- Test coverage is currently minimal (`test/widget_test.dart`).
- Release config currently uses debug signing for local release runs.

---

## Version

- `pubspec.yaml`: **0.1.14+14**
