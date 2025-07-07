import 'package:flutter/material.dart';
import '../utils/colors.dart';

enum CapsuleType { personal, group }

enum CapsuleStatus { active, completed, expired }

class TimeCapsule {
  final String id;
  final String title;
  final String category;
  final CapsuleType type;
  final int targetAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String? firstMessage;
  final String? firstImagePath;
  final List<String> memberIds; // 모임형인 경우
  final Map<String, int> memberContributions; // 모임형인 경우
  int currentAmount;
  int recordCount;
  int photoCount;
  CapsuleStatus status;
  final DateTime createdAt;
  DateTime? completedAt;

  TimeCapsule({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.targetAmount,
    required this.startDate,
    required this.endDate,
    this.firstMessage,
    this.firstImagePath,
    this.memberIds = const [],
    this.memberContributions = const {},
    this.currentAmount = 0,
    this.recordCount = 0,
    this.photoCount = 0,
    this.status = CapsuleStatus.active,
    required this.createdAt,
    this.completedAt,
  });

  // 진행률 계산 (0.0 ~ 1.0)
  double get progress => currentAmount / targetAmount;

  // 진행률 퍼센트
  int get progressPercentage => (progress * 100).round();

  // 남은 금액
  int get remainingAmount => targetAmount - currentAmount;

