import 'dart:typed_data';

class IconCache {
  static final IconCache _instance = IconCache._internal();
  factory IconCache() => _instance;
  IconCache._internal();

  final Map<String, Uint8List> _cache = {};
  static const int maxEntries = 150;

  Uint8List? get(String key) => _cache[key];

  void put(String key, Uint8List value) {
    if (_cache.length >= maxEntries) {
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }
    _cache[key] = value;
  }

  void clear() => _cache.clear();
}
