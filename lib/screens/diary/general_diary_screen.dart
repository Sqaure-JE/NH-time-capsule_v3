import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/emotion_character.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';
import 'general_diary_list_screen.dart';

class GeneralDiaryScreen extends StatefulWidget {
  const GeneralDiaryScreen({super.key});

  @override
  State<GeneralDiaryScreen> createState() => _GeneralDiaryScreenState();
}

class _GeneralDiaryScreenState extends State<GeneralDiaryScreen> {
  String selectedEmotion = '';
  String transactionType = 'expense';
  String amount = '';
  String category = '';
  String content = '';
  File? selectedImage;

  // 샘플 자동 연동 내역
  final List<Map<String, String>> todayTransactions = [
    {
      'name': '스타벅스 강남점',
      'amount': '-5,600',
      'type': 'expense',
      'category': '식비',
    },
    {
      'name': '급여 입금',
      'amount': '+2,450,000',
      'type': 'income',
      'category': '급여',
    },
    {'name': '지하철', 'amount': '-1,400', 'type': 'expense', 'category': '교통비'},
  ];

  // 감정 캐릭터
  final List<Map<String, dynamic>> emotions = [
    {'id': 'joy', 'emoji': '😊', 'name': '기쁨이', 'color': NHColors.joy},
    {'id': 'sadness', 'emoji': '😢', 'name': '슬픔이', 'color': NHColors.sadness},
    {'id': 'anger', 'emoji': '😡', 'name': '분노', 'color': NHColors.anger},
    {'id': 'fear', 'emoji': '😰', 'name': '불안이', 'color': NHColors.fear},
    {'id': 'disgust', 'emoji': '🤢', 'name': '까칠이', 'color': NHColors.disgust},
  ];

  // 카테고리
  final List<Map<String, String>> expenseCategories = [
    {'id': 'food', 'name': '식비', 'emoji': '🍽️'},
    {'id': 'transport', 'name': '교통비', 'emoji': '🚗'},
    {'id': 'shopping', 'name': '쇼핑', 'emoji': '🛍️'},
    {'id': 'entertainment', 'name': '여가', 'emoji': '🎮'},
    {'id': 'medical', 'name': '의료비', 'emoji': '🏥'},
    {'id': 'education', 'name': '교육', 'emoji': '📚'},
    {'id': 'other', 'name': '기타', 'emoji': '💫'},
  ];
  final List<Map<String, String>> incomeCategories = [
    {'id': 'salary', 'name': '급여', 'emoji': '💼'},
    {'id': 'allowance', 'name': '용돈', 'emoji': '💝'},
    {'id': 'investment', 'name': '투자수익', 'emoji': '📈'},
    {'id': 'side', 'name': '부업', 'emoji': '💻'},
    {'id': 'other', 'name': '기타', 'emoji': '💫'},
  ];

  int get points => 30 + (selectedImage != null ? 15 : 0);