  // 남은 일수
  int get daysLeft {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  // 목표 달성 여부
  bool get isAchieved => currentAmount >= targetAmount;

  // 열기 가능 여부
  bool get isOpenable =>
      isAchieved &&
      (status == CapsuleStatus.active || status == CapsuleStatus.completed);

  // 만료 여부
  bool get isExpired => DateTime.now().isAfter(endDate);

  // 모임형 여부
  bool get isGroup => type == CapsuleType.group;

  // 개인형 여부
  bool get isPersonal => type == CapsuleType.personal;

  // 기간 (개월)
  int get durationInMonths {
    return ((endDate.difference(startDate).inDays) / 30).round();
  }

  // 카테고리 아이콘
  String get categoryIcon {
    const categoryIcons = {
      'travel': '🏖️',
      'financial': '💰',
      'home': '🏠',
      'lifestyle': '🎯',
      'relationship': '💕',
      'other': '✨',
    };
    return categoryIcons[category] ?? '✨';
  }

  // 상태 텍스트
  String get statusText {
    switch (status) {
      case CapsuleStatus.active:
        return isAchieved ? '완료' : '진행중';
      case CapsuleStatus.completed:
        return '완료';
      case CapsuleStatus.expired:
        return '만료';
    }
  }

  // 금액 추가
  void addAmount(int amount) {
    currentAmount += amount;
    if (isAchieved && status == CapsuleStatus.active) {
      status = CapsuleStatus.completed;
      completedAt = DateTime.now();
    }
  }

  // 기록 수 증가
  void incrementRecordCount() {
    recordCount++;
  }

  // 사진 수 증가
  void incrementPhotoCount() {
    photoCount++;
  }

  // 멤버 기여도 추가 (모임형)
  void addMemberContribution(String memberId, int amount) {
    if (isGroup) {
      final currentContribution = memberContributions[memberId] ?? 0;
      memberContributions[memberId] = currentContribution + amount;
      addAmount(amount);
    }
  }

  // 멤버별 기여도 순위
  List<MapEntry<String, int>> get memberRanking {
    final sortedEntries = memberContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries;
  }

  // Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'type': type.index,
      'targetAmount': targetAmount,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'firstMessage': firstMessage,
      'firstImagePath': firstImagePath,
      'memberIds': memberIds,
      'memberContributions': memberContributions,
      'currentAmount': currentAmount,
      'recordCount': recordCount,
      'photoCount': photoCount,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
    };
  }

  // Map에서 생성
  factory TimeCapsule.fromMap(Map<String, dynamic> map) {
    return TimeCapsule(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      type: CapsuleType.values[map['type']],
      targetAmount: map['targetAmount'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      firstMessage: map['firstMessage'],
      firstImagePath: map['firstImagePath'],
      memberIds: List<String>.from(map['memberIds'] ?? []),
      memberContributions: Map<String, int>.from(
        map['memberContributions'] ?? {},
      ),
      currentAmount: map['currentAmount'] ?? 0,
      recordCount: map['recordCount'] ?? 0,
      photoCount: map['photoCount'] ?? 0,
      status: CapsuleStatus.values[map['status'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'TimeCapsule(id: $id, title: $title, progress: $progressPercentage%, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeCapsule && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  TimeCapsule copyWith({
    String? id,
    String? title,
    String? category,
    CapsuleType? type,
    int? targetAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? firstMessage,
    String? firstImagePath,
    List<String>? memberIds,
    Map<String, int>? memberContributions,
    int? currentAmount,
    int? recordCount,
    int? photoCount,
    CapsuleStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TimeCapsule(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      firstMessage: firstMessage ?? this.firstMessage,
      firstImagePath: firstImagePath ?? this.firstImagePath,
      memberIds: memberIds ?? this.memberIds,
      memberContributions: memberContributions ?? this.memberContributions,
      currentAmount: currentAmount ?? this.currentAmount,
      recordCount: recordCount ?? this.recordCount,
      photoCount: photoCount ?? this.photoCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // --- 모임형 상세 정보 샘플용 getter들 ---
  int get memberCount => memberIds.length;
  double get achievementRate =>
      (currentAmount / targetAmount * 100).clamp(0, 999);
  int get finalAmount => currentAmount;
  List<MemberInfo> get members => sampleMembers;
  List<ExpenseInfo> get expenseBreakdown => sampleExpenses;
  List<HighlightInfo> get highlights => sampleHighlights;
  List<AchievementInfo> get achievements => sampleAchievements;

  // 샘플 멤버 정보 (실제 데이터 연동 시 교체)
  List<MemberInfo> get sampleMembers => [
    MemberInfo('김올리', 500000, 25.0, '👤', true),
    MemberInfo('박수빈', 500000, 25.0, '👩', false),
    MemberInfo('이정은', 500000, 25.0, '👨', false),
    MemberInfo('최민수', 500000, 25.0, '👩‍🦱', false),
  ];
  List<ExpenseInfo> get sampleExpenses => [
    ExpenseInfo('KTX', 480000, 24.0),
    ExpenseInfo('숙박비', 600000, 30.0),
    ExpenseInfo('식비', 640000, 32.0),
    ExpenseInfo('관광', 280000, 14.0),
  ];
  List<HighlightInfo> get sampleHighlights => [
    HighlightInfo('2025.05.01', '해운대 바다', '120,000원', '전원'),
    HighlightInfo('2025.05.02', '광안리 야경', '80,000원', '전원'),
    HighlightInfo('2025.05.03', '국제시장 투어', '60,000원', '전원'),
  ];
  List<AchievementInfo> get sampleAchievements => [
    AchievementInfo('👥', '팀워크', '4명이 함께'),
    AchievementInfo(
      '💰',
      '효율적 지출',
      '${achievementRate.toStringAsFixed(1)}% 달성',
    ),
    AchievementInfo('📸', '추억 수집', '50장 사진'),
    AchievementInfo('⚖️', '정산 완료', '모든 정산 완료'),
  ];

  // --- 개인형 상세 정보 샘플용 getter들 ---
  String get period =>
      '${((endDate.difference(startDate).inDays) / 30).round()}개월';
  MainEmotionInfo get mainEmotion =>
      MainEmotionInfo('😊', '기쁨이', 9, 68, '+2레벨');
  List<EmotionStatInfo> get emotionStats => [
    EmotionStatInfo('😊', '기쁨이', 68, NHColors.joy),
    EmotionStatInfo('😰', '불안이', 15, NHColors.fear),
    EmotionStatInfo('😢', '슬픔이', 10, NHColors.sadness),
    EmotionStatInfo('😡', '분노', 4, NHColors.anger),
    EmotionStatInfo('🤢', '까칠이', 3, NHColors.disgust),
  ];
  List<PersonalHighlightInfo> get personalHighlights => [
    PersonalHighlightInfo(
      '2025.02.14',
      '발렌타인데이 카페 절약',
      '😊',
      '+50,000원',
      '제주도 카페 투어를 위해 커피값 절약',
    ),
    PersonalHighlightInfo(
      '2025.04.15',
      '부업 수입으로 여행자금 추가',
      '😊',
      '+200,000원',
      '프리랜서 수입으로 제주도 숙박비 마련',
    ),
    PersonalHighlightInfo(
      '2025.06.01',
      '목표 달성! 제주도 항공권 예약',
      '😊',
      '+100,000원',
      '제주도 여행 목표 금액 달성 완료',
    ),
  ];
  List<PersonalAchievementInfo> get personalAchievements => [
    PersonalAchievementInfo('🏆', '제주도 여행 목표 달성', '112% 달성'),
    PersonalAchievementInfo('📅', '꾸준한 저축 기록', '28일 기록'),
    PersonalAchievementInfo('📸', '제주도 사진 수집가', '15장 사진'),
    PersonalAchievementInfo('😊', '긍정적인 여행 준비', '기쁨이 68%'),
  ];
}

extension TimeCapsuleStatusExt on TimeCapsule {
  bool get isActive => status == CapsuleStatus.active;
  bool get isDday => endDate.difference(DateTime.now()).inDays == 0;
}

// --- 관련 데이터 클래스 ---
class MemberInfo {
  final String name;
  final int contribution;
  final double percentage;
  final String avatar;
  final bool isMe;
  MemberInfo(
    this.name,
    this.contribution,
    this.percentage,
    this.avatar,
    this.isMe,
  );
}

class ExpenseInfo {
  final String category;
  final int amount;
  final double percentage;
  ExpenseInfo(this.category, this.amount, this.percentage);
}

class HighlightInfo {
  final String date;
  final String title;
  final String amount;
  final String members;
  HighlightInfo(this.date, this.title, this.amount, this.members);
}

class AchievementInfo {
  final String icon;
  final String title;
  final String desc;
  AchievementInfo(this.icon, this.title, this.desc);
}

class MainEmotionInfo {
  final String emoji;
  final String name;
  final int level;
  final int percentage;
  final String growth;
  MainEmotionInfo(
    this.emoji,
    this.name,
    this.level,
    this.percentage,
    this.growth,
  );
}

class EmotionStatInfo {
  final String emoji;
  final String name;
  final int percentage;
  final Color color;
  EmotionStatInfo(this.emoji, this.name, this.percentage, this.color);
}

class PersonalHighlightInfo {
  final String date;
  final String title;
  final String emotion;
  final String amount;
  final String description;
  PersonalHighlightInfo(
    this.date,
    this.title,
    this.emotion,
    this.amount,
    this.description,
  );
}

class PersonalAchievementInfo {
  final String icon;
  final String title;
  final String desc;
  PersonalAchievementInfo(this.icon, this.title, this.desc);
}
