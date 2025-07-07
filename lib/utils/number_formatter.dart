import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatCurrency(int amount) {
    return NumberFormat('#,###').format(amount);
  }

  static String formatCurrencyWithUnit(int amount) {
    return '${formatCurrency(amount)}원';
  }

  static String formatCompactCurrency(int amount) {
    if (amount >= 100000000) {
      return '${(amount / 100000000).toStringAsFixed(1)}억원';
    } else if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(0)}만원';
    } else {
      return formatCurrencyWithUnit(amount);
    }
  }

  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  static String formatPoints(int points) {
    return '${formatCurrency(points)}P';
  }

  static String formatChange(int change) {
    if (change > 0) {
      return '+${formatCurrency(change)}원';
    } else if (change < 0) {
      return '-${formatCurrency(change.abs())}원';
    } else {
      return '0원';
    }
  }

  static String formatChangePercentage(double changePercentage) {
    if (changePercentage > 0) {
      return '+${changePercentage.toStringAsFixed(2)}%';
    } else if (changePercentage < 0) {
      return '${changePercentage.toStringAsFixed(2)}%';
    } else {
      return '0.00%';
    }
  }

  static int parseCurrency(String text) {
    // 쉼표와 "원" 제거 후 숫자만 추출
    final cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleanText) ?? 0;
  }

  static String formatProgress(double progress) {
    return '${(progress * 100).toStringAsFixed(1)}%';
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

  static String formatLevel(int level) {
    return 'Lv.$level';
  }

  static String formatExperience(int exp, int maxExp) {
    return '$exp/$maxExp';
  }

  static String formatCount(int count) {
    return NumberFormat('#,###').format(count);
  }

  static String formatDecimal(double value, {int decimalPlaces = 2}) {
    return value.toStringAsFixed(decimalPlaces);
  }
}
