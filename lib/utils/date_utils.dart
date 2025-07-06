import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MM.dd HH:mm').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('yyyy년 M월').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('M.dd').format(date);
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return '오늘';
    } else if (difference == 1) {
      return '어제';
    } else if (difference < 7) {
      return '$difference일 전';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks주 전';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months개월 전';
    } else {
      final years = (difference / 365).floor();
      return '$years년 전';
    }
  }

  static int getDaysLeft(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  static String formatDays(int days) {
    if (days == 0) {
      return 'D-DAY';
    } else if (days > 0) {
      return 'D-$days';
    } else {
      return 'D+${days.abs()}';
    }
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static List<DateTime> getDaysInMonth(DateTime date) {
    final start = getStartOfMonth(date);
    final end = getEndOfMonth(date);
    final days = <DateTime>[];

    for (int i = 0; i < end.day; i++) {
      days.add(start.add(Duration(days: i)));
    }

    return days;
  }

  static String getKoreanDayOfWeek(DateTime date) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }

  static String getKoreanMonth(DateTime date) {
    return '${date.month}월';
  }

  static String getKoreanYear(DateTime date) {
    return '${date.year}년';
  }

  static DateTime addMonths(DateTime date, int months) {
    return DateTime(date.year, date.month + months, date.day);
  }

  static DateTime subtractMonths(DateTime date, int months) {
    return DateTime(date.year, date.month - months, date.day);
  }
}
