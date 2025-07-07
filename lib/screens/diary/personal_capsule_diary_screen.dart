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

  // 이정표
  final List<Map<String, dynamic>> milestones = [
    {'id': 'saving', 'emoji': '💰', 'text': '저축했어요', 'bonus': 10},
    {'id': 'sacrifice', 'emoji': '🚫', 'text': '참았어요', 'bonus': 15},
    {'id': 'progress', 'emoji': '📈', 'text': '목표에 가까워졌어요', 'bonus': 20},
    {'id': 'challenge', 'emoji': '💪', 'text': '어려움을 극복했어요', 'bonus': 25},
  ];

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
    final progressToTarget = ((currentCapsule['currentAmount'] +
                (int.tryParse(amount.replaceAll(',', '')) ?? 0)) /
            currentCapsule['targetAmount']) *
        100;
    final remainingAmount = currentCapsule['targetAmount'] -
        currentCapsule['currentAmount'] -
        (int.tryParse(amount.replaceAll(',', '')) ?? 0);
    final avgPerDay = currentCapsule['daysLeft'] > 0
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
                  'D-${widget.capsule.daysLeft}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '현재 진행률',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                '${progressToTarget.round()}%',
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
                width: progressToTarget > 100
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
              Row(
                children: const [
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
            Text(
              '• 추억 사진 추가 +20P',
              style: const TextStyle(fontSize: 12, color: NHColors.gray800),
            ),
          if (milestonePoints > 0)
            Text(
              '• 이정표 +${milestonePoints}P',
              style: const TextStyle(fontSize: 12, color: NHColors.gray800),
            ),
          if (amountPoints > 0)
            Text(
              '• 금액 추가 기록 +15P',
              style: const TextStyle(fontSize: 12, color: NHColors.gray800),
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
    final progressPercentage = (currentAmount / targetAmount * 100).round();
    final emotionName = selectedEmotionData['name'];
    final inputAmount = int.tryParse(amount.replaceAll(',', '')) ?? 0;

    // 이정표별 AI 추천
    if (milestone == 'saving') {
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
    } else if (milestone == 'sacrifice') {
      if (selectedEmotion == 'joy') {
        aiContent =
            '${emotionName}가 뿌듯하게 말해요! 😊 "참는 것도 이제 습관이 됐어!" ${inputAmount > 0 ? '${_formatNumber(inputAmount)}원을 아껴서' : ''} 목표에 한 걸음 더 가까워졌어요. 이런 작은 절약이 모여 큰 성과를 만들어요!';
      } else if (selectedEmotion == 'sadness') {
        aiContent =
            '${emotionName}가 아쉬워하면서도 말해요... 😢 "참기 힘들지만 목표를 위해서!" ${inputAmount > 0 ? '${_formatNumber(inputAmount)}원을 아꼈지만' : ''} 때로는 포기하는 것도 용기가 필요해요. 조금만 더 힘내요!';
      } else {
        aiContent =
            '${emotionName}가 의지를 다지며 말해요! 💪 "목표를 위해 참을 수 있어!" ${inputAmount > 0 ? '${_formatNumber(inputAmount)}원을 절약했어요.' : ''} 이런 결단력이 성공의 열쇠예요!';
      }
    } else if (milestone == 'progress') {
      if (progressPercentage >= 90) {
        aiContent =
            '${emotionName}가 감격스럽게 외쳐요! 🎉 "드디어! 목표가 눈앞에!" 90%를 넘어선 지금, ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원을 더해서' : ''} 성공의 달콤함을 미리 맛보고 있어요!';
      } else if (progressPercentage >= 70) {
        aiContent =
            '${emotionName}가 자신감 넘치게 말해요! 🚀 "70% 돌파! 이제 진짜 보여!" ${inputAmount > 0 ? '오늘 ${_formatNumber(inputAmount)}원 추가로' : ''} 목표 달성이 현실이 되고 있어요!';
      } else {
        aiContent =
            '${emotionName}가 차근차근 말해요! 📊 "꾸준히 진행 중이야!" ${progressPercentage}% 달성했고, ${inputAmount > 0 ? '오늘도 ${_formatNumber(inputAmount)}원을 보탰어요.' : ''} 매일매일이 소중한 진전이에요!';
      }
    } else if (milestone == 'challenge') {
      aiContent =
          '${emotionName}가 당당하게 말해요! 💪 "어려움도 이겨냈어!" ${inputAmount > 0 ? '${_formatNumber(inputAmount)}원을 모으는 것이 쉽지 않았지만' : ''} 포기하지 않고 계속 도전한 자신이 정말 대단해요!';
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
