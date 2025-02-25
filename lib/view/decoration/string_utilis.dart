import 'package:flutter/material.dart';

class StringUtils {
  static bool isEmpty(String? s) {
    return s == null || s.trim().isEmpty;
  }

  static String yearFormat(Object date, Object era) {
    return '$date $era';
  }

  static bool isNotEmpty(String? s) => !isEmpty(s);

  static bool isLink(String str) => str.contains(RegExp(
      r'^(https?:\/\/)?([\w\d_-]+)\.([\w\d_\.-]+)\/?\??([^#\n\r]*)?#?([^\n\r]*)'));

  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  static String printMap(Map<String, dynamic>? map) {
    String str = '';
    map?.forEach((key, value) => str += '$key: ${value.toString}, ');
    return str;
  }

  static Size measure(String text, TextStyle style,
      {int maxLines = 1, TextDirection direction = TextDirection.ltr}) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: direction)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static double measureLongest(List<String> items, TextStyle style,
      [maxItems]) {
    double l = 0;
    if (maxItems != null && maxItems < items.length) {
      items.length = maxItems;
    }
    for (var item in items) {
      double m = StringUtils.measure(item, style).width;
      if (m > l) l = m;
    }
    return l;
  }

  /// Gracefully handles null values, and skips the suffix when null
  static String safeGet(String value, [String? suffix]) {
    return value + (value.isNotEmpty ? suffix ?? '' : '');
  }

  String formatYr(int yr) {
    if (yr == 0) yr = 1;
    return yearFormat(yr.abs().toString(), getYrSuffix(yr));
  }

  static String getYrSuffix(int yr) => yr < 0 ? 'BCE' : 'CE';

  static String getEra(int yr) {
    if (yr <= -600) return 'Prehistory';
    if (yr <= 476) return 'Classical Era';
    if (yr <= 1450) return 'Early Modern Era';
    return 'Modern Era';
  }

  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  static String supplant(String value, Map<String, String> supplants) {
    return value.replaceAllMapped(RegExp(r'\{\w+\}'), (match) {
      final placeholder = match.group(0) ?? '';
      if (supplants.containsKey(placeholder)) {
        return supplants[placeholder]!;
      }
      return placeholder;
    });
  }
}
