import 'package:flutter/material.dart';
import '../../models/user_data.dart';
import '../../models/time_capsule.dart';
import '../../models/emotion_character.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/date_utils.dart' as NHDateUtils;
import '../../utils/number_formatter.dart';
import '../../widgets/nh_header_widget.dart';
import '../../widgets/point_display_widget.dart';
import '../../widgets/capsule_card_widget.dart';
import '../../widgets/progress_bar_widget.dart';
import '../capsule/capsule_create_screen.dart';
import '../capsule/capsule_content_screen.dart';
import '../capsule/personal_capsule_open_screen.dart';
import '../capsule/group_capsule_open_screen.dart';
import '../diary/personal_capsule_diary_screen.dart';
import '../diary/group_capsule_diary_screen.dart';
import '../diary/general_diary_screen.dart';
import '../analysis/monthly_character_analysis_screen.dart';
import '../analysis/capsule_character_analysis_screen.dart';
import 'dart:async';
import 'dart:math' as math;

class NHHomeScreen extends StatefulWidget {
  const NHHomeScreen({super.key});

  @override
  State<NHHomeScreen> createState() => _NHHomeScreenState();
}

class _NHHomeScreenState extends State<NHHomeScreen>
    with SingleTickerProviderStateMixin {
  late UserData userData;
  late List<TimeCapsule> capsules;
  late List<EmotionCharacter> characters;
  int _selectedTabIndex = 2; // 0:자산, 1:소비, 2:타임캡슐, 3:즐겨찾기, 4:전체
  late AnimationController _notificationController;
  late Animation<Offset> _slideAnimation;
  Timer? _notificationTimer;
  Timer? _autoHideTimer; // 자동 숨김 타이머
  bool _hasShownNotification = false;
  bool _notificationPermanentlyDismissed = false; // 푸시 알림 영구 해제 플래그

  @override
  void initState() {
    super.initState();
    _initializeData();

    // 푸시 알림 애니메이션 컨트롤러 초기화
    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _notificationController,
      curve: Curves.elasticOut,
    ));

    // 5초 후 푸시 알림 표시 (더 빨리 표시)
    _startNotificationTimer();
  }

  @override
  void dispose() {
    _notificationController.dispose();
    _notificationTimer?.cancel();
    _autoHideTimer?.cancel();
    super.dispose();
  }

  void _startNotificationTimer() {
    _notificationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted &&
          !_hasShownNotification &&
          !_notificationPermanentlyDismissed) {
        _showDailyReminderNotification();
        _hasShownNotification = true;
      }
    });
  }

  void _showDailyReminderNotification() {
    _notificationController.forward();

    // 8초 후 자동으로 사라지게 (더 오래 표시)
    _autoHideTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        _hideNotification();
      }
    });
  }

  void _hideNotification() {
    _autoHideTimer?.cancel(); // 자동 숨김 타이머 취소
    _notificationController.reverse();
    _notificationPermanentlyDismissed = true; // 영구 해제
  }

  void _initializeData() {
    // 임시 데이터 초기화
    userData = UserData.defaultUser();
    characters = EmotionCharacter.defaultCharacters;

    // 타임캡슐 샘플 데이터
    capsules = [
      TimeCapsule(
        id: 'sample_1',
        title: '🏖️ 제주도 여행 자금',
        category: 'travel',
        type: CapsuleType.personal,
        targetAmount: 1500000,
        currentAmount: 1680000, // 100% 초과
        startDate: DateTime.now().subtract(const Duration(days: 90)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        memberIds: [],
      ),
      TimeCapsule(
        id: 'sample_2',
        title: '🚄 친구들과 부산여행',
        category: 'travel',
        type: CapsuleType.group,
        targetAmount: 2000000,
        currentAmount: 2000000, // 100% 완료
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        memberIds: ['friend1', 'friend2'],
      ),
      TimeCapsule(
        id: 'sample_3',
        title: '다낭 여행',
        category: 'travel',
        type: CapsuleType.personal,
        targetAmount: 2000000,
        currentAmount: 1800000, // 90% 진행
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 150)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        memberIds: [],
      ),
      TimeCapsule(
        id: 'sample_4',
        title: '내집마련',
        category: 'home',
        type: CapsuleType.personal,
        targetAmount: 50000000,
        currentAmount: 15000000, // 30% 진행
        startDate: DateTime.now().subtract(const Duration(days: 100)),
        endDate: DateTime.now().add(const Duration(days: 300)),
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        memberIds: [],
      ),
      TimeCapsule(
        id: 'sample_5',
        title: '💕 결혼기념일',
        category: 'relationship',
        type: CapsuleType.personal,
        targetAmount: 3000000,
        currentAmount: 2500000, // 83% 진행
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        memberIds: [],
      ),
      TimeCapsule(
        id: 'capsule_running',
        title: '🏃‍♂️ 러닝 습관',
        category: 'running',
        type: CapsuleType.personal,
        targetAmount: 0, // 목표금액 없음 (습관형)
        currentAmount: 70, // 70일 달성
        startDate: DateTime.now().subtract(const Duration(days: 70)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 70)),
        memberIds: [],
      ),
      TimeCapsule(
        id: 'capsule_reading',
        title: '📖 독서 습관',
        category: 'reading',
        type: CapsuleType.personal,
        targetAmount: 0, // 목표금액 없음 (습관형)
        currentAmount: 45, // 45일 달성
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        endDate: DateTime.now().add(const Duration(days: 55)),
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        memberIds: [],
      ),
    ];
  }

  // 캡슐 데이터 새로고침
  void _refreshCapsuleData() {
    setState(() {
      // 실제 앱에서는 API 호출로 최신 데이터를 가져올 것
      // 여기서는 기존 데이터를 유지하면서 새로 추가된 캡슐만 반영
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.gray50,
      body: Stack(
        children: [
          // 메인 콘텐츠
          Column(
            children: [
              // 헤더
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0052A3), // 농협 진한 파란색
                      const Color(0xFF1976D2), // 밝은 파란색
                      const Color(0xFF42A5F5), // 연한 파란색
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0052A3).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'NH',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0052A3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '금융 타임캡슐',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '금융과 함께하는 나만의 감정일기',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 메인 콘텐츠
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 타임캡슐 정원
                      Text(
                        '🌱 나의 타임캡슐 정원',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NHColors.gray800,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 타임캡슐 정원 컨테이너 (아래쪽 확장)
                      Container(
                        height: capsules.isEmpty
                            ? 480
                            : math.max(
                                480, // 아래쪽 캡슐들을 위해 높이 확장 (420 → 480)
                                400 +
                                    ((capsules.length + 1) ~/ 3 + 1) *
                                        160), // 행별 간격 조정 (360 → 400, 140 → 160)
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFDCEEF5), // 연한 파란색 (하늘)
                              const Color(0xFFB8E6B8), // 연한 초록색 (잔디)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // 배경 장식들
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.yellow.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 32,
                              right: 32,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            // 세련된 흙 배경 (하늘 공간 적절히 조정)
                            Positioned(
                              bottom: 0,
                              top:
                                  170, // 상단 170px는 하늘 공간으로 확보 (200 → 170, 컨테이너 축소)
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xFFAED581), // 연한 초록색 (잔디)
                                      const Color(0xFFA1887F), // 부드러운 갈색
                                      const Color(0xFF8D6E63), // 진한 갈색
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // 세련된 잔디 효과
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      height: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xFF4CAF50)
                                                  .withOpacity(0.8),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                            12,
                                            (index) => Container(
                                              width: 1.5,
                                              height: 12,
                                              margin:
                                                  const EdgeInsets.only(top: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF4CAF50)
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 💎 프리미엄 흙속 보물들 (배경으로)

                                    // 🏅 금괴 1 - 왼쪽 상단
                                    Positioned(
                                      top: 30,
                                      left: 25,
                                      child: Container(
                                        width: 20,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFFD700),
                                              Color(0xFFFFA500),
                                              Color(0xFFFFD700),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.amber.withOpacity(0.4),
                                              blurRadius: 4,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 16,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFB8860B)
                                                  .withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 💎 다이아몬드 - 중앙 상단
                                    Positioned(
                                      top: 25,
                                      left: 170,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.9),
                                              Colors.blue.withOpacity(0.3),
                                              Colors.white.withOpacity(0.7),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.blue.withOpacity(0.2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 🏅 금괴 2 - 오른쪽 상단
                                    Positioned(
                                      top: 40,
                                      right: 30,
                                      child: Container(
                                        width: 18,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFFD700),
                                              Color(0xFFFFA500),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.amber.withOpacity(0.3),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 💚 에메랄드 - 왼쪽 중앙
                                    Positioned(
                                      top: 70,
                                      left: 50,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Color(0xFF50C878),
                                              Color(0xFF228B22),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.green.withOpacity(0.4),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 🏅 작은 금괴 - 중앙
                                    Positioned(
                                      top: 90,
                                      left: 140,
                                      child: Container(
                                        width: 14,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDAA520)
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                      ),
                                    ),

                                    // 🔵 사파이어 - 오른쪽 중앙
                                    Positioned(
                                      top: 80,
                                      right: 50,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Color(0xFF0F52BA),
                                              Color(0xFF082567),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.blue.withOpacity(0.4),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 🏅 금괴 3 - 왼쪽 하단
                                    Positioned(
                                      bottom: 70,
                                      left: 80,
                                      child: Container(
                                        width: 16,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFFD700),
                                              Color(0xFFB8860B),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),

                                    // 💎 작은 보석들
                                    Positioned(
                                      bottom: 50,
                                      left: 200,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDC143C)
                                              .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 90,
                                      right: 80,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Color(0xFF9966CC),
                                              Color(0xFF663399),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 타임캡슐들 (모든 캡슐 표시)
                            if (capsules.isNotEmpty) ...[
                              ...capsules.asMap().entries.map((entry) {
                                final index = entry.key;
                                final capsule = entry.value;
                                final progress = capsule.progress;

                                // 동적 그리드 위치 계산 (3열 그리드)
                                final row = index ~/ 3;
                                final col = index % 3;

                                // 캡슐들을 적당한 간격으로 균등 배치
                                final containerWidth =
                                    MediaQuery.of(context).size.width - 20;
                                final capsuleWidth = 100.0;
                                final availableWidth =
                                    containerWidth - (3 * capsuleWidth);
                                final spacing =
                                    availableWidth / 3; // 적당한 간격으로 조정

                                final left =
                                    10 + (col * (capsuleWidth + spacing));

                                // 🌱 진행률 순서별 정확한 배치 + 완전 겹침 방지
                                final soilSurface = 170.0; // 흙 표면

                                // 열별 미세 조정 (겹침 방지용)
                                final colOffset =
                                    col * 15.0; // 작은 값으로 조정하여 순서 유지

                                double top;
                                if (progress >= 1.0) {
                                  // 🎉 완성된 캡슐들: 같은 높이로 하늘에 배치
                                  top = 25 + colOffset;
                                } else if (progress >= 0.85) {
                                  // 1위: 다낭여행(90%) - 가장 위, 지표면 위로 크게 솟아남 (그대로 유지)
                                  top = soilSurface - 70 + colOffset;
                                } else if (progress >= 0.75) {
                                  // 2위: 결혼기념일(83%) - 더더 아래로 (지표면 훨씬 아래)
                                  top = soilSurface + 30 + colOffset;
                                } else if (progress >= 0.65) {
                                  // 3위: 러닝(70%) - 더더 아래로 (흙 속 깊이)
                                  top = soilSurface + 80 + colOffset;
                                } else if (progress >= 0.4) {
                                  // 4위: 독서습관(45%) - 조금 더 아래로
                                  top = soilSurface + 140 + colOffset;
                                } else {
                                  // 5위: 내집마련(30%) & 새 캡슐(0%) - 더더욱 많이 아래로 (흙 속 매우 깊이)
                                  top = soilSurface + 280 + colOffset;
                                }

                                return Positioned(
                                  left: left,
                                  top: top,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _onCapsuleTap(capsule, progress),
                                    child: _buildEggCapsule(capsule, progress),
                                  ),
                                );
                              }).toList(),

                              // 무기한 타임캡슐 추가 (6위: 가장 아래)
                              Positioned(
                                top: 470, // 6위: 무제한 - 더더욱 많이 아래로 (흙 속 최하단)
                                left:
                                    MediaQuery.of(context).size.width / 2 - 42,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const GeneralDiaryScreen(),
                                      ),
                                    );
                                  },
                                  child: _buildInfiniteCapsule(),
                                ),
                              ),
                            ] else
                              // 빈 정원 플레이스홀더
                              Positioned(
                                top: 150,
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.eco,
                                      size: 48,
                                      color: NHColors.gray400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '첫 번째 타임캡슐을 만들어보세요!',
                                      style: TextStyle(
                                        color: NHColors.gray600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 포인트 및 쿠폰 카드
                      Row(
                        children: [
                          // 멤버스 포인트 카드
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '💎 멤버스 포인트',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: NHColors.gray700,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color:
                                              NHColors.success.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '적립',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: NHColors.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${userData.totalPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}P',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: NHColors.success,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${userData.pointGrade} 등급',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: NHColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // 쿠폰 카드
                          Expanded(
                            child: GestureDetector(
                              onTap: _showCouponModal,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '🎫 보유 쿠폰',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: NHColors.gray700,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: NHColors.orange
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '사용가능',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: NHColors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${userData.coupons.where((c) => !c.isUsed).length}장',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: NHColors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '7일 이내 만료 1장',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: NHColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 퀵 액션
                      Text(
                        '⚡ 퀵 액션',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NHColors.gray800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildQuickActionButton(
                            icon: '🆕',
                            title: '타임캡슐\n생성',
                            onTap: () async {
                              final newCapsule = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CapsuleCreateScreen(),
                                ),
                              );
                              if (newCapsule != null) {
                                setState(() {
                                  capsules.add(newCapsule);
                                });
                              }
                            },
                            color: NHColors.primary,
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildQuickActionButton(
                            icon: '📝',
                            title: '금융일기\n작성',
                            onTap: () {
                              _showCapsuleSelectionDialog('diary');
                            },
                            color: NHColors.success,
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildQuickActionButton(
                            icon: '📊',
                            title: '캐릭터\n분석',
                            onTap: () {
                              _showAnalysisOptionsDialog();
                            },
                            color: NHColors.orange,
                          )),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 감정 캐릭터 현황
                      Text(
                        '🎭 감정 캐릭터 현황',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NHColors.gray800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: characters.asMap().entries.map((entry) {
                            final index = entry.key;
                            final character = entry.value;
                            final isLast = index == characters.length - 1;

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      character.emoji,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                character.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: NHColors.gray700,
                                                ),
                                              ),
                                              Text(
                                                'Lv.${character.level}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: character.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: NHColors.gray200,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor: character.exp /
                                                  character.maxExp,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: character.color,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${character.exp}/${character.maxExp} EXP',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: NHColors.gray500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (!isLast) const SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 80), // 하단 여백
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 푸시 알림 오버레이
          _buildPushNotificationOverlay(),
        ],
      ),

      // 플로팅 액션 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCapsule = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CapsuleCreateScreen(),
            ),
          );
          if (newCapsule != null) {
            setState(() {
              capsules.add(newCapsule);
            });
          }
        },
        backgroundColor: NHColors.success,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // 🌱 성장하는 타임캡슐 위젯 (스토리텔링 강화)
  Widget _buildEggCapsule(TimeCapsule capsule, double progress) {
    final isCompleted = progress >= 1.0;
    final categoryIcon = _getCategoryIcon(capsule.category);

    // 성장 단계별 시각적 효과
    final growthStage = progress >= 1.0
        ? 'completed'
        : progress >= 0.7
            ? 'blooming'
            : progress >= 0.4
                ? 'growing'
                : 'seed';

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 완성된 캡슐의 특별한 오라 효과
        if (isCompleted)
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.yellow.withOpacity(0.4),
                  Colors.orange.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
          ),

        // 메인 캡슐 컨테이너
        Container(
          width: 64,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isCompleted
                  ? [
                      const Color(0xFFFFF9C4),
                      const Color(0xFFFFEB3B),
                      const Color(0xFFFFC107),
                    ]
                  : progress >= 0.7
                      ? [
                          Colors.white,
                          const Color(0xFFE8F5E8),
                          const Color(0xFF81C784),
                        ]
                      : progress >= 0.4
                          ? [
                              Colors.white,
                              const Color(0xFFE3F2FD),
                              const Color(0xFFBBDEFB),
                            ]
                          : [
                              const Color(0xFFFAFAFA),
                              const Color(0xFFE0E0E0),
                              const Color(0xFFBDBDBD),
                            ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFFF57F17)
                  : progress >= 0.7
                      ? const Color(0xFF4CAF50)
                      : progress >= 0.4
                          ? const Color(0xFF1976D2)
                          : const Color(0xFF9E9E9E),
              width: isCompleted ? 3 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isCompleted
                    ? Colors.amber.withOpacity(0.5)
                    : progress >= 0.7
                        ? Colors.green.withOpacity(0.3)
                        : progress >= 0.4
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                blurRadius: isCompleted ? 16 : 12,
                offset: const Offset(0, 6),
                spreadRadius: isCompleted ? 2 : 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              categoryIcon,
              style: TextStyle(
                fontSize: isCompleted
                    ? 28
                    : progress >= 0.4
                        ? 24
                        : 20,
                shadows: isCompleted
                    ? [
                        Shadow(
                          color: Colors.orange.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),

        // 진행률 표시 (모든 캡슐에 표시)
        Positioned(
          bottom: -20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFFFF59D)
                  : progress >= 0.7
                      ? const Color(0xFFE8F5E8)
                      : progress >= 0.4
                          ? const Color(0xFFE3F2FD)
                          : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFFF57F17)
                    : progress >= 0.7
                        ? const Color(0xFF4CAF50)
                        : progress >= 0.4
                            ? const Color(0xFF1976D2)
                            : const Color(0xFF9E9E9E),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              isCompleted ? '🎉 완성!' : '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCompleted
                    ? const Color(0xFFF57F17)
                    : progress >= 0.7
                        ? const Color(0xFF2E7D32)
                        : progress >= 0.4
                            ? const Color(0xFF1976D2)
                            : const Color(0xFF757575),
              ),
            ),
          ),
        ),

        // 캡슐 제목 표시 (모든 캡슐에 표시)
        Positioned(
          bottom: -50,
          child: Container(
            width: 85,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFFF57F17).withOpacity(0.3)
                    : progress >= 0.7
                        ? const Color(0xFF4CAF50).withOpacity(0.3)
                        : progress >= 0.4
                            ? const Color(0xFF1976D2).withOpacity(0.3)
                            : const Color(0xFF9E9E9E).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              capsule.title.length > 9
                  ? '${capsule.title.substring(0, 9)}...'
                  : capsule.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isCompleted
                    ? const Color(0xFFF57F17)
                    : progress >= 0.7
                        ? const Color(0xFF2E7D32)
                        : progress >= 0.4
                            ? const Color(0xFF1976D2)
                            : const Color(0xFF757575),
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  // ♾️ 무기한 타임캡슐 위젯 (성장 스타일과 통일)
  Widget _buildInfiniteCapsule() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 특별한 오라 효과
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.green.withOpacity(0.3),
                Colors.teal.withOpacity(0.15),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(50),
          ),
        ),

        // 메인 캡슐 컨테이너
        Container(
          width: 64,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F5E8),
                Color(0xFF4CAF50),
                Color(0xFF2E7D32),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0xFF1B5E20),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '∞',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color(0xFF1B5E20),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 무제한 표시
        Positioned(
          bottom: -20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF2E7D32),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              '♾️ 무제한',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
        ),

        // 제목 표시
        Positioned(
          bottom: -50,
          child: Container(
            width: 85,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              '금융일기',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 퀵 액션 버튼
  Widget _buildQuickActionButton({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (color ?? NHColors.primary).withOpacity(0.1),
              (color ?? NHColors.primary).withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (color ?? NHColors.primary).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (color ?? NHColors.primary).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color ?? NHColors.primary,
                    (color ?? NHColors.primary).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (color ?? NHColors.primary).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: NHColors.gray700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 캡슐 탭 이벤트 처리
  void _onCapsuleTap(TimeCapsule capsule, double progress) {
    if (progress >= 1.0) {
      // 100% 이상 완성된 캡슐은 오픈 화면으로
      if (capsule.isPersonal) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalCapsuleOpenScreen(capsule: capsule),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupCapsuleOpenScreen(capsule: capsule),
          ),
        );
      }
    } else {
      // 100% 미만인 캡슐은 일기 작성 화면으로
      if (capsule.isPersonal) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalCapsuleDiaryScreen(capsule: capsule),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupCapsuleDiaryScreen(capsule: capsule),
          ),
        );
      }
    }
  }

  // 쿠폰 모달 표시
  void _showCouponModal() {
    final usedCoupons = userData.coupons.where((c) => c.isUsed).toList();
    final availableCoupons = userData.coupons.where((c) => !c.isUsed).toList();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🎫 내 쿠폰',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: NHColors.gray100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (usedCoupons.isNotEmpty) ...[
                        Text(
                          '받은 쿠폰',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...usedCoupons
                            .map((c) => _buildCouponTile(c, used: true)),
                        const SizedBox(height: 20),
                      ],
                      if (availableCoupons.isNotEmpty) ...[
                        Text(
                          '앞으로 받을 수 있는 쿠폰',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...availableCoupons
                            .map((c) => _buildCouponTile(c, used: false)),
                      ],
                    ],
                  ),
                ),
              ),
              if (usedCoupons.isEmpty && availableCoupons.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard_outlined,
                          size: 48,
                          color: NHColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '쿠폰이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 쿠폰 타일 빌더
  Widget _buildCouponTile(Coupon coupon, {required bool used}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: used ? NHColors.gray100 : NHColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: used ? NHColors.gray300 : NHColors.orange, width: 1.2),
      ),
      child: Row(
        children: [
          Text(coupon.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coupon.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(coupon.description,
                    style:
                        const TextStyle(fontSize: 13, color: NHColors.gray600)),
              ],
            ),
          ),
          if (used)
            const Icon(Icons.check_circle, color: NHColors.gray400, size: 20)
          else
            const Icon(Icons.lock_open, color: NHColors.orange, size: 20),
        ],
      ),
    );
  }

  // 캡슐 선택 다이얼로그
  void _showCapsuleSelectionDialog(String purpose) {
    final activeCapsules = capsules.where((c) {
      if (c.status != CapsuleStatus.active) return false;

      // 일기 작성 및 분석 목적 모두 100% 달성 이상인 캡슐 제외
      if (purpose == 'diary' || purpose == 'analysis') {
        return c.progress < 1.0; // 100% 미만만 포함
      }

      return true;
    }).toList();

    if (activeCapsules.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: NHColors.orange),
              const SizedBox(width: 8),
              const Text('활성 타임캡슐 없음'),
            ],
          ),
          content: const Text('진행중인 타임캡슐이 없습니다.\n새 타임캡슐을 만들어보세요!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purpose == 'diary' ? '📝 금융일기 작성' : '📊 타임캡슐 캐릭터 분석',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: NHColors.gray800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        purpose == 'diary'
                            ? '어떤 타임캡슐에 기록하시겠어요?'
                            : '어떤 타임캡슐의 캐릭터를 분석하시겠어요?',
                        style: TextStyle(
                          fontSize: 14,
                          color: NHColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: NHColors.gray100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 일반 금융일기 옵션 (diary purpose일 때만 표시)
              if (purpose == 'diary') ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: _buildDiaryOptionTile(
                    icon: '∞',
                    title: '무제한 타임캡슐',
                    subtitle: '기간 제한 없이 자유롭게 작성',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GeneralDiaryScreen(),
                        ),
                      );
                    },
                    color: NHColors.primary,
                  ),
                ),
                Divider(color: NHColors.gray200),
                const SizedBox(height: 16),
              ],

              if (activeCapsules.isNotEmpty) ...[
                Text(
                  purpose == 'diary' ? '타임캡슐별 작성' : '타임캡슐 선택',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: NHColors.gray700,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: activeCapsules
                          .map(
                            (capsule) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: _buildDiaryOptionTile(
                                icon: _getCategoryIcon(capsule.category),
                                title: capsule.title,
                                subtitle: _getCapsuleSubtitle(capsule),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (purpose == 'diary') {
                                    // 일기 작성으로 이동
                                    if (capsule.isPersonal) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalCapsuleDiaryScreen(
                                                  capsule: capsule),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupCapsuleDiaryScreen(
                                                  capsule: capsule),
                                        ),
                                      );
                                    }
                                  } else {
                                    // 캐릭터 분석으로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CapsuleCharacterAnalysisScreen(
                                                capsuleId: capsule.id),
                                      ),
                                    );
                                  }
                                },
                                color: purpose == 'diary'
                                    ? (capsule.isPersonal
                                        ? NHColors.success
                                        : NHColors.orange)
                                    : NHColors.primary,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ] else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: NHColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '생성된 활성 타임캡슐이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiaryOptionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: NHColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  // 캡슐 서브타이틀 생성 함수
  String _getCapsuleSubtitle(TimeCapsule capsule) {
    if (capsule.targetAmount == 0) {
      // 습관형 타임캡슐
      if (capsule.category == 'running' || capsule.category == '러닝') {
        return '러닝 습관 - ${capsule.currentAmount.toInt()}일 달성';
      } else if (capsule.category == 'reading' || capsule.category == '독서') {
        return '독서 습관 - ${capsule.currentAmount.toInt()}일 달성';
      } else {
        return '습관 형성 - ${capsule.currentAmount.toInt()}일 달성';
      }
    } else {
      // 일반 금융 타임캡슐
      return '${capsule.progressPercentage}% 달성';
    }
  }

  // 푸시 알림 오버레이 (위치 조정 및 영구 해제 기능)
  Widget _buildPushNotificationOverlay() {
    if (_notificationPermanentlyDismissed) {
      return const SizedBox.shrink(); // 영구 해제된 경우 아무것도 표시하지 않음
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NHColors.primary.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _hideNotification();
                  _navigateToDiaryWriting();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // 앱 아이콘
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              NHColors.primary,
                              NHColors.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 알림 내용
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'NH 타임캡슐',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: NHColors.gray800,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'now',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: NHColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '오늘의 타임캡슐을 작성하셨나요? 📝\n작성하고 멤버스포인트 50P를 받아가세요',
                              style: TextStyle(
                                fontSize: 14,
                                color: NHColors.gray600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 닫기 버튼
                      GestureDetector(
                        onTap: _hideNotification,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: NHColors.gray100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: NHColors.gray600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDiaryWriting() {
    // 첫 번째 활성 캡슐이 있으면 해당 캡슐의 일기 작성으로, 없으면 일반 일기 작성으로
    if (capsules.isNotEmpty) {
      final activeCapsule = capsules.firstWhere(
        (c) => c.status == CapsuleStatus.active,
        orElse: () => capsules.first,
      );

      if (activeCapsule.isPersonal) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PersonalCapsuleDiaryScreen(capsule: activeCapsule),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GroupCapsuleDiaryScreen(capsule: activeCapsule),
          ),
        );
      }
    } else {
      // 활성 캡슐이 없으면 일반 일기 작성으로
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GeneralDiaryScreen(),
        ),
      );
    }
  }

  // 카테고리별 아이콘 가져오기
  String _getCategoryIcon(String category) {
    switch (category) {
      case 'travel':
        return '🏖️';
      case 'home':
        return '🏠';
      case 'relationship':
        return '💕';
      case 'financial':
        return '💰';
      case 'lifestyle':
        return '🎯';
      case 'running':
      case '러닝':
        return '🏃‍♂️';
      case 'reading':
      case '독서':
        return '📖';
      default:
        return '✨';
    }
  }

  // 캐릭터 분석 옵션 다이얼로그
  void _showAnalysisOptionsDialog() {
    final personalCapsules = capsules
        .where((c) =>
            c.type == CapsuleType.personal && c.status == CapsuleStatus.active)
        .toList();

    if (personalCapsules.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: NHColors.orange),
              const SizedBox(width: 8),
              const Text('개인형 타임캡슐 없음'),
            ],
          ),
          content: const Text('진행중인 개인형 타임캡슐이 없습니다.\n새 개인 타임캡슐을 만들어보세요!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                NHColors.primary.withOpacity(0.02),
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📊 캐릭터 분석 방법',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: NHColors.gray800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '어떤 방식으로 캐릭터를 분석하시겠어요?',
                        style: TextStyle(
                          fontSize: 14,
                          color: NHColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: NHColors.gray100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAnalysisOptionCard(
                        icon: '🎭',
                        title: '개인형 타임캡슐 캐릭터 분석',
                        description: '개인형 타임캡슐의 감정 여정과\n성장 스토리를 확인할 수 있어요!',
                        color: NHColors.primary,
                        onTap: () {
                          Navigator.pop(context);
                          _showCapsuleSelectionDialog('analysis');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildAnalysisOptionCard(
                        icon: '📈',
                        title: '월별 캐릭터 분석',
                        description: '월별로 감정 캐릭터의\n성장 현황을 확인할 수 있어요!',
                        color: NHColors.success,
                        onTap: () {
                          Navigator.pop(context);
                          _showMonthlyAnalysisDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisOptionCard({
    required String icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: NHColors.gray600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthlyAnalysisDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MonthlyCharacterAnalysisScreen(),
      ),
    );
  }
}
