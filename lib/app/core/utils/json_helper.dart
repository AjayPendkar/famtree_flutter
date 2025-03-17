class JsonHelper {
  static T? parseJson<T>(Map<String, dynamic>? json, T Function(Map<String, dynamic>) fromJson) {
    try {
      return json != null ? fromJson(json) : null;
    } catch (e) {
      print('Error parsing JSON for type $T: $e');
      return null;
    }
  }

  static String? asString(dynamic value, [String? defaultValue]) {
    try {
      if (value == null) return defaultValue;
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  static int asInt(dynamic value, [int defaultValue = 0]) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static bool asBool(dynamic value, [bool defaultValue = false]) {
    try {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
} 