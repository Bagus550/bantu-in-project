import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime toWIBDateTime(String? rawDateTime) {
    if (rawDateTime == null || rawDateTime.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    String normalized = rawDateTime.trim();

    final bool hasZoneOffset = RegExp(r'([zZ]|[+-]\d{2}:\d{2})$').hasMatch(normalized);
    if (!hasZoneOffset) {
      normalized = '$normalized Z';
    }

    try {
      return DateTime.parse(normalized).toLocal();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  static DateTime toLocalDateTime(String? rawDateTime) {
    return toWIBDateTime(rawDateTime);
  }

  static String formatToWIB(String? rawDateTime, {String pattern = "d MMMM yyyy, 'pukul' HH:mm", String locale = 'id'}) {
    final dateTime = toLocalDateTime(rawDateTime);

    if (dateTime.year == 1970 && dateTime.month == 1 && dateTime.day == 1) {
      return '-';
    }

    return DateFormat(pattern, locale).format(dateTime);
  }

  static String formatDateOnly(String? rawDateTime, {String locale = 'id'}) {
    final dateTime = toLocalDateTime(rawDateTime);

    if (dateTime.year == 1970 && dateTime.month == 1 && dateTime.day == 1) {
      return 'Tanggal tidak valid';
    }

    return DateFormat('d MMMM yyyy', locale).format(dateTime);
  }
}
