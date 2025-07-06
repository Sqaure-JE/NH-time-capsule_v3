import 'package:flutter/material.dart';

class NHColors {
  // NH 브랜드 색상
  static const primary = Color(0xFF00A651);
  static const blue = Color(0xFF0066CC);
  static const background = Color(0xFFF8F9FA);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // 감정 캐릭터 색상
  static const joy = Color(0xFFFFD700);
  static const sadness = Color(0xFF4A90E2);
  static const anger = Color(0xFFFF4444);
  static const fear = Color(0xFF9B59B6);
  static const disgust = Color(0xFF2ECC71);

  // 그레이 스케일
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);

  // 상태 색상
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // 그라데이션 색상
  static const gradientGreen = LinearGradient(
    colors: [Color(0xFF00A651), Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBlue = LinearGradient(
    colors: [Color(0xFF0066CC), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientPurple = LinearGradient(
    colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientOrange = LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const orange = Color(0xFFFF9800);
  static const purple = Color(0xFF9B59B6);

  static const gradientGreenBlue = LinearGradient(
    colors: [Color(0xFF00A651), Color(0xFF0066CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color green = Color(0xFF22C55E);
}
