class AppConstants {
  // 앱 정보
  static const String appName = 'NH 금융 타임캡슐';
  static const String appVersion = '1.0.0';

  // 감정 캐릭터 정보
  static const Map<String, Map<String, dynamic>> emotionCharacters = {
    'joy': {
      'id': 'joy',
      'emoji': '😊',
      'name': '기쁨이',
      'color': 0xFFFFD700,
      'description': '목표에 한 걸음 더 가까워졌어요!',
    },
    'sadness': {
      'id': 'sadness',
      'emoji': '😢',
      'name': '슬픔이',
      'color': 0xFF4A90E2,
      'description': '힘든 순간도 성장의 기회예요.',
    },
    'anger': {
      'id': 'anger',
      'emoji': '😡',
      'name': '분노',
      'color': 0xFFFF4444,
      'description': '불합리한 지출에 단호하게 대처해요.',
    },
    'fear': {
      'id': 'fear',
      'emoji': '😰',
      'name': '불안이',
      'color': 0xFF9B59B6,
      'description': '신중한 계획으로 안전하게 진행해요.',
    },
    'disgust': {
      'id': 'disgust',
      'emoji': '🤢',
      'name': '까칠이',
      'color': 0xFF2ECC71,
      'description': '완벽한 목표 달성을 위해 꼼꼼히!',
    },
  };

  // 타임캡슐 카테고리 (개인형/모임형 분리)
  static const Map<String, Map<String, dynamic>> personalCapsuleCategories = {
    'travel': {
      'id': 'travel',
      'icon': '🏖️',
      'name': '여행',
      'color': 0xFF4A90E2,
    },
    'financial': {
      'id': 'financial',
      'icon': '💰',
      'name': '저축',
      'color': 0xFF00A651,
    },
    'home': {'id': 'home', 'icon': '🏠', 'name': '내집마련', 'color': 0xFF9B59B6},
    'lifestyle': {
      'id': 'lifestyle',
      'icon': '🎯',
      'name': '취미생활',
      'color': 0xFFFF9800,
    },
    'relationship': {
      'id': 'relationship',
      'icon': '💕',
      'name': '특별한날',
      'color': 0xFFE91E63,
    },
    'other': {'id': 'other', 'icon': '✨', 'name': '기타', 'color': 0xFF6B7280},
  };

  static const Map<String, Map<String, dynamic>> groupCapsuleCategories = {
    'travel': {
      'id': 'travel',
      'icon': '🏖️',
      'name': '여행',
      'color': 0xFF4A90E2,
    },
    'lifestyle': {
      'id': 'lifestyle',
      'icon': '🎯',
      'name': '취미생활',
      'color': 0xFFFF9800,
    },
    'relationship': {
      'id': 'relationship',
      'icon': '💕',
      'name': '특별한날',
      'color': 0xFFE91E63,
    },
    'groupbuy': {
      'id': 'groupbuy',
      'icon': '🛒',
      'name': '공동구매',
      'color': 0xFF00A651,
    },
    'anniversary': {
      'id': 'anniversary',
      'icon': '🎉',
      'name': '기념일',
      'color': 0xFF9B59B6,
    },
    'other': {'id': 'other', 'icon': '✨', 'name': '기타', 'color': 0xFF6B7280},
  };

  // 이정표 옵션
  static const Map<String, Map<String, dynamic>> milestones = {
    'saving': {'id': 'saving', 'emoji': '💰', 'text': '저축했어요', 'bonus': 10},
    'sacrifice': {
      'id': 'sacrifice',
      'emoji': '🚫',
      'text': '참았어요',
      'bonus': 15,
    },
    'progress': {
      'id': 'progress',
      'emoji': '📈',
      'text': '목표에 가까워졌어요',
      'bonus': 20,
    },
    'challenge': {
      'id': 'challenge',
      'emoji': '💪',
      'text': '어려움을 극복했어요',
      'bonus': 25,
    },
  };

  // 포인트 시스템
  static const Map<String, int> pointSystem = {
    'general_diary_base': 30,
    'general_diary_image': 15,
    'personal_capsule_diary_base': 50,
    'personal_capsule_diary_image': 20,
    'personal_capsule_diary_milestone': 25,
    'group_capsule_diary_base': 25,
    'group_capsule_diary_image': 15,
    'capsule_creation': 100,
    'first_record': 50,
    'achievement_bonus': 200,
  };

  // 기간 옵션
  static const List<Map<String, dynamic>> periodOptions = [
    {'id': '3', 'label': '3개월', 'desc': '단기 목표'},
    {'id': '6', 'label': '6개월', 'desc': '추천'},
    {'id': '12', 'label': '1년', 'desc': '장기 목표'},
  ];

  // UI 상수
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // 애니메이션 지속시간
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
