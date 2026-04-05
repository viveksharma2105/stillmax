import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/app_service.dart';
import '../state/app_list_provider.dart';

class WeatherInfo {
  const WeatherInfo({
    required this.city,
    required this.cityName,
    required this.temperatureC,
    required this.condition,
    required this.conditionCode,
    required this.lastFetched,
  });

  final String city;
  final String? cityName;
  final double temperatureC;
  final String condition;
  final String conditionCode;
  final DateTime lastFetched;

  String get shortCondition {
    final normalized = condition.trim();
    if (normalized.isEmpty) return 'CLEAR';
    return normalized.split(' ').first.toUpperCase();
  }
}

String? _cachedLocationName;
DateTime? _cachedLocationNameAt;

final weatherInfoProvider = StreamProvider.autoDispose<WeatherInfo?>((
  ref,
) async* {
  final isar = await ref.watch(isarProvider.future);
  final appService = ref.watch(appServiceProvider);

  var disposed = false;
  ref.onDispose(() {
    disposed = true;
  });

  WeatherInfo? latest;
  final cached = await isar.weatherCacheDbs.get(1);
  if (cached != null) {
    latest = WeatherInfo(
      city: cached.city,
      cityName: cached.city,
      temperatureC: cached.temperature,
      condition: cached.condition,
      conditionCode: cached.conditionCode,
      lastFetched: cached.lastFetched,
    );
    yield latest;
  } else {
    yield null;
  }

  while (!disposed) {
    var success = false;
    try {
      final fresh = await _fetchWeatherInfo(appService);
      if (disposed) break;
      if (fresh != null) {
        await isar.writeTxn(() async {
          await isar.weatherCacheDbs.put(
            WeatherCacheDb()
              ..id = 1
              ..city = fresh.city
              ..temperature = fresh.temperatureC
              ..condition = fresh.condition
              ..conditionCode = fresh.conditionCode
              ..lastFetched = fresh.lastFetched,
          );
        });
        latest = fresh;
        success = true;
        yield fresh;
      }
    } catch (_) {
      success = false;
    }

    if (!success && latest == null) {
      yield null;
    }

    if (disposed) break;
    await Future<void>.delayed(
      success ? const Duration(minutes: 30) : const Duration(minutes: 2),
    );
  }
});

Future<WeatherInfo?> _fetchWeatherInfo(AppService appService) async {
  final location = await appService.getDeviceLocation();
  final payload = await _fetchWttrPayload(location);
  if (payload == null) {
    return null;
  }

  final currentList = payload['current_condition'] as List<dynamic>?;
  if (currentList == null || currentList.isEmpty) {
    return null;
  }
  final first = currentList.first;
  if (first is! Map<String, dynamic>) {
    return null;
  }
  final current = first;

  final tempText = current['temp_C']?.toString() ?? '0';
  final temperatureC = double.tryParse(tempText) ?? 0;

  final weatherDesc = current['weatherDesc'] as List<dynamic>?;
  String condition = 'Clear';
  if (weatherDesc != null && weatherDesc.isNotEmpty) {
    final first = weatherDesc.first;
    if (first is Map<String, dynamic>) {
      condition = first['value']?.toString() ?? 'Clear';
    }
  }

  final conditionCode = current['weatherCode']?.toString() ?? '';
  final city = await _getCityName(appService, location, payload);

  return WeatherInfo(
    city: city,
    cityName: city,
    temperatureC: temperatureC,
    condition: condition,
    conditionCode: conditionCode,
    lastFetched: DateTime.now(),
  );
}

Future<String> _getCityName(
  AppService appService,
  LatLng? location,
  Map<String, dynamic> payload,
) async {
  final now = DateTime.now();
  if (_cachedLocationName != null && _cachedLocationNameAt != null) {
    if (now.difference(_cachedLocationNameAt!) < const Duration(hours: 1)) {
      return _cachedLocationName!;
    }
  }

  final cached = _extractCity(payload);
  if (cached != null && cached.isNotEmpty) {
    _cachedLocationName = cached;
    _cachedLocationNameAt = now;
    return cached;
  }

  if (location != null) {
    final resolved = await appService.getLocationName(
      location.latitude,
      location.longitude,
    );
    final city = resolved?.trim();
    if (city != null && city.isNotEmpty && city.toLowerCase() != 'unknown') {
      _cachedLocationName = city;
      _cachedLocationNameAt = now;
      return city;
    }
  }

  return _cachedLocationName ?? 'Current';
}

Future<Map<String, dynamic>?> _fetchWttrPayload(LatLng? location) async {
  final uri = location == null
      ? Uri.parse('https://wttr.in/?format=j1')
      : Uri.parse(
          'https://wttr.in/${location.latitude.toStringAsFixed(4)},${location.longitude.toStringAsFixed(4)}?format=j1',
        );

  final response = await http.get(uri).timeout(const Duration(seconds: 12));
  if (response.statusCode < 200 || response.statusCode >= 300) {
    return null;
  }

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }
  return null;
}

String? _extractCity(Map<String, dynamic> payload) {
  final nearestAreas = payload['nearest_area'] as List<dynamic>?;
  if (nearestAreas == null || nearestAreas.isEmpty) {
    return null;
  }

  final firstArea = nearestAreas.first;
  if (firstArea is! Map<String, dynamic>) {
    return null;
  }

  final areaNames = firstArea['areaName'] as List<dynamic>?;
  if (areaNames == null || areaNames.isEmpty) {
    return null;
  }

  final firstName = areaNames.first;
  if (firstName is! Map<String, dynamic>) {
    return null;
  }

  final city = firstName['value']?.toString().trim();
  if (city == null || city.isEmpty) {
    return null;
  }
  return city;
}

const Map<String, String> _weatherCodeToEmoji = <String, String>{
  '113': '☀️',
  '116': '⛅',
  '119': '☁️',
  '122': '☁️',
  '143': '☁️',
  '176': '🌧️',
  '179': '❄️',
  '182': '🌨️',
  '185': '🌨️',
  '200': '⛈️',
  '227': '❄️',
  '230': '❄️',
  '248': '☁️',
  '260': '☁️',
  '263': '🌧️',
  '266': '🌧️',
  '281': '🌨️',
  '284': '🌨️',
  '293': '🌧️',
  '296': '🌧️',
  '299': '🌧️',
  '302': '🌧️',
  '305': '🌧️',
  '308': '🌧️',
  '311': '🌨️',
  '314': '🌨️',
  '317': '🌨️',
  '320': '🌨️',
  '323': '❄️',
  '326': '❄️',
  '329': '❄️',
  '332': '❄️',
  '335': '❄️',
  '338': '❄️',
  '350': '🌨️',
  '353': '🌧️',
  '356': '🌧️',
  '359': '🌧️',
  '362': '🌨️',
  '365': '🌨️',
  '368': '❄️',
  '371': '❄️',
  '374': '🌨️',
  '377': '🌨️',
  '386': '⛈️',
  '389': '⛈️',
  '392': '⛈️',
  '395': '⛈️',
};

String _weatherEmoji(String code) {
  return _weatherCodeToEmoji[code] ?? '⛅';
}

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherInfoProvider).valueOrNull;

    final emoji = weather == null
        ? '🌡️'
        : _weatherEmoji(weather.conditionCode);
    final tempLabel = weather == null
        ? '--°'
        : '${weather.temperatureC.round()}°';
    final condition = weather?.shortCondition ?? 'LOADING';
    final cityName = weather?.cityName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            tempLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (cityName != null && cityName.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              cityName,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
          const SizedBox(height: 1),
          Text(
            condition,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}
