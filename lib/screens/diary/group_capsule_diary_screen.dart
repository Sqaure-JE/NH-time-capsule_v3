import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';
import '../../models/time_capsule.dart';

class GroupCapsuleDiaryScreen extends StatefulWidget {
  final TimeCapsule capsule;
  const GroupCapsuleDiaryScreen({super.key, required this.capsule});

  @override
  State<GroupCapsuleDiaryScreen> createState() =>
      _GroupCapsuleDiaryScreenState();
}

class _GroupCapsuleDiaryScreenState extends State<GroupCapsuleDiaryScreen> {
  String transactionType = 'contribution';
  String amount = '';
  String description = '';
  String category = '';
  File? selectedReceipt;
  String splitMethod = 'equal';
  List<String> selectedMembers = [];

  // 현재 캡슐 정보를 동적으로 가져오기
  Map<String, dynamic> get currentGroupCapsule => {
    'id': widget.capsule.id,
    'title': widget.capsule.title,
    'category': widget.capsule.category,
    'totalTarget': widget.capsule.targetAmount,
    'currentTotal': widget.capsule.currentAmount,
    'progress': widget.capsule.progressPercentage,
    'daysLeft': widget.capsule.daysLeft,
    'memberCount': widget.capsule.memberIds.length,
    'myContribution':
        (widget.capsule.currentAmount / widget.capsule.memberIds.length)
            .round(),
    'startDate': widget.capsule.startDate.toString().substring(0, 10),
    'endDate': widget.capsule.endDate.toString().substring(0, 10),
  };
  List<Map<String, dynamic>> get members {
    final memberContribution =
        (widget.capsule.currentAmount / widget.capsule.memberIds.length)
            .round();
    final percentage = 100.0 / widget.capsule.memberIds.length;

    return widget.capsule.memberIds.asMap().entries.map((entry) {
      final index = entry.key;
      final name = entry.value;
      final avatars = ['👤', '👩', '👨', '👩‍🦱'];

      return {
        'id': 'member$index',
        'name': name,
        'contribution': memberContribution,
        'percentage': percentage,
        'avatar': avatars[index % avatars.length],
        'isMe': name == '김올리',
      };
    }).toList();
  }

  final List<Map<String, String>> transactionTypes = [
    {
      'id': 'contribution',
      'name': '개인 기여',
      'icon': '💰',
      'desc': '각자 목표 금액에 추가',
    },
    {'id': 'expense', 'name': '공동 지출', 'icon': '🛒', 'desc': '모임 관련 비용 지출'},
    {'id': 'refund', 'name': '환급/정산', 'icon': '↩️', 'desc': '비용 되돌려받기'},
  ];

  final Map<String, List<Map<String, String>>> categories = {
    'contribution': [
      {'id': 'monthly', 'name': '정기 적립', 'emoji': '📅'},
      {'id': 'bonus', 'name': '보너스 추가', 'emoji': '🎁'},
      {'id': 'extra', 'name': '임시 추가', 'emoji': '💪'},
    ],
    'expense': [
      {'id': 'booking', 'name': '예약금', 'emoji': '🏨'},
      {'id': 'transport', 'name': '교통비', 'emoji': '✈️'},
      {'id': 'activity', 'name': '액티비티', 'emoji': '🎢'},
      {'id': 'meal', 'name': '식비', 'emoji': '🍽️'},
      {'id': 'shopping', 'name': '쇼핑', 'emoji': '🛍️'},
      {'id': 'other', 'name': '기타', 'emoji': '📝'},
    ],
    'refund': [
      {'id': 'cancel', 'name': '취소 환급', 'emoji': '❌'},
      {'id': 'overpay', 'name': '초과 지불', 'emoji': '💸'},
      {'id': 'settle', 'name': '정산', 'emoji': '⚖️'},
    ],
  };

  final List<Map<String, String>> splitMethods = [
    {'id': 'equal', 'name': '균등 분할', 'desc': '모든 멤버가 동일하게'},
    {'id': 'custom', 'name': '개별 설정', 'desc': '멤버별 다른 금액'},
    {'id': 'exclude', 'name': '일부만', 'desc': '참여한 멤버만'},
  ];

