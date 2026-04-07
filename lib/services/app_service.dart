import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AppService {
  static const MethodChannel _channel = MethodChannel(
    'com.stillmax/app_service',
  );
  static const EventChannel _eventsChannel = EventChannel(
    'com.stillmax/app_events',
  );

  Stream<AppEvent> watchAppEvents() {
    return _eventsChannel.receiveBroadcastStream().map((dynamic event) {
      final map = event as Map<dynamic, dynamic>?;
      return AppEvent(
        type: map?['type'] as String? ?? 'unknown',
        action: map?['action'] as String? ?? '',
        packageName: map?['packageName'] as String? ?? '',
      );
    });
  }

  Future<List<AppInfo>> getInstalledApps() async {
    final List<dynamic>? result = await _channel.invokeMethod(
      'getInstalledApps',
    );
    if (result == null) return <AppInfo>[];

    return result.map((item) {
      final map = item as Map<dynamic, dynamic>;
      return AppInfo(
        name:
            (map['name'] as String?) ??
            (map['appName'] as String?) ??
            'Unknown',
        packageName: map['packageName'] as String? ?? '',
        icon: map['icon'] as Uint8List? ?? Uint8List(0),
      );
    }).toList();
  }

  Future<bool> launchApp(String packageName) async {
    final bool? result = await _channel.invokeMethod('launchApp', {
      'packageName': packageName,
    });
    return result ?? false;
  }

  Future<bool> launchAppHidden(String packageName) async {
    if (packageName.isEmpty) {
      debugPrint('launchAppHidden: empty package name');
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('launchAppHidden', {
        'packageName': packageName,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('launchAppHidden failed: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('launchAppHidden error: $e');
      return false;
    }
  }

  Future<bool> setWallpaper(String imagePath) async {
    final bool? result = await _channel.invokeMethod('setWallpaper', {
      'imagePath': imagePath,
    });
    return result ?? false;
  }

  Future<bool> openAppInfo(String packageName) async {
    final bool? result = await _channel.invokeMethod('openAppInfo', {
      'packageName': packageName,
    });
    return result ?? false;
  }

  Future<bool> uninstallApp(String packageName) async {
    final bool? result = await _channel.invokeMethod('uninstallApp', {
      'packageName': packageName,
    });
    return result ?? false;
  }

  Future<bool> expandStatusBar() async {
    final bool? result = await _channel.invokeMethod('expandStatusBar');
    return result ?? false;
  }

  Future<Uint8List?> getWallpaperBytes() async {
    final Uint8List? bytes = await _channel.invokeMethod('getWallpaperBytes');
    return bytes;
  }

  Future<List<String>> getNotificationPackages() async {
    final List<dynamic>? result = await _channel.invokeMethod(
      'getNotificationPackages',
    );
    if (result == null) return <String>[];
    return result.map((value) => value.toString()).toList();
  }

  Future<Map<String, dynamic>> getBatteryInfo() async {
    final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
      'getBatteryInfo',
    );
    return {
      'level': result?['level'] ?? 100,
      'charging': result?['charging'] ?? false,
    };
  }

  Future<bool> setWallpaperFromPath(String path) async {
    final bool? result = await _channel.invokeMethod('setWallpaperFromPath', {
      'path': path,
    });
    return result ?? false;
  }

  Future<List<IconPackInfo>> getInstalledIconPacks() async {
    final List<dynamic>? result = await _channel.invokeMethod(
      'getInstalledIconPacks',
    );
    if (result == null) return <IconPackInfo>[];
    return result.map((item) {
      final map = item as Map<dynamic, dynamic>;
      return IconPackInfo(
        packageName: map['packageName'] as String? ?? '',
        label: map['label'] as String? ?? 'Unknown',
      );
    }).toList();
  }

  Future<Uint8List?> getIconFromPack(
    String iconPackPackage,
    String appPackage,
  ) async {
    final Uint8List? result = await _channel.invokeMethod('getIconFromPack', {
      'iconPackPackage': iconPackPackage,
      'appPackage': appPackage,
    });
    return result;
  }

  Future<bool> toggleWifi(bool enable) async {
    final bool? result = await _channel.invokeMethod('toggleWifi', {
      'enable': enable,
    });
    return result ?? false;
  }

  Future<bool> toggleBluetooth(bool enable) async {
    final bool? result = await _channel.invokeMethod('toggleBluetooth', {
      'enable': enable,
    });
    return result ?? false;
  }

  Future<bool> toggleFlashlight(bool enable) async {
    final bool? result = await _channel.invokeMethod('toggleFlashlight', {
      'enable': enable,
    });
    return result ?? false;
  }

  Future<bool> setBrightness(int level) async {
    final bool? result = await _channel.invokeMethod('setBrightness', {
      'level': level,
    });
    return result ?? false;
  }

  Future<Map<String, dynamic>> getQuickSettings() async {
    final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
      'getQuickSettings',
    );
    return {
      'wifiEnabled': result?['wifiEnabled'] ?? false,
      'bluetoothEnabled': result?['bluetoothEnabled'] ?? false,
      'brightness': result?['brightness'] ?? 128,
    };
  }

  Future<Map<String, int>> getNotificationCounts() async {
    final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
      'getNotificationCounts',
    );
    if (result == null) return {};
    return result.map((key, value) => MapEntry(key.toString(), value as int));
  }

  Future<LatLng?> getDeviceLocation() async {
    final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
      'getDeviceLocation',
    );
    if (result == null) return null;

    final lat = (result['latitude'] as num?)?.toDouble();
    final lon = (result['longitude'] as num?)?.toDouble();
    if (lat == null || lon == null) {
      return null;
    }
    return LatLng(latitude: lat, longitude: lon);
  }

  Future<String?> getLocationName(double lat, double lon) async {
    try {
      final String? result = await _channel.invokeMethod('getLocationName', {
        'latitude': lat,
        'longitude': lon,
      });
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<List<AvailableWidgetInfo>> getAvailableWidgets() async {
    final List<dynamic>? result = await _channel.invokeMethod(
      'getAvailableWidgets',
    );
    if (result == null) return const <AvailableWidgetInfo>[];

    return result
        .map((dynamic item) {
          final map = item as Map<dynamic, dynamic>;
          final previewDynamic = map['preview'];
          Uint8List? preview;
          if (previewDynamic is Uint8List) {
            preview = previewDynamic;
          } else if (previewDynamic is List<dynamic>) {
            preview = Uint8List.fromList(previewDynamic.cast<int>());
          }
          return AvailableWidgetInfo(
            label: map['label'] as String? ?? 'Widget',
            packageName: map['packageName'] as String? ?? '',
            className: map['className'] as String? ?? '',
            minWidth: (map['minWidth'] as num?)?.toInt() ?? 0,
            minHeight: (map['minHeight'] as num?)?.toInt() ?? 0,
            preview: preview,
          );
        })
        .toList(growable: false);
  }

  Future<int?> allocateWidgetId() async {
    final int? result = await _channel.invokeMethod('allocateWidgetId');
    return result;
  }

  Future<bool> bindWidget(
    int appWidgetId,
    String packageName,
    String className,
  ) async {
    final bool? result = await _channel.invokeMethod('bindWidget', {
      'appWidgetId': appWidgetId,
      'packageName': packageName,
      'className': className,
    });
    return result ?? false;
  }

  Future<bool> deleteWidgetId(int appWidgetId) async {
    final bool? result = await _channel.invokeMethod('deleteWidgetId', {
      'appWidgetId': appWidgetId,
    });
    return result ?? false;
  }

  Future<bool> createWidgetView(int appWidgetId) async {
    final bool? result = await _channel.invokeMethod('createWidgetView', {
      'appWidgetId': appWidgetId,
    });
    return result ?? false;
  }

  Future<Map<String, dynamic>?> getActiveMediaSession() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'getActiveMediaSession',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Media session error: ${e.message}');
      return null;
    }
  }

  Future<void> sendMediaAction(String action) async {
    try {
      await _channel.invokeMethod('sendMediaAction', {'action': action});
    } on PlatformException catch (e) {
      debugPrint('Media action error: ${e.message}');
    }
  }

  Future<void> openNotificationListenerSettings() async {
    try {
      await _channel.invokeMethod('openNotificationListenerSettings');
    } on PlatformException catch (e) {
      debugPrint('Settings error: ${e.message}');
    }
  }
}

class LatLng {
  const LatLng({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class AvailableWidgetInfo {
  const AvailableWidgetInfo({
    required this.label,
    required this.packageName,
    required this.className,
    required this.minWidth,
    required this.minHeight,
    required this.preview,
  });

  final String label;
  final String packageName;
  final String className;
  final int minWidth;
  final int minHeight;
  final Uint8List? preview;
}

class IconPackInfo {
  const IconPackInfo({required this.packageName, required this.label});
  final String packageName;
  final String label;
}

class AppEvent {
  const AppEvent({
    required this.type,
    required this.action,
    required this.packageName,
  });

  final String type;
  final String action;
  final String packageName;
}

/// Model class representing an installed Android application.
class AppInfo {
  final String name;
  final String packageName;
  final Uint8List icon;

  const AppInfo({
    required this.name,
    required this.packageName,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName;

  @override
  int get hashCode => packageName.hashCode;

  @override
  String toString() => 'AppInfo(name: $name, package: $packageName)';
}