  @override
  Widget build(BuildContext context) {
    final selectedEmotionData = emotions.firstWhere(
      (e) => e['id'] == selectedEmotion,
      orElse: () => {},
    );
    final currentCategories = transactionType == 'expense'
        ? expenseCategories
        : incomeCategories;

    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NHHeaderWidget(
              title: '일반 금융일기',
              subtitle: '',
              showBackButton: true,
              showHomeButton: false,
              showNotificationButton: false,
              actions: [
                IconButton(
                  onPressed: () {
                    _showMonthlyDiaries();
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    color: NHColors.primary,
                  ),
                  tooltip: '월간 일기 보기',
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    _buildAutoTransactions(),
                    const SizedBox(height: 16),
                    _buildEmotionSelector(selectedEmotionData),
                    const SizedBox(height: 16),
                    _buildManualRecord(currentCategories),
                    const SizedBox(height: 16),
                    _buildDiaryInput(selectedEmotionData),
                    const SizedBox(height: 16),
                    _buildImageInput(),
                    const SizedBox(height: 16),
                    _buildPointInfo(),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoTransactions() {
    int totalIncome = 2450000;
    int totalExpense = 7000;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '💳 오늘의 자동 연동 내역',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: NHColors.gray800,
                ),
              ),
              Text(
                '실시간 연동',
                style: TextStyle(fontSize: 12, color: NHColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...todayTransactions.map(
            (tx) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: tx['type'] == 'income'
                              ? NHColors.blue.withOpacity(0.2)
                              : NHColors.anger.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            tx['type'] == 'income' ? '↓' : '↑',
                            style: TextStyle(
                              color: tx['type'] == 'income'
                                  ? NHColors.blue
                                  : NHColors.anger,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx['name']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: NHColors.gray800,
                            ),
                          ),
                          Text(
                            tx['category']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: NHColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${tx['amount']}원',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: tx['type'] == 'income'
                          ? NHColors.blue
                          : NHColors.anger,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘 총 수입',
                style: TextStyle(fontSize: 13, color: NHColors.gray600),
              ),
              Text(
                '+2,450,000원',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: NHColors.blue,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘 총 지출',
                style: TextStyle(fontSize: 13, color: NHColors.gray600),
              ),
              Text(
                '-7,000원',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: NHColors.anger,
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
            '🎭 오늘 돈 관리하면서 든 기분',
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
                '${selectedEmotionData['name']}와 함께 솔직한 금융 감정을 기록해보세요!',
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

  Widget _buildManualRecord(List<Map<String, String>> currentCategories) {
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
            '✏️ 수동으로 추가 기록',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '현금 사용이나 미연동 카드 내역을 직접 입력하세요',
            style: TextStyle(fontSize: 12, color: NHColors.gray500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      transactionType = 'expense';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: transactionType == 'expense'
                          ? NHColors.anger.withOpacity(0.08)
                          : NHColors.gray50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: transactionType == 'expense'
                            ? NHColors.anger
                            : NHColors.gray200,
                        width: transactionType == 'expense' ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.trending_down,
                          color: NHColors.anger,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '지출',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      transactionType = 'income';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: transactionType == 'income'
                          ? NHColors.blue.withOpacity(0.08)
                          : NHColors.gray50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: transactionType == 'income'
                            ? NHColors.blue
                            : NHColors.gray200,
                        width: transactionType == 'income' ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.trending_up, color: NHColors.blue, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '수입',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '카테고리',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: NHColors.gray700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: currentCategories.map((cat) {
              final isSelected = category == cat['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      category = cat['id']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                        Text(
                          cat['emoji']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cat['name']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      amount = _formatAmount(value.replaceAll(',', ''));
                    });
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: '금액을 입력하세요',
                    border: OutlineInputBorder(),
                    suffixText: '원',
                  ),
                ),
              ),
            ],
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
                '📝 오늘의 금융 생각',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: NHColors.gray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              setState(() {
                content = value;
              });
            },
            maxLines: 4,
            decoration: InputDecoration(
              hintText: selectedEmotionData.isNotEmpty
                  ? '${selectedEmotionData['name']}와 함께 오늘의 돈 관리에 대한 솔직한 생각을 적어보세요...'
                  : '오늘의 소비, 수입, 저축에 대한 생각을 자유롭게 적어보세요...',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '💡 예시: "오늘 커피값이 아까웠는데 기분전환에 도움됐어", "급여 들어와서 기뻤지만 곧 나갈 돈 생각하니 불안해"',
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
            '📸 오늘의 금융 사진',
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
              height: 90,
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
                          '영수증, 통장 사진 추가',
                          style: TextStyle(
                            fontSize: 13,
                            color: NHColors.gray500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+15P 추가 적립',
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

  Widget _buildPointInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: NHColors.gradientBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: NHColors.blue, size: 22),
              SizedBox(width: 8),
              Text(
                '예상 적립 포인트',
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
                '$points P',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: NHColors.blue,
                ),
              ),
              Text(
                '기본 30P${selectedImage != null ? ' + 사진 15P' : ''}',
                style: const TextStyle(fontSize: 12, color: NHColors.gray600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
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
                    ? NHColors.blue
                    : NHColors.gray300,
              ),
              child: const Text(
                '일반 일기 저장 💭',
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
        title: const Text('💾 금융일기 저장 완료!'),
        content: Text('${selectedEmotionData['name']}와 함께 $points P 적립!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 200), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GeneralDiaryListScreen(),
                  ),
                );
              });
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

  String _formatAmount(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value);
    if (number == null) return value;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showMonthlyDiaries() {
    // 샘플 월간 일기 데이터
    final monthlyDiaries = [
      {
        'date': '2025년 1월',
        'diaries': [
          {
            'date': '1월 15일',
            'emotion': '😊',
            'emotionName': '기쁨이',
            'amount': '15,000',
            'type': 'expense',
            'category': '식비',
            'content': '오늘은 친구들과 맛있는 점심을 먹었어요. 기분이 좋았습니다!',
            'points': 45,
          },
          {
            'date': '1월 18일',
            'emotion': '😢',
            'emotionName': '슬픔이',
            'amount': '50,000',
            'type': 'expense',
            'category': '쇼핑',
            'content': '예상보다 많은 돈을 써서 속상했어요. 다음엔 더 신중하게 써야겠어요.',
            'points': 30,
          },
          {
            'date': '1월 22일',
            'emotion': '😊',
            'emotionName': '기쁨이',
            'amount': '2,450,000',
            'type': 'income',
            'category': '급여',
            'content': '월급이 들어왔어요! 이번 달도 열심히 일한 보람이 있네요.',
            'points': 45,
          },
        ],
      },
      {
        'date': '2025년 2월',
        'diaries': [
          {
            'date': '2월 3일',
            'emotion': '😡',
            'emotionName': '분노',
            'amount': '8,000',
            'type': 'expense',
            'category': '교통비',
            'content': '택시 요금이 너무 비싸서 화가 났어요. 다음엔 대중교통을 이용해야겠어요.',
            'points': 30,
          },
          {
            'date': '2월 10일',
            'emotion': '😰',
            'emotionName': '불안이',
            'amount': '200,000',
            'type': 'expense',
            'category': '의료비',
            'content': '병원에 갔는데 생각보다 비용이 많이 나와서 걱정이 됐어요.',
            'points': 45,
          },
        ],
      },
    ];

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
                    '📅 월간 금융일기',
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
                '지난 달들의 금융일기를 확인해보세요\n💡 감정 변화와 소비 패턴을 한눈에 볼 수 있어요!',
                style: TextStyle(fontSize: 14, color: NHColors.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: monthlyDiaries
                        .map(
                          (month) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  month['date'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: NHColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...(month['diaries'] as List).map(
                                  (diary) => Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: NHColors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: NHColors.gray200,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              diary['date'] as String,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: NHColors.gray600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  diary['emotion'] as String,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  diary['emotionName']
                                                      as String,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: NHColors.gray600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    (diary['type'] as String) ==
                                                        'income'
                                                    ? NHColors.blue.withOpacity(
                                                        0.1,
                                                      )
                                                    : NHColors.anger
                                                          .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '${(diary['type'] as String) == 'income' ? '+' : '-'}${diary['amount']}원',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      (diary['type']
                                                              as String) ==
                                                          'income'
                                                      ? NHColors.blue
                                                      : NHColors.anger,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              diary['category'] as String,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: NHColors.gray600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${diary['points']}P',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: NHColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          diary['content'] as String,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: NHColors.gray700,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
}