  int get points =>
      25 +
      (selectedReceipt != null ? 15 : 0) +
      (transactionType == 'expense' ? 10 : 0);

  @override
  Widget build(BuildContext context) {
    final currentCategories = categories[transactionType] ?? [];
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NHHeaderWidget(
              title: widget.capsule.title,
              subtitle: '',
              showBackButton: true,
              showHomeButton: false,
              showNotificationButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    _buildCapsuleStatus(),
                    const SizedBox(height: 16),
                    _buildMemberContributions(),
                    const SizedBox(height: 16),
                    _buildTransactionTypeSelector(),
                    const SizedBox(height: 16),
                    _buildCategorySelector(currentCategories),
                    const SizedBox(height: 16),
                    _buildAmountInput(),
                    const SizedBox(height: 16),
                    _buildSplitMethodSelector(),
                    const SizedBox(height: 16),
                    _buildReceiptInput(),
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

  Widget _buildCapsuleStatus() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: NHColors.gradientBlue,
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
                  '👥 ${widget.capsule.memberIds.length}명',
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
                '전체 진행률',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                '${widget.capsule.progressPercentage.round()}%',
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
                width: widget.capsule.progressPercentage * 2.5,
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
                '${_formatNumber(widget.capsule.currentAmount)}원',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                '목표: ${_formatNumber(widget.capsule.targetAmount)}원',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberContributions() {
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
            children: [
              const Text(
                '👥 멤버별 기여도',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: NHColors.gray800,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '상세보기',
                  style: TextStyle(color: NHColors.blue, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...members.map(
            (member) => Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: member['isMe']
                    ? NHColors.blue.withOpacity(0.08)
                    : NHColors.gray50,
                borderRadius: BorderRadius.circular(10),
                border: member['isMe']
                    ? Border.all(color: NHColors.blue, width: 1)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        member['avatar'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${member['name']}${member['isMe'] ? ' (나)' : ''}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${member['percentage']}%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: NHColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${_formatNumber(member['contribution'])}원',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: NHColors.gray800,
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

  Widget _buildTransactionTypeSelector() {
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
            '📝 어떤 기록인가요?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: transactionTypes.map((type) {
              final isSelected = transactionType == type['id'];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      transactionType = type['id']!;
                      category = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? NHColors.blue.withOpacity(0.12)
                          : NHColors.gray50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? NHColors.blue : NHColors.gray200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          type['icon']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['name']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              type['desc']!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: NHColors.gray500,
                              ),
                            ),
                          ],
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

  Widget _buildCategorySelector(List<Map<String, String>> currentCategories) {
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
            '카테고리',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
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
            '금액',
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
              hintText: '금액을 입력하세요',
              border: OutlineInputBorder(),
              suffixText: '원',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitMethodSelector() {
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
            '분할 방법',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: splitMethods.map((method) {
              final isSelected = splitMethod == method['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      splitMethod = method['id']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? NHColors.blue.withOpacity(0.12)
                          : NHColors.gray50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? NHColors.blue : NHColors.gray200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          method['name']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          method['desc']!,
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
        ],
      ),
    );
  }

  Widget _buildReceiptInput() {
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
            '영수증/증빙 사진',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickReceipt,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedReceipt != null
                      ? NHColors.primary
                      : NHColors.gray300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: selectedReceipt != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedReceipt!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.receipt_long,
                          size: 28,
                          color: NHColors.gray400,
                        ),
                        SizedBox(height: 6),
                        Text(
                          '영수증/증빙 사진 추가',
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
                '기본 25P${selectedReceipt != null ? ' + 영수증 15P' : ''}${transactionType == 'expense' ? ' + 공동지출 10P' : ''}',
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
              onPressed: amount.isNotEmpty ? _saveDiary : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: amount.isNotEmpty
                    ? NHColors.blue
                    : NHColors.gray300,
              ),
              child: const Text(
                '모임 기록 저장 💬',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDiary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💾 모임 기록 저장 완료!'),
        content: Text('모든 멤버에게 알림 발송\n$points P 적립!'),
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

  Future<void> _pickReceipt() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedReceipt = File(image.path);
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
}
