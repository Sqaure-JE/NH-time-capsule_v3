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
import '../diary/general_diary_screen.dart';
import '../diary/personal_capsule_diary_screen.dart';
import '../diary/group_capsule_diary_screen.dart';
import '../analysis/monthly_character_analysis_screen.dart';
import '../analysis/capsule_character_analysis_screen.dart';
import '../capsule/personal_capsule_open_screen.dart';
import '../capsule/group_capsule_open_screen.dart';

class NHHomeScreen extends StatefulWidget {
  const NHHomeScreen({super.key});

  @override
  State<NHHomeScreen> createState() => _NHHomeScreenState();
}

class _NHHomeScreenState extends State<NHHomeScreen> {
  late UserData userData;
  late List<TimeCapsule> capsules;
  late List<EmotionCharacter> characters;
  int _selectedTabIndex = 2; // 0:자산, 1:소비, 2:타임캡슐, 3:즐겨찾기, 4:전체

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // 임시 데이터 초기화
    userData = UserData.defaultUser();
    characters = EmotionCharacter.defaultCharacters;

    // 임시 타임캡슐 데이터
    capsules = [
      // 진행중인 타임캡슐들
      TimeCapsule(
        id: 'capsule_1',
        title: '다낭 여행',
        category: 'travel',
        type: CapsuleType.personal,
        targetAmount: 2000000,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 150)),
        currentAmount: 1800000,
        recordCount: 15,
        photoCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      TimeCapsule(
        id: 'capsule_2',
        title: '내집마련',
        category: 'home',
        type: CapsuleType.personal,
        targetAmount: 50000000,
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 300)),
        currentAmount: 15000000, // 30% 진행률
        recordCount: 25,
        photoCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      TimeCapsule(
        id: 'capsule_7',
        title: '💕 결혼기념일',
        category: 'relationship',
        type: CapsuleType.personal,
        targetAmount: 3000000,
        startDate: DateTime.now().subtract(const Duration(days: 90)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        currentAmount: 2500000,
        recordCount: 18,
        photoCount: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      TimeCapsule(
        id: 'capsule_8',
        title: '✈️ 친구들과 유럽여행',
        category: 'travel',
        type: CapsuleType.group,
        targetAmount: 20000000,
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 300)),
        currentAmount: 15000000, // 75% 진행률
        recordCount: 25,
        photoCount: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        memberIds: ['김올리', '박수빈', '이정은', '최민수'],
      ),

      // 완료된 타임캡슐들 (열기 가능) - 개인형 1개, 모임형 1개
      TimeCapsule(
        id: 'capsule_4',
        title: '🏖️ 제주도 여행 자금',
        category: 'travel',
        type: CapsuleType.personal,
        targetAmount: 1500000,
        startDate: DateTime.now().subtract(const Duration(days: 180)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
        currentAmount: 1680000,
        recordCount: 28,
        photoCount: 15,
        status: CapsuleStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TimeCapsule(
        id: 'capsule_9',
        title: '🚄 친구들과 부산여행',
        category: 'travel',
        type: CapsuleType.group,
        targetAmount: 2000000,
        startDate: DateTime.now().subtract(const Duration(days: 200)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
        currentAmount: 2000000,
        recordCount: 20,
        photoCount: 10,
        status: CapsuleStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        memberIds: ['김올리', '박수빈', '이정은', '최민수'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // NH마이데이터 헤더
            const NHMyDataHeader(),

            // 상단 탭바
            _buildTopTabBar(),

            // 시간 표시
            TimeDisplayHeader(
              time: NHDateUtils.DateUtils.formatDateTime(DateTime.now()),
              onRefreshPressed: () {},
            ),

            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 자산 요약 카드 (첨부 이미지 스타일)
                    _buildAssetSummaryCardV2(),
                    const SizedBox(height: 20),

                    // 금융 타임캡슐 요약 카드
                    _buildCapsuleSummaryCard(),
                    const SizedBox(height: 20),

                    // 열기 가능한 캡슐
                    _buildOpenableCapsules(),
                    const SizedBox(height: 20),

                    // 진행중인 캡슐
                    _buildActiveCapsules(),
                    const SizedBox(height: 20),

                    // 퀵 액션 버튼들
                    _buildQuickActions(),
                    const SizedBox(height: 20),

                    // 감정 캐릭터 현황
                    _buildCharacterStatus(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // 상단 탭바 위젯
  Widget _buildTopTabBar() {
    final tabLabels = ['자산', '소비', '타임캡슐', '즐겨찾기', '전체'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          tabLabels.length,
          (i) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = i;
              });
            },
            child: _buildTab(tabLabels[i], _selectedTabIndex == i),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: selected ? NHColors.primary : NHColors.gray400,
            ),
          ),
          if (selected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 32,
              color: NHColors.primary,
            ),
        ],
      ),
    );
  }

  // 자산 요약 카드 (첨부 이미지 스타일)
  Widget _buildAssetSummaryCardV2() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '김올리님의 순자산',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: NHColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '금액',
                  style: TextStyle(
                    color: NHColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormatter.formatCurrencyWithUnit(userData.totalAssets),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '07.04 대비 ',
                style: TextStyle(fontSize: 13, color: NHColors.gray500),
              ),
              Icon(
                userData.todayChange >= 0
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: userData.todayChange >= 0 ? Colors.red : Colors.blue,
                size: 18,
              ),
              Text(
                NumberFormatter.formatChange(userData.todayChange),
                style: TextStyle(
                  fontSize: 13,
                  color: userData.todayChange >= 0 ? Colors.red : Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 금융 타임캡슐 요약 카드
  Widget _buildCapsuleSummaryCard() {
    final progressing = capsules.where((c) => c.isActive).length;
    final completed = capsules
        .where((c) => c.status == CapsuleStatus.completed)
        .length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🥚 금융 타임캡슐',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: NHColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${userData.totalPoints}P',
                  style: const TextStyle(
                    color: NHColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '감정과 함께하는 특별한 저축',
            style: TextStyle(fontSize: 13, color: NHColors.gray500),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCapsuleSummaryItem('진행중', progressing, NHColors.primary),
              _buildCapsuleSummaryItem('완료', completed, NHColors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapsuleSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: color)),
      ],
    );
  }

  Widget _buildPointCard() {
    return LargePointDisplayWidget(
      points: userData.totalPoints,
      title: '현재 포인트',
      subtitle: '${userData.pointGrade} 등급',
      onTap: () {
        // 포인트 상세 화면으로 이동
      },
    );
  }

  Widget _buildOpenableCapsules() {
    final openableCapsules = capsules.where((c) => c.isOpenable).toList();

    if (openableCapsules.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎉 열기 가능한 타임캡슐',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        const SizedBox(height: 12),
        ...openableCapsules.map(
          (capsule) => _buildOpenableCapsuleCard(capsule),
        ),
      ],
    );
  }

  Widget _buildOpenableCapsuleCard(TimeCapsule capsule) {
    return GestureDetector(
      onTap: () {
        if (capsule.type == CapsuleType.personal) {
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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              capsule.type == CapsuleType.personal
                  ? NHColors.blue.withOpacity(0.1)
                  : NHColors.primary.withOpacity(0.1),
              NHColors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: capsule.type == CapsuleType.personal
                ? NHColors.blue.withOpacity(0.3)
                : NHColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (capsule.type == CapsuleType.personal
                          ? NHColors.blue
                          : NHColors.primary)
                      .withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 영역
              Row(
                children: [
                  // 카테고리 아이콘
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: capsule.type == CapsuleType.personal
                          ? NHColors.blue.withOpacity(0.2)
                          : NHColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        capsule.categoryIcon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 제목과 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capsule.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: capsule.type == CapsuleType.personal
                                    ? NHColors.blue
                                    : NHColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                capsule.type == CapsuleType.personal
                                    ? '개인형'
                                    : '모임형',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: NHColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: NHColors.gray100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${capsule.durationInMonths}개월',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: NHColors.gray600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 완료 뱃지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [NHColors.joy, NHColors.joy.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: NHColors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: NHColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 목표 금액과 진행률
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '목표 금액',
                          style: TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormatter.formatCurrencyWithUnit(
                            capsule.targetAmount,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '달성률',
                          style: TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${capsule.progressPercentage}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: capsule.type == CapsuleType.personal
                                ? NHColors.blue
                                : NHColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 진행률 바
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: NHColors.gray200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: capsule.progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          capsule.type == CapsuleType.personal
                              ? NHColors.blue
                              : NHColors.primary,
                          capsule.type == CapsuleType.personal
                              ? NHColors.blue.withOpacity(0.8)
                              : NHColors.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 하단 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 기록 정보
                  Row(
                    children: [
                      Icon(Icons.edit_note, size: 16, color: NHColors.gray500),
                      const SizedBox(width: 4),
                      Text(
                        '${capsule.recordCount}회 기록',
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: NHColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${capsule.photoCount}장 사진',
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                    ],
                  ),

                  // 열기 버튼
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: capsule.type == CapsuleType.personal
                          ? NHColors.blue
                          : NHColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.open_in_new,
                          color: NHColors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '열기',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: NHColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveCapsules() {
    final activeCapsules =
        capsules
            .where((c) => c.status == CapsuleStatus.active && !c.isOpenable)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순 정렬

    if (activeCapsules.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '진행중인 타임캡슐',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: NHColors.gray800,
              ),
            ),
            TextButton(
              onPressed: () {
                _showAllCapsules();
              },
              child: const Text(
                '전체보기',
                style: TextStyle(
                  color: NHColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 개인형과 모임형을 모두 표시하도록 수정
        ...activeCapsules
            .where((c) => c.type == CapsuleType.personal)
            .take(2)
            .map(
              (capsule) => CapsuleCardWidget(
                capsule: capsule,
                onTap: () {
                  _navigateToCapsuleDiary(capsule);
                },
              ),
            ),
        if (activeCapsules
            .where((c) => c.type == CapsuleType.group)
            .isNotEmpty) ...[
          const SizedBox(height: 8),
          ...activeCapsules
              .where((c) => c.type == CapsuleType.group)
              .take(2)
              .map(
                (capsule) => CapsuleCardWidget(
                  capsule: capsule,
                  onTap: () {
                    _navigateToCapsuleDiary(capsule);
                  },
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '퀵 액션',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.add_circle_outline,
                title: '타임캡슐\n생성',
                color: NHColors.primary,
                onTap: () async {
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
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.edit_note,
                title: '금융일기\n작성',
                color: NHColors.blue,
                onTap: () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('일기 유형 선택'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, 'general'),
                          child: const Text('일반 금융일기'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, 'personal'),
                          child: const Text('개인형 타임캡슐 일기'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, 'group'),
                          child: const Text('모임형 타임캡슐 일기'),
                        ),
                      ],
                    ),
                  );
                  if (selected == 'general') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneralDiaryScreen(),
                      ),
                    );
                  } else if (selected == 'personal') {
                    _showPersonalCapsuleSelection(purpose: 'diary');
                  } else if (selected == 'group') {
                    _showGroupCapsuleSelection();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.analytics,
                title: '캐릭터\n분석',
                color: NHColors.fear,
                onTap: () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('분석 유형 선택'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, 'monthly'),
                          child: const Text('월간 캐릭터 분석'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, 'capsule'),
                          child: const Text('타임캡슐 캐릭터 분석'),
                        ),
                      ],
                    ),
                  );
                  if (selected == 'monthly') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MonthlyCharacterAnalysisScreen(),
                      ),
                    );
                  } else if (selected == 'capsule') {
                    _showPersonalCapsuleSelection(purpose: 'analysis');
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: NHColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: NHColors.gray200.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: NHColors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '감정 캐릭터 현황',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: NHColors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: NHColors.gray200.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: characters
                .map(
                  (character) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          character.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                character.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CharacterExpProgressBar(
                                currentExp: character.exp,
                                maxExp: character.maxExp,
                                level: character.level,
                                characterColor: character.color,
                                showDetails: false,
                              ),
                            ],
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
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showAllCapsules() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '전체 타임캡슐',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 열기 가능한 캡슐
                      if (capsules.where((c) => c.isOpenable).isNotEmpty) ...[
                        const Text(
                          '🎉 열기 가능한 타임캡슐',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...capsules
                            .where((c) => c.isOpenable)
                            .map(
                              (capsule) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: OpenableCapsuleCard(
                                  capsule: capsule,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final selected = await showDialog<String>(
                                      context: context,
                                      builder: (context) => SimpleDialog(
                                        title: const Text('타임캡슐 열기'),
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text('어떤 타입의 타임캡슐인가요?'),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () => Navigator.pop(
                                              context,
                                              'personal',
                                            ),
                                            child: const Text('개인형 타임캡슐'),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () =>
                                                Navigator.pop(context, 'group'),
                                            child: const Text('모임형 타임캡슐'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (selected == 'personal') {
                                      // 개인형 타임캡슐 선택 - 첫 번째 개인형 캡슐로 이동
                                      final personalCapsule = capsules
                                          .where(
                                            (c) =>
                                                c.type ==
                                                    CapsuleType.personal &&
                                                c.isOpenable,
                                          )
                                          .first;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalCapsuleOpenScreen(
                                                capsule: personalCapsule,
                                              ),
                                        ),
                                      );
                                    } else if (selected == 'group') {
                                      // 모임형 타임캡슐 선택 - 첫 번째 모임형 캡슐로 이동
                                      final groupCapsule = capsules
                                          .where(
                                            (c) =>
                                                c.type == CapsuleType.group &&
                                                c.isOpenable,
                                          )
                                          .first;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupCapsuleOpenScreen(
                                                capsule: groupCapsule,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                        const SizedBox(height: 20),
                      ],
                      // 진행중인 캡슐
                      if (capsules
                          .where(
                            (c) =>
                                c.status == CapsuleStatus.active &&
                                !c.isOpenable,
                          )
                          .isNotEmpty) ...[
                        const Text(
                          '진행중인 타임캡슐',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...capsules
                            .where(
                              (c) =>
                                  c.status == CapsuleStatus.active &&
                                  !c.isOpenable,
                            )
                            .map(
                              (capsule) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: CapsuleCardWidget(
                                  capsule: capsule,
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (capsule.type == CapsuleType.personal) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalCapsuleDiaryScreen(
                                                capsule: capsule,
                                              ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupCapsuleDiaryScreen(
                                                capsule: capsule,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                      ],
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

  void _showPersonalCapsuleSelection({required String purpose}) {
    final personalCapsules = capsules
        .where(
          (c) =>
              c.type == CapsuleType.personal &&
              c.status == CapsuleStatus.active,
        )
        .toList();

    if (personalCapsules.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('개인형 타임캡슐 없음'),
          content: const Text('진행중인 개인형 타임캡슐이 없습니다.\n새 타임캡슐을 만들어보세요!'),
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
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    purpose == 'diary' ? '개인형 타임캡슐 일기 작성' : '개인형 타임캡슐 캐릭터 분석',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                purpose == 'diary'
                    ? '어떤 타임캡슐에 기록하시겠어요?\n💡 개인형 타임캡슐에서는 감정 캐릭터와 함께 성장하며, 이정표를 달성할 수 있어요!'
                    : '어떤 타임캡슐의 캐릭터를 분석하시겠어요?\n💡 개인형 타임캡슐의 감정 여정과 성장 스토리를 확인할 수 있어요!',
                style: const TextStyle(fontSize: 14, color: NHColors.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: personalCapsules
                        .map(
                          (capsule) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: CapsuleCardWidget(
                              capsule: capsule,
                              onTap: () {
                                Navigator.pop(context);
                                if (purpose == 'diary') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PersonalCapsuleDiaryScreen(
                                            capsule: capsule,
                                          ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CapsuleCharacterAnalysisScreen(
                                            capsuleId: capsule.id,
                                          ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGroupCapsuleSelection() {
    final groupCapsules = capsules
        .where(
          (c) =>
              c.type == CapsuleType.group && c.status == CapsuleStatus.active,
        )
        .toList();

    if (groupCapsules.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('모임형 타임캡슐 없음'),
          content: const Text('진행중인 모임형 타임캡슐이 없습니다.\n새 모임 타임캡슐을 만들어보세요!'),
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
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '모임형 타임캡슐 선택',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '어떤 모임 타임캡슐에 기록하시겠어요?\n💡 모임형 타임캡슐에서는 비용 분할과 영수증 첨부로 실용적인 기록을 남길 수 있어요!',
                style: TextStyle(fontSize: 14, color: NHColors.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: groupCapsules
                        .map(
                          (capsule) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: CapsuleCardWidget(
                              capsule: capsule,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GroupCapsuleDiaryScreen(
                                          capsule: capsule,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCapsuleDiary(TimeCapsule capsule) {
    if (capsule.type == CapsuleType.personal) {
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CapsuleCreateScreen()),
        );
      },
      backgroundColor: NHColors.primary,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
