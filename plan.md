## Stillmax Launcher Implementation Plan

1. Scaffold a Flutter app in the current folder (`stillmax`) with Android language set to Java.
2. Update `AndroidManifest.xml` to register launcher HOME intent and required permissions.
3. Add required dependencies in `pubspec.yaml`.
4. Create launcher module folders and base files in `lib/screens`, `lib/widgets`, `lib/state`, `lib/services`, and `lib/theme`.
5. Implement a dark-only design system in `lib/theme/app_theme.dart` using exact tokens extracted from `DESIGN.md` and `prototype.html`.
6. Implement reusable glassmorphism container in `lib/widgets/glass_card.dart`.
7. Implement Flutter method-channel bridge in `lib/services/app_service.dart`.
8. Implement Android Java method-channel handlers in `android/app/src/main/java/com/stillmax/MainActivity.java`.
9. Implement Riverpod providers in `lib/state/app_list_provider.dart` (apps + 5-item persisted dock list).
10. Build `lib/screens/home_screen.dart` as root launcher screen (time/date, draggable 4x5 grid, frosted dock, swipe-up to drawer).
11. Build `lib/screens/app_drawer.dart` as sliding sheet with glass search, sticky alphabetical groups, and swipe-down dismiss.
12. Wire app bootstrap in `lib/main.dart` with `ProviderScope`, theme, and home screen route (no login/splash).
13. Run dependency fetch and static checks, then report summary and manual setup steps.
