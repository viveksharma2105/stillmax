
 ### Where your state code actually is

 1. Main state hub
     - lib/state/app_list_provider.dart
     - Big file with almost all app state providers + notifiers.
 2. State bootstrapped here
     - lib/main.dart:50 → ProviderScope
     - lib/main.dart:58 → root Consumer
 3. State library used
     - pubspec.yaml:35 → flutter_riverpod: ^2.6.1
     - So project uses Riverpod, not Kotlin StateFlow.
 4. Key providers in state hub
     - lib/state/app_list_provider.dart:264 isarProvider
     - :285 settingsProvider
     - :522 wallpaperBytesProvider
     - :555 notificationProvider
     - :583 mediaSessionProvider
     - :667 widgetListProvider
     - :774 iconThemeProvider
     - :815 starredAppsProvider
     - :899 hiddenAppsProvider
     - :1012 searchQueryProvider
     - :1048 appListProvider
     - :1226 dockAppsProvider
 5. Native event/data stream bridge
     - lib/services/app_service.dart
     - MethodChannel + EventChannel (not StateFlow)
     - watchAppEvents() at line 62
 6. UI reads state here (examples)
     - lib/screens/home_screen.dart:404 displayAppsProvider
     - lib/screens/home_screen.dart:411 settingsProvider
     - lib/screens/stillmax_settings_screen.dart:345 settingsProvider
     - lib/screens/app_drawer.dart:191 displayAppsProvider
 7. Generated state schema file
     - lib/state/app_list_provider.g.dart (Isar generated code)
 8. Android native side
     - Only Java files in android/app/src/main/java/...
     - No .kt files, so no Kotlin StateFlow class currently.
