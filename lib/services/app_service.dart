import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

const _identitySeparator = '|';

String buildAppIdentityKey({
  required String packageName,
  String? instanceId,
  int? userSerial,
  int userUid = -1,
  String? className,
}) {
  final normalizedPackage = packageName.trim();
  final normalizedInstanceId = (instanceId ?? '').trim();
  final normalizedUserSerial = userSerial ?? 0;
  final normalizedUserUid = userUid;
  final normalizedClassName = (className ?? '').trim();
  return [
    normalizedPackage,
    normalizedUserSerial.toString(),
    normalizedUserUid.toString(),
    normalizedInstanceId,
    normalizedClassName,
  ].join(_identitySeparator);
}

AppIdentityParts parseAppIdentityKey(String identityKey) {
  final parts = identityKey.split(_identitySeparator);
  if (parts.length < 4) {
    return AppIdentityParts(
      packageName: identityKey.trim(),
      userSerial: 0,
      userUid: -1,
      instanceId: '',
      className: '',
    );
  }

  final userSerial = int.tryParse(parts[1]) ?? 0;
  final parsedUid = parts.length >= 5 ? int.tryParse(parts[2]) : null;
  final isNewFormat = parsedUid != null;
  return AppIdentityParts(
    packageName: parts[0],
    userSerial: userSerial,
    userUid: isNewFormat ? parsedUid : -1,
    instanceId: isNewFormat ? parts[3] : parts[2],
    className: parts.sublist(isNewFormat ? 4 : 3).join(_identitySeparator),
  );
}

class AppService {
  static const MethodChannel _channel = MethodChannel(
    'com.stillmax/app_service',
  );
  static const EventChannel _eventsChannel = EventChannel(
    'com.stillmax/app_events',
  );
  static const EventChannel _homeEventChannel = EventChannel(
    'com.stillmax/home_events',
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

  /// Stream that emits when home button is pressed while app is in foreground
  Stream<void> get onHomePressed =>
      _homeEventChannel.receiveBroadcastStream().map((_) {});

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod(
        'getInstalledApps',
      );
      if (result == null) return <AppInfo>[];

      int parseInt(dynamic value, int fallback) {
        if (value is num) return value.toInt();
        return int.tryParse(value?.toString() ?? '') ?? fallback;
      }

      Uint8List parseIcon(dynamic value) {
        if (value is Uint8List) {
          return value;
        }
        if (value is List<int>) {
          return Uint8List.fromList(value);
        }
        if (value is List<dynamic>) {
          final bytes = value
              .whereType<num>()
              .map((e) => e.toInt())
              .toList(growable: false);
          return Uint8List.fromList(bytes);
        }
        return Uint8List(0);
      }

      return result
          .whereType<Map<dynamic, dynamic>>()
          .map((map) {
            final nameFromName = map['name']?.toString();
            final nameFromAppName = map['appName']?.toString();
            final resolvedName =
                (nameFromName != null && nameFromName.trim().isNotEmpty)
                ? nameFromName
                : ((nameFromAppName != null &&
                          nameFromAppName.trim().isNotEmpty)
                      ? nameFromAppName
                      : 'Unknown');

            return AppInfo(
              name: resolvedName,
              packageName: map['packageName']?.toString() ?? '',
              instanceId: map['instanceId']?.toString() ?? '',
              userSerial: parseInt(map['userSerial'], 0),
              userUid: parseInt(map['userUid'], -1),
              className: map['className']?.toString() ?? '',
              icon: parseIcon(map['icon']),
            );
          })
          .toList(growable: false);
    } catch (_) {
      return <AppInfo>[];
    }
  }

  Future<bool> launchApp(AppInfo app) async {
    final bool? result = await _channel.invokeMethod('launchApp', {
      ...app.toChannelMap(),
    });
    return result ?? false;
  }

  Future<bool> launchAppHidden(AppInfo app) async {
    if (app.packageName.isEmpty) {
      debugPrint('launchAppHidden: empty package name');
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('launchAppHidden', {
        ...app.toChannelMap(),
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

  Future<bool> openAppInfo(AppInfo app) async {
    final bool? result = await _channel.invokeMethod('openAppInfo', {
      ...app.toChannelMap(),
    });
    return result ?? false;
  }

  Future<bool> uninstallApp(AppInfo app) async {
    final bool? result = await _channel.invokeMethod('uninstallApp', {
      ...app.toChannelMap(),
    });
    return result ?? false;
  }

  Future<bool> expandStatusBar() async {
    final bool? result = await _channel.invokeMethod('expandStatusBar');
    return result ?? false;
  }

  Future<Uint8List?> getWallpaperBytes() async {
    try {
      final Uint8List? bytes = await _channel.invokeMethod('getWallpaperBytes');
      return bytes;
    } catch (_) {
      return null;
    }
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

  Future<bool> resetWallpaperToDefault() async {
    final bool? result = await _channel.invokeMethod('resetWallpaperToDefault');
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

  Future<bool> requestNotificationPermission() async {
    try {
      final bool? granted = await _channel.invokeMethod<bool>(
        'requestNotificationPermission',
      );
      return granted ?? false;
    } on PlatformException catch (e) {
      debugPrint('Notification permission error: ${e.message}');
      return false;
    }
  }

  Future<bool> isNotificationListenerEnabled() async {
    try {
      final bool? enabled = await _channel.invokeMethod<bool>(
        'isNotificationListenerEnabled',
      );
      return enabled ?? false;
    } on PlatformException catch (e) {
      debugPrint('Notification listener check error: ${e.message}');
      return false;
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

class AppIdentityParts {
  const AppIdentityParts({
    required this.packageName,
    required this.instanceId,
    required this.userSerial,
    required this.userUid,
    required this.className,
  });

  final String packageName;
  final String instanceId;
  final int userSerial;
  final int userUid;
  final String className;
}

/// Model class representing an installed Android application.
class AppInfo {
  final String name;
  final String packageName;
  final String instanceId;
  final int userSerial;
  final int userUid;
  final String className;
  final Uint8List icon;

  const AppInfo({
    required this.name,
    required this.packageName,
    this.instanceId = '',
    this.userSerial = 0,
    this.userUid = -1,
    this.className = '',
    required this.icon,
  });

  String get instanceKey => buildAppIdentityKey(
    packageName: packageName,
    instanceId: instanceId,
    userSerial: userSerial,
    userUid: userUid,
    className: className,
  );

  Map<String, dynamic> toChannelMap() {
    return {
      'packageName': packageName,
      'instanceId': instanceId,
      'userSerial': userSerial,
      'userUid': userUid,
      'className': className,
    };
  }

  AppInfo copyWith({
    String? name,
    String? packageName,
    String? instanceId,
    int? userSerial,
    int? userUid,
    String? className,
    Uint8List? icon,
  }) {
    return AppInfo(
      name: name ?? this.name,
      packageName: packageName ?? this.packageName,
      instanceId: instanceId ?? this.instanceId,
      userSerial: userSerial ?? this.userSerial,
      userUid: userUid ?? this.userUid,
      className: className ?? this.className,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          runtimeType == other.runtimeType &&
          instanceKey == other.instanceKey;

  @override
  int get hashCode => instanceKey.hashCode;

  @override
  String toString() =>
      'AppInfo(name: $name, package: $packageName, userSerial: $userSerial, userUid: $userUid, instanceId: $instanceId, className: $className)';
}
