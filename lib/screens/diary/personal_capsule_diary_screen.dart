import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';
import '../../models/time_capsule.dart';

class PersonalCapsuleDiaryScreen extends StatefulWidget {
  final TimeCapsule capsule;
  const PersonalCapsuleDiaryScreen({super.key, required this.capsule});

  @override
  State<PersonalCapsuleDiaryScreen> createState() =>
      _PersonalCapsuleDiaryScreenState();
}

class _PersonalCapsuleDiaryScreenState
    extends State<PersonalCapsuleDiaryScreen> {
  String selectedEmotion = '';
  String amount = '';
  String content = '';
  File? selectedImage;
  String milestone = '';
  final TextEditingController _diaryController = TextEditingController();

  // 현재 캡슐 정보를 동적으로 가져오기
  Map<String, dynamic> get currentCapsule => {
        'id': widget.capsule.id,
        'title': widget.capsule.title,
        'category': widget.capsule.category,
        'currentAmount': widget.capsule.currentAmount,
        'targetAmount': widget.capsule.targetAmount,
        'progress': widget.capsule.progressPercentage,
        'daysLeft': widget.capsule.daysLeft,
        'startDate': widget.capsule.startDate.toString().substring(0, 10),
        'endDate': widget.capsule.endDate.toString().substring(0, 10),
        'recordCount': widget.capsule.recordCount,
      };

  // 감정 캐릭터
  final List<Map<String, dynamic>> emotions = [
    {
      'id': 'joy',
      'emoji': '😊',
      'name': '기쁨이',
      'color': NHColors.joy,
      'level': 8,
      'description': '목표에 한 걸음 더 가까워졌어요!',
    },
    {
      'id': 'sadness',
      'emoji': '😢',
      'name': '슬픔이',
      'color': NHColors.sadness,
      'level': 4,
      'description': '힘든 순간도 성장의 기회예요.',
    },
    {
      'id': 'anger',
      'emoji': '😡',
      'name': '분노',
      'color': NHColors.anger,
      'level': 3,
      'description': '불합리한 지출에 단호하게 대처해요.',
    },
    {
      'id': 'fear',
      'emoji': '😰',
      'name': '불안이',
      'color': NHColors.fear,
      'level': 6,
      'description': '신중한 계획으로 안전하게 진행해요.',
    },
    {
      'id': 'disgust',
      'emoji': '🤢',
      'name': '까칠이',
      'color': NHColors.disgust,
      'level': 3,
      'description': '완벽한 목표 달성을 위해 꼼꼼히!',
    },
  ];

  // 이정표 (카테고리별로 다르게 설정)
  List<Map<String, dynamic>> get milestones {
    final category = widget.capsule.category;

    if (category == 'reading') {
      // 독서 습관용 이정표
      return [
        {'id': 'daily_read', 'emoji': '📖', 'text': '오늘 독서했어요', 'bonus': 10},
        {'id': 'focused_read', 'emoji': '🎯', 'text': '집중해서 읽었어요', 'bonus': 15},
        {
          'id': 'note_taking',
          'emoji': '📝',
          'text': '독서 노트를 작성했어요',
          'bonus': 20
        },
        {
          'id': 'deep_thinking',
          'emoji': '💡',
          'text': '깊이 생각하며 읽었어요',
          'bonus': 25
        },
      ];
    } else if (category == 'running') {
      // 러닝 습관용 이정표
      return [
        {'id': 'daily_run', 'emoji': '🏃‍♂️', 'text': '오늘 러닝했어요', 'bonus': 10},
        {
          'id': 'distance_goal',
          'emoji': '🎯',
          'text': '목표 거리를 달렸어요',
          'bonus': 15
        },
        {
          'id': 'weather_challenge',
          'emoji': '🌧️',
          'text': '궂은 날씨에도 달렸어요',
          'bonus': 20
        },
        {
          'id': 'personal_record',
          'emoji': '🏆',
          'text': '개인 기록을 갱신했어요',
          'bonus': 25
        },
      ];
    } else {
      // 기존 저축 관련 이정표
      return [
        {'id': 'saving', 'emoji': '💰', 'text': '저축했어요', 'bonus': 10},
        {'id': 'sacrifice', 'emoji': '🚫', 'text': '참았어요', 'bonus': 15},
        {'id': 'progress', 'emoji': '📈', 'text': '목표에 가까워졌어요', 'bonus': 20},
        {'id': 'challenge', 'emoji': '💪', 'text': '어려움을 극복했어요', 'bonus': 25},
      ];
    }
  }

  int get basePoints => 50;
  int get imagePoints => selectedImage != null ? 20 : 0;
  int get milestonePoints => milestones.firstWhere(
        (m) => m['id'] == milestone,
        orElse: () => {'bonus': 0},
      )['bonus'] as int;
  int get amountPoints => (amount.isNotEmpty &&
          int.tryParse(amount.replaceAll(',', '')) != null &&
          int.parse(amount.replaceAll(',', '')) > 0)
      ? 15
      : 0;
  int get totalPoints =>
      basePoints + imagePoints + milestonePoints + amountPoints;
  int get characterExp => (totalPoints / 2).floor();

  @override
  Widget build(BuildContext context) {
    final selectedEmotionData = emotions.firstWhere(
      (e) => e['id'] == selectedEmotion,
      orElse: () => {},
    );
    final selectedMilestoneData = milestones.firstWhere(
      (m) => m['id'] == milestone,
      orElse: () => {},
    );
    final progressToTarget = currentCapsule['targetAmount'] == 0
        ? 0.0 // 습관형 타임캡슐은 진행률 0으로 처리
        : ((currentCapsule['currentAmount'] +
                    (int.tryParse(amount.replaceAll(',', '')) ?? 0)) /
                currentCapsule['targetAmount']) *
            100;
    final remainingAmount = currentCapsule['targetAmount'] == 0
        ? 0 // 습관형 타임캡슐은 남은 금액 개념 없음
        : currentCapsule['targetAmount'] -
            currentCapsule['currentAmount'] -
            (int.tryParse(amount.replaceAll(',', '')) ?? 0);
    final avgPerDay = currentCapsule['daysLeft'] > 0 && remainingAmount > 0
        ? (remainingAmount / currentCapsule['daysLeft']).ceil()
        : 0;

    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NHHeaderWidget(
              title: widget.capsule.title,
              subtitle: '개인형',
              showBackButton: true,
              showHomeButton: false,
              showNotificationButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    _buildCapsuleStatus(
                      progressToTarget,
                      remainingAmount,
                      avgPerDay,
                    ),
                    const SizedBox(height: 16),
                    _buildEmotionSelector(selectedEmotionData),
                    const SizedBox(height: 16),
                    _buildMilestoneSelector(selectedMilestoneData),
                    const SizedBox(height: 16),
                    _buildAmountInput(progressToTarget),
                    const SizedBox(height: 16),
                    _buildDiaryInput(selectedEmotionData),
                    const SizedBox(height: 16),
                    _buildImageInput(),
                    const SizedBox(height: 16),
                    _buildRewardInfo(
                      selectedEmotionData,
                      selectedMilestoneData,
                    ),
                    const SizedBox(height: 16),
                    _buildProgressInfo(remainingAmount, avgPerDay),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(selectedEmotionData),
          ],
        ),
      ),
    );
  }

  Widget _buildCapsuleStatus(
    double progressToTarget,
    int remainingAmount,
    int avgPerDay,
  ) {
    // 습관형 타임캡슐인지 확인
    final isHabitCapsule = currentCapsule['targetAmount'] == 0;
    final targetDays = isHabitCapsule ? 100 : 0; // 습관형은 100일 목표로 설정
    final currentDays = isHabitCapsule ? currentCapsule['currentAmount'] : 0;
    final remainingDays =
        isHabitCapsule ? (targetDays - currentDays).clamp(0, targetDays) : 0;
    final dailyProgress = isHabitCapsule
        ? (currentDays / targetDays * 100).clamp(0, 100)
        : progressToTarget;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: NHColors.gradientGreenBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.capsule.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isHabitCapsule
                      ? '연속 ${currentDays}일'
                      : 'D-${widget.capsule.daysLeft}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHabitCapsule ? '달성률' : '현재 진행률',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                isHabitCapsule
                    ? '${dailyProgress.round()}%'
                    : '${progressToTarget.round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 10,
                width: isHabitCapsule
                    ? dailyProgress > 100
                        ? double.infinity
                        : dailyProgress * 2.5
                    : progressToTarget > 100
                        ? double.infinity
                        : progressToTarget * 2.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 습관형과 금융형 타임캡슐 구분 표시
          if (isHabitCapsule) ...[
            // 습관형 타임캡슐용 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentDays}일',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '목표: ${targetDays}일',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '목표까지',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '${remainingDays}일',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ] else ...[
            // 기존 금융 타임캡슐용 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatNumber(currentCapsule['currentAmount'])}원',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '목표: ${_formatNumber(currentCapsule['targetAmount'])}원',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '남은 금액',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '${_formatNumber(remainingAmount)}원',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmotionSelector(Map selectedEmotionData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎭 오늘 목표 달성 과정에서 느낀 감정',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: emotions.map((emotion) {
              final isSelected = selectedEmotion == emotion['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmotion = emotion['id'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (emotion['color'] as Color).withOpacity(0.15)
                          : NHColors.gray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? (emotion['color'] as Color)
                            : NHColors.gray200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          emotion['emoji'],
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          emotion['name'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Lv.${emotion['level']}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedEmotionData.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (selectedEmotionData['color'] as Color).withOpacity(
                  0.08,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${selectedEmotionData['name']} Lv.${selectedEmotionData['level']}\n${selectedEmotionData['description']}',
                style: TextStyle(
                  fontSize: 13,
                  color: selectedEmotionData['color'],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMilestoneSelector(Map selectedMilestoneData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏆 오늘의 이정표',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '목표 달성을 위해 한 특별한 행동이 있나요?',
            style: TextStyle(fontSize: 12, color: NHColors.gray500),
          ),
          const SizedBox(height: 12),
          Row(
            children: milestones.map((ms) {
              final isSelected = milestone == ms['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      milestone = milestone == ms['id'] ? '' : ms['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? NHColors.primary.withOpacity(0.12)
                          : NHColors.gray50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? NHColors.primary : NHColors.gray200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(ms['emoji'], style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 2),
                        Text(
                          ms['text'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '+${ms['bonus']}P',
                          style: const TextStyle(
                            fontSize: 10,
                            color: NHColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(double progressToTarget) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💰 이 타임캡슐에 추가한 금액',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              setState(() {
                amount = _formatNumber(value.replaceAll(',', ''));
              });
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              hintText: '오늘 추가한 금액 (선택사항)',
              border: OutlineInputBorder(),
              suffixText: '원',
            ),
          ),
          if (amount.isNotEmpty &&
              int.tryParse(amount.replaceAll(',', '')) != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NHColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '새로운 진행률: ${(progressToTarget).round()}%',
                style: const TextStyle(fontSize: 13, color: NHColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDiaryInput(Map selectedEmotionData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (selectedEmotionData.isNotEmpty)
                Text(
                  selectedEmotionData['emoji'],
                  style: const TextStyle(fontSize: 20),
                ),
              const SizedBox(width: 6),
              const Text(
                '📖 목표 달성 스토리',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: NHColors.gray800,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _generateAIContent(selectedEmotionData),
                icon: const Icon(Icons.auto_awesome, color: NHColors.primary),
                label: const Text(
                  'AI 글쓰기 추천',
                  style: TextStyle(color: NHColors.primary, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _diaryController,
            onChanged: (value) {
              setState(() {
                content = value;
              });
            },
            maxLines: 4,
            decoration: InputDecoration(
              hintText: selectedEmotionData.isNotEmpty
                  ? '${selectedEmotionData['name']}와 함께 목표를 향한 오늘의 여정을 기록해보세요...'
                  : '오늘 목표를 위해 어떤 노력을 했나요?',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '💡 예시: "오늘 점심을 도시락으로 해서 5천원 절약했어. 여행 가는 날이 점점 가까워지는 게 실감나!"',
            style: TextStyle(fontSize: 12, color: NHColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildImageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📸 오늘의 추억',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedImage != null
                      ? NHColors.primary
                      : NHColors.gray300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 28,
                          color: NHColors.gray400,
                        ),
                        SizedBox(height: 6),
                        Text(
                          '목표 관련 사진 추가',
                          style: TextStyle(
                            fontSize: 13,
                            color: NHColors.gray500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+20P • 캐릭터 성장 보너스',
                          style: TextStyle(
                            fontSize: 11,
                            color: NHColors.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardInfo(Map selectedEmotionData, Map selectedMilestoneData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: NHColors.gradientOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.card_giftcard, color: NHColors.orange, size: 22),
                  SizedBox(width: 8),
                  Text(
                    '타임캡슐 일기 리워드',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: NHColors.gray800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalPoints P',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: NHColors.orange,
                    ),
                  ),
                  const Text(
                    '포인트 적립',
                    style: TextStyle(fontSize: 12, color: NHColors.gray600),
                  ),
                ],
              ),
            ],
          ),
          if (selectedEmotionData.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        selectedEmotionData['emoji'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selectedEmotionData['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+$characterExp EXP',
                        style: const TextStyle(
                          fontSize: 13,
                          color: NHColors.purple,
                        ),
                      ),
                      const Text(
                        '경험치',
                        style: TextStyle(fontSize: 11, color: NHColors.gray600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          const Text(
            '• 기본 타임캡슐 일기 50P',
            style: TextStyle(fontSize: 12, color: NHColors.gray800),
          ),
          if (imagePoints > 0)
            const Text(
              '• 추억 사진 추가 +20P',
              style: TextStyle(fontSize: 12, color: NHColors.gray800),
            ),
          if (milestonePoints > 0)
            Text(
              '• 이정표 +${milestonePoints}P',
              style: const TextStyle(fontSize: 12, color: NHColors.gray800),
            ),
          if (amountPoints > 0)
            const Text(
              '• 금액 추가 기록 +15P',
              style: TextStyle(fontSize: 12, color: NHColors.gray800),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo(int remainingAmount, int avgPerDay) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            '🎯 목표까지',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_formatNumber(remainingAmount)}원',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: NHColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '하루 평균 ${_formatNumber(avgPerDay)}원씩!',
            style: const TextStyle(fontSize: 13, color: NHColors.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(Map selectedEmotionData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: NHColors.white,
        border: Border(top: BorderSide(color: NHColors.gray200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: NHColors.gray300),
              ),
              child: const Text(
                '임시저장',
                style: TextStyle(
                  color: NHColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: selectedEmotion.isNotEmpty ? _saveDiary : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: selectedEmotion.isNotEmpty
                    ? NHColors.primary
                    : NHColors.gray300,
              ),
              child: const Text(
                '캡슐에 담기 🥚✨',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDiary() {
    final selectedEmotionData = emotions.firstWhere(
      (e) => e['id'] == selectedEmotion,
      orElse: () => {},
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 타임캡슐 일기 저장 완료!'),
        content: Text(
          '${selectedEmotionData['name']} +$characterExp EXP\n총 $totalPoints P 적립!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '';
    final number = int.tryParse(value.toString());
    if (number == null) return value.toString();
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _generateAIContent(Map selectedEmotionData) {
    String aiContent = '';

    if (selectedEmotion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('감정을 먼저 선택해주세요!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 현재 진행 상황 정보
    final currentAmount = currentCapsule['currentAmount'];
    final targetAmount = currentCapsule['targetAmount'];
    final progressPercentage = targetAmount == 0
        ? (currentAmount).round() // 습관형은 현재 연속 일수
        : (currentAmount / targetAmount * 100).round();
    final emotionName = selectedEmotionData['name'];
    final inputAmount = int.tryParse(amount.replaceAll(',', '')) ?? 0;

    // 이정표별 AI 추천 (카테고리별로 다르게 처리)
    final category = widget.capsule.category;

    if (category == 'reading') {
      // 독서 습관 관련 메시지
      if (milestone == 'daily_read') {
        aiContent =
            '${emotionName}가 뿌듯하게 말해요! 📖 "오늘도 독서하는 시간을 가졌어!" ${progressPercentage}일 연속 독서 중이에요. 꾸준한 독서 습관이 정말 대단해요!';
      } else if (milestone == 'focused_read') {
        aiContent =
            '${emotionName}가 집중하며 말해요! 🎯 "정말 집중해서 읽었어!" ${progressPercentage}일째 꾸준히 이어가고 있어요. 깊이 있는 독서가 더 큰 성장을 만들어요!';
      } else if (milestone == 'note_taking') {
        aiContent =
            '${emotionName}가 성취감을 느끼며 말해요! 📝 "독서 노트까지 작성했어!" ${progressPercentage}일 동안 쌓인 기록들이 소중한 자산이 될 거예요!';
      } else if (milestone == 'deep_thinking') {
        aiContent =
            '${emotionName}가 깊이 생각하며 말해요! 💡 "책 내용을 깊이 생각해봤어!" ${progressPercentage}일째 성찰하는 독서를 이어가고 있어요!';
      }
    } else if (category == 'running') {
      // 러닝 습관 관련 메시지
      if (milestone == 'daily_run') {
        aiContent =
            '${emotionName}가 상쾌하게 말해요! 🏃‍♂️ "오늘도 러닝 완료!" ${progressPercentage}일 연속 달리기 중이에요. 꾸준한 운동 습관이 건강을 만들어가고 있어요!';
      } else if (milestone == 'distance_goal') {
        aiContent =
            '${emotionName}가 자랑스럽게 말해요! 🎯 "목표 거리를 완주했어!" ${progressPercentage}일째 목표를 달성하고 있어요. 계획한 목표를 달성하는 의지가 정말 대단해요!';
      } else if (milestone == 'weather_challenge') {
        aiContent =
            '${emotionName}가 당당하게 말해요! 🌧️ "궂은 날씨에도 포기하지 않았어!" ${progressPercentage}일 동안 어떤 조건에도 굴복하지 않는 정신력이 훌륭해요!';
      } else if (milestone == 'personal_record') {
        aiContent =
            '${emotionName}가 감격스럽게 외쳐요! 🏆 "개인 기록 갱신했어!" ${progressPercentage}일째 자신의 한계를 뛰어넘고 있어요!';
      }
    } else if (milestone == 'saving') {
      if (progressPercentage >= 80) {
        aiContent =
            '와! ${emotionName}가 저축하며 신나서 어쩔 줄 모르고 있어요! 💰 "벌써 ${progressPercentage}%나 모았다고?!" ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원을 더 모았어!' : ''} 목표 달성이 코앞이네요!';
      } else if (progressPercentage >= 50) {
        aiContent =
            '${emotionName}가 꾸준히 저축하며 뿌듯해하고 있어요! 📈 "벌써 절반 이상 달성!" ${inputAmount > 0 ? '오늘도 ${_formatNumber(inputAmount)}원 저축했어요.' : ''} 이 속도라면 목표 달성은 시간문제예요!';
      } else {
        aiContent =
            '${emotionName}가 저축을 시작하며 희망차게 말해요! ✨ "목표를 향해 첫 걸음!" ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원 저축했어요.' : ''} 작은 시작이지만 큰 꿈을 향해 나아가고 있어요!';
      }
    } else {
      // 기본 감정별 메시지
      if (selectedEmotion == 'joy') {
        aiContent =
            '${emotionName}가 기쁘게 말해요! 😊 "목표를 향해 한 걸음씩!" ${progressPercentage}% 달성한 지금, ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원을 더했어요!' : ''} 이런 기쁨이 계속되길 바라요!';
      } else if (selectedEmotion == 'fear') {
        aiContent =
            '${emotionName}가 조심스럽게 말해요... 😰 "목표 달성할 수 있을까?" ${progressPercentage}% 진행했지만 ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원을 추가했어요.' : ''} 불안하더라도 계속 나아가는 것이 중요해요!';
      } else {
        aiContent =
            '${emotionName}와 함께 목표를 향해 나아가고 있어요! ✨ ${progressPercentage}% 달성한 지금, ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원을 더했어요!' : ''} 꾸준한 노력이 성공의 비결이에요!';
      }
    }

    setState(() {
      content = aiContent;
      _diaryController.text = aiContent;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI가 타임캡슐 스토리를 생성했습니다! ✨'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
