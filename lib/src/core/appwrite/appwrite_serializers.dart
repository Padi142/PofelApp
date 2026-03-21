import 'dart:convert';

import 'package:pofel_app/src/core/models/geo_point.dart';

DateTime parseDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value).toLocal();
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

String serializeDateTime(DateTime value) => value.toUtc().toIso8601String();

GeoPoint parseGeoPoint(dynamic value) {
  if (value is GeoPoint) {
    return value;
  }
  if (value is Map<String, dynamic>) {
    return GeoPoint(
      parseDouble(value['lat']),
      parseDouble(value['lng']),
    );
  }
  if (value is String && value.isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return GeoPoint(
          parseDouble(decoded['lat']),
          parseDouble(decoded['lng']),
        );
      }
    } catch (_) {}
  }
  return const GeoPoint(0, 0);
}

String serializeGeoPoint(GeoPoint value) => jsonEncode({
      'lat': value.latitude,
      'lng': value.longitude,
    });

double parseDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}

int parseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.round();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

bool parseBool(dynamic value, {bool defaultValue = false}) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return defaultValue;
}

List<String> parseStringList(dynamic value) {
  if (value is List) {
    return value.map((entry) => entry.toString()).toList();
  }
  return const [];
}

Map<String, dynamic> sanitizeDocumentData(Map<String, dynamic> data) {
  final sanitized = Map<String, dynamic>.from(data);
  sanitized.remove(r'$id');
  return sanitized;
}
