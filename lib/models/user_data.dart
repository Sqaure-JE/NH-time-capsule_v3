class Coupon {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji or asset
  final bool isUsed; // true: 받은 쿠폰, false: 앞으로 받을 쿠폰

  Coupon({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUsed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUsed': isUsed,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      isUsed: map['isUsed'] ?? false,
    );
  }
}

class UserData {
  final String id;
  final String name;
  final int totalAssets;
  final int totalPoints;
  final DateTime lastLoginDate;
  final List<String> favoriteCategories;
  final Map<String, int> monthlyGoals;
  final int consecutiveLoginDays;
  final DateTime? lastDiaryDate;
  final int totalDiaryCount;
  final int totalCapsuleCount;
  final int completedCapsuleCount;
  final List<Coupon> coupons;

  UserData({
    required this.id,
    required this.name,
    this.totalAssets = 0,
    this.totalPoints = 0,
    required this.lastLoginDate,
    this.favoriteCategories = const [],
    this.monthlyGoals = const {},
    this.consecutiveLoginDays = 0,
    this.lastDiaryDate,
    this.totalDiaryCount = 0,
    this.totalCapsuleCount = 0,
    this.completedCapsuleCount = 0,
    this.coupons = const [],
  });

  // 오늘 일기 작성 여부
  bool get hasWrittenToday {
    if (lastDiaryDate == null) return false;
    final now = DateTime.now();
    return lastDiaryDate!.year == now.year &&
        lastDiaryDate!.month == now.month &&
        lastDiaryDate!.day == now.day;
  }

  // 연속 기록 가능 여부 (7일 연속시 보너스)
  bool get canGetConsecutiveBonus => consecutiveLoginDays >= 7;

  // 진행중인 캡슐 수
  int get activeCapsuleCount => totalCapsuleCount - completedCapsuleCount;

  // 완료율
  double get completionRate {
    if (totalCapsuleCount == 0) return 0.0;
    return completedCapsuleCount / totalCapsuleCount;
  }

  // 포인트 등급
  String get pointGrade {
    if (totalPoints >= 10000) return '다이아몬드';
    if (totalPoints >= 5000) return '골드';
    if (totalPoints >= 2000) return '실버';
    if (totalPoints >= 500) return '브론즈';
    return '새내기';
  }

  // 다음 등급까지 필요한 포인트
  int get pointsToNextGrade {
    if (totalPoints >= 10000) return 0;
    if (totalPoints >= 5000) return 10000 - totalPoints;
    if (totalPoints >= 2000) return 5000 - totalPoints;
    if (totalPoints >= 500) return 2000 - totalPoints;
    return 500 - totalPoints;
  }

  // 자산 변화 계산 (임시로 0 반환)
  int get todayChange => 0;

  // Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalAssets': totalAssets,
      'totalPoints': totalPoints,
      'lastLoginDate': lastLoginDate.millisecondsSinceEpoch,
      'favoriteCategories': favoriteCategories,
      'monthlyGoals': monthlyGoals,
      'consecutiveLoginDays': consecutiveLoginDays,
      'lastDiaryDate': lastDiaryDate?.millisecondsSinceEpoch,
      'totalDiaryCount': totalDiaryCount,
      'totalCapsuleCount': totalCapsuleCount,
      'completedCapsuleCount': completedCapsuleCount,
      'coupons': coupons.map((e) => e.toMap()).toList(),
    };
  }

  // Map에서 생성
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      name: map['name'],
      totalAssets: map['totalAssets'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      lastLoginDate: DateTime.fromMillisecondsSinceEpoch(map['lastLoginDate']),
      favoriteCategories: List<String>.from(map['favoriteCategories'] ?? []),
      monthlyGoals: Map<String, int>.from(map['monthlyGoals'] ?? {}),
      consecutiveLoginDays: map['consecutiveLoginDays'] ?? 0,
      lastDiaryDate: map['lastDiaryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastDiaryDate'])
          : null,
      totalDiaryCount: map['totalDiaryCount'] ?? 0,
      totalCapsuleCount: map['totalCapsuleCount'] ?? 0,
      completedCapsuleCount: map['completedCapsuleCount'] ?? 0,
      coupons: List<Coupon>.from(map['coupons'].map((e) => Coupon.fromMap(e))),
    );
  }

  // 복사본 생성 (수정용)
  UserData copyWith({
    String? id,
    String? name,
    int? totalAssets,
    int? totalPoints,
    DateTime? lastLoginDate,
    List<String>? favoriteCategories,
    Map<String, int>? monthlyGoals,
    int? consecutiveLoginDays,
    DateTime? lastDiaryDate,
    int? totalDiaryCount,
    int? totalCapsuleCount,
    int? completedCapsuleCount,
    List<Coupon>? coupons,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAssets: totalAssets ?? this.totalAssets,
      totalPoints: totalPoints ?? this.totalPoints,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      monthlyGoals: monthlyGoals ?? this.monthlyGoals,
      consecutiveLoginDays: consecutiveLoginDays ?? this.consecutiveLoginDays,
      lastDiaryDate: lastDiaryDate ?? this.lastDiaryDate,
      totalDiaryCount: totalDiaryCount ?? this.totalDiaryCount,
      totalCapsuleCount: totalCapsuleCount ?? this.totalCapsuleCount,
      completedCapsuleCount:
          completedCapsuleCount ?? this.completedCapsuleCount,
      coupons: coupons ?? this.coupons,
    );
  }

  // 포인트 추가
  UserData addPoints(int points) {
    return copyWith(totalPoints: totalPoints + points);
  }

  // 자산 업데이트
  UserData updateAssets(int assets) {
    return copyWith(totalAssets: assets);
  }

  // 일기 작성 기록
  UserData recordDiary() {
    final now = DateTime.now();
    final newConsecutiveDays =
        hasWrittenToday ? consecutiveLoginDays : consecutiveLoginDays + 1;

    return copyWith(
      lastDiaryDate: now,
      totalDiaryCount: totalDiaryCount + 1,
      consecutiveLoginDays: newConsecutiveDays,
    );
  }

  // 캡슐 완료
  UserData completeCapsule() {
    return copyWith(completedCapsuleCount: completedCapsuleCount + 1);
  }

  // 새 캡슐 생성
  UserData createCapsule() {
    return copyWith(totalCapsuleCount: totalCapsuleCount + 1);
  }

  // 기본 사용자 데이터 생성
  factory UserData.defaultUser() {
    return UserData(
      id: 'user_001',
      name: '이정은',
      totalAssets: 5904715,
      totalPoints: 2450,
      lastLoginDate: DateTime.now(),
      favoriteCategories: ['travel', 'financial'],
      monthlyGoals: {'saving': 500000, 'diary': 30},
      consecutiveLoginDays: 5,
      lastDiaryDate: DateTime.now().subtract(const Duration(days: 1)),
      totalDiaryCount: 45,
      totalCapsuleCount: 4,
      completedCapsuleCount: 1,
      coupons: [
        Coupon(
          id: 'coupon1',
          title: '음식할인쿠폰',
          description: '전국 음식점 20% 할인',
          icon: '🍔',
          isUsed: true,
        ),
        Coupon(
          id: 'coupon2',
          title: '여행보험 가입쿠폰',
          description: '여행자 보험 무료 가입',
          icon: '🛡️',
          isUsed: true,
        ),
        Coupon(
          id: 'coupon3',
          title: '리디북스 1개월 이용권',
          description: '전자책 무제한 1개월',
          icon: '📚',
          isUsed: false,
        ),
        Coupon(
          id: 'coupon4',
          title: '운동화마트 할인쿠폰',
          description: '운동화 10% 할인',
          icon: '👟',
          isUsed: false,
        ),
      ],
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, points: $totalPoints, assets: $totalAssets)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
