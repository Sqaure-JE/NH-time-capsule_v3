import '../utils/constants.dart';

class PointSystem {
  // 일기 작성 포인트 계산
  static int calculateDiaryPoints({
    required String diaryType,
    bool hasImage = false,
    bool hasMilestone = false,
    bool hasAmount = false,
  }) {
    int basePoints = 0;

    switch (diaryType) {
      case 'general':
        basePoints = AppConstants.pointSystem['general_diary_base']!;
        if (hasImage) {
          basePoints += AppConstants.pointSystem['general_diary_image']!;
        }
        break;
      case 'personal_capsule':
        basePoints = AppConstants.pointSystem['personal_capsule_diary_base']!;
        if (hasImage) {
          basePoints +=
              AppConstants.pointSystem['personal_capsule_diary_image']!;
        }
        if (hasMilestone) {
          basePoints +=
              AppConstants.pointSystem['personal_capsule_diary_milestone']!;
        }
        break;
      case 'group_capsule':
        basePoints = AppConstants.pointSystem['group_capsule_diary_base']!;
        if (hasImage) {
          basePoints += AppConstants.pointSystem['group_capsule_diary_image']!;
        }
        break;
    }

    return basePoints;
  }

  // 타임캡슐 생성 포인트
  static int getCapsuleCreationPoints() {
    return AppConstants.pointSystem['capsule_creation']!;
  }

  // 첫 기록 포인트
  static int getFirstRecordPoints() {
    return AppConstants.pointSystem['first_record']!;
  }

  // 목표 달성 보너스 포인트
  static int getAchievementBonusPoints() {
    return AppConstants.pointSystem['achievement_bonus']!;
  }

  // 연속 기록 보너스 포인트
  static int getConsecutiveBonusPoints(int consecutiveDays) {
    if (consecutiveDays >= 7) {
      return 200; // 7일 연속시 200P 보너스
    } else if (consecutiveDays >= 3) {
      return 50; // 3일 연속시 50P 보너스
    }
    return 0;
  }

  // 이정표별 보너스 포인트
  static int getMilestoneBonusPoints(String milestoneId) {
    const milestoneBonuses = {
      'saving': 10,
      'sacrifice': 15,
      'progress': 20,
      'challenge': 25,
    };
    return milestoneBonuses[milestoneId] ?? 0;
  }

  // 포인트 등급 계산
  static String calculatePointGrade(int totalPoints) {
    if (totalPoints >= 10000) return '다이아몬드';
    if (totalPoints >= 5000) return '골드';
    if (totalPoints >= 2000) return '실버';
    if (totalPoints >= 500) return '브론즈';
    return '새내기';
  }

  // 다음 등급까지 필요한 포인트
  static int getPointsToNextGrade(int currentPoints) {
    if (currentPoints >= 10000) return 0;
    if (currentPoints >= 5000) return 10000 - currentPoints;
    if (currentPoints >= 2000) return 5000 - currentPoints;
    if (currentPoints >= 500) return 2000 - currentPoints;
    return 500 - currentPoints;
  }

  // 포인트 히스토리 항목
  static Map<String, String> getPointHistoryDescription(
    String action,
    int points,
  ) {
    const descriptions = {
      'diary_general': '일반 일기 작성',
      'diary_personal_capsule': '개인형 타임캡슐 일기',
      'diary_group_capsule': '모임형 타임캡슐 일기',
      'capsule_creation': '타임캡슐 생성',
      'first_record': '첫 기록 작성',
      'achievement_bonus': '목표 달성 보너스',
      'consecutive_bonus': '연속 기록 보너스',
      'milestone_bonus': '이정표 달성',
      'image_bonus': '사진 첨부 보너스',
    };

    return {'action': descriptions[action] ?? action, 'points': '+${points}P'};
  }

  // 포인트 적립 가능 여부 확인
  static bool canEarnPoints(String action, Map<String, dynamic> context) {
    switch (action) {
      case 'diary_general':
        return true; // 항상 가능
      case 'diary_personal_capsule':
        return context['capsuleId'] != null;
      case 'diary_group_capsule':
        return context['capsuleId'] != null && context['memberIds'] != null;
      case 'capsule_creation':
        return context['isNewCapsule'] == true;
      case 'first_record':
        return context['isFirstRecord'] == true;
      case 'achievement_bonus':
        return context['isAchieved'] == true;
      case 'consecutive_bonus':
        return context['consecutiveDays'] >= 7;
      case 'milestone_bonus':
        return context['milestoneId'] != null;
      case 'image_bonus':
        return context['hasImage'] == true;
      default:
        return false;
    }
  }
}
