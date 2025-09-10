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
  File? selectedVideo;
  String? audioPath;
  bool isRecording = false;
  String splitMethod = 'equal';
  List<String> selectedMembers = [];
  String diaryContent = '';
  final TextEditingController _diaryController = TextEditingController();

  // 상호작용 데이터 (실제로는 서버에서 가져와야 함)
  final List<Map<String, dynamic>> diaryEntries = [
    {
      'id': '1',
      'member': '김올리',
      'avatar': '👤',
      'date': '2024-12-15',
      'type': 'contribution',
      'amount': 50000,
      'description': '이번 달 정기 적립 완료! 목표 달성까지 화이팅! 💪',
      'category': '정기 적립',
      'likes': 3,
      'isLiked': true,
      'hearts': 2,
      'isHearted': false,
      'comments': [
        {'member': '박수빈', 'content': '고생했어요! 👍', 'date': '2024-12-15'},
        {'member': '이정은', 'content': '다음 달도 파이팅!', 'date': '2024-12-15'},
      ],
    },
    {
      'id': '2',
      'member': '박수빈',
      'avatar': '👩',
      'date': '2024-12-14',
      'type': 'expense',
      'amount': -150000,
      'description': '숙소 예약금 지불했습니다. 호텔 위치가 정말 좋아요! 🏨',
      'category': '예약금',
      'likes': 5,
      'isLiked': false,
      'hearts': 4,
      'isHearted': true,
      'comments': [
        {'member': '김올리', 'content': '와! 정말 좋은 위치네요!', 'date': '2024-12-14'},
        {'member': '최민수', 'content': '기대되네요 😊', 'date': '2024-12-14'},
      ],
    },
    {
      'id': '3',
      'member': '이정은',
      'avatar': '👨',
      'date': '2024-12-13',
      'type': 'contribution',
      'amount': 75000,
      'description': '보너스로 추가 적립했어요! 목표에 한 걸음 더 가까워졌네요 🎯',
      'category': '보너스 추가',
      'likes': 7,
      'isLiked': true,
      'hearts': 6,
      'isHearted': true,
      'comments': [
        {'member': '김올리', 'content': '축하해요! 🎉', 'date': '2024-12-13'},
        {'member': '박수빈', 'content': '정말 대단해요!', 'date': '2024-12-13'},
        {'member': '최민수', 'content': '저도 보너스 받으면 추가할게요!', 'date': '2024-12-13'},
      ],
    },
  ];

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
                    _buildDiaryContentInput(),
                    const SizedBox(height: 16),
                    _buildPointInfo(),
                    const SizedBox(height: 16),
                    _buildDiaryList(),
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
            '📸 모임 추억',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '영수증, 사진, 동영상, 음성으로 모임 활동을 기록하세요',
            style: TextStyle(
              fontSize: 12,
              color: NHColors.gray500,
            ),
          ),
          const SizedBox(height: 12),

          // 버튼들
          Row(
            children: [
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.photo_library,
                  label: '갤러리',
                  subtitle: '+15P',
                  onTap: _pickReceiptFromGallery,
                  isSelected: selectedReceipt != null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.camera_alt,
                  label: '사진촬영',
                  subtitle: '+15P',
                  onTap: _takePhoto,
                  isSelected: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.videocam,
                  label: '동영상',
                  subtitle: '+20P',
                  onTap: _takeVideo,
                  isSelected: selectedVideo != null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMediaButton(
                  icon: isRecording ? Icons.stop : Icons.mic,
                  label: isRecording ? '녹음중' : '음성녹음',
                  subtitle: '+10P',
                  onTap: isRecording ? _stopRecording : _startRecording,
                  isSelected: audioPath != null,
                  isRecording: isRecording,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 미디어 미리보기
          if (selectedReceipt != null ||
              selectedVideo != null ||
              audioPath != null)
            Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(color: NHColors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildMediaPreview(),
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
                '기본 25P${selectedReceipt != null ? ' + 사진 15P' : ''}${selectedVideo != null ? ' + 동영상 20P' : ''}${audioPath != null ? ' + 음성 10P' : ''}${transactionType == 'expense' ? ' + 공동지출 10P' : ''}',
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
                backgroundColor:
                    amount.isNotEmpty ? NHColors.blue : NHColors.gray300,
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

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSelected,
    bool isRecording = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? NHColors.primary.withOpacity(0.1)
              : isRecording
                  ? NHColors.anger.withOpacity(0.1)
                  : NHColors.gray50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? NHColors.primary
                : isRecording
                    ? NHColors.anger
                    : NHColors.gray200,
            width: isSelected || isRecording ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? NHColors.primary
                  : isRecording
                      ? NHColors.anger
                      : NHColors.gray500,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? NHColors.primary
                    : isRecording
                        ? NHColors.anger
                        : NHColors.gray600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8,
                color: isSelected
                    ? NHColors.primary
                    : isRecording
                        ? NHColors.anger
                        : NHColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (selectedReceipt != null) {
      return Stack(
        children: [
          Image.file(
            selectedReceipt!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedReceipt = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (selectedVideo != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            color: NHColors.gray100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_outline,
                    size: 40, color: NHColors.primary),
                SizedBox(height: 4),
                Text('동영상 준비됨', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedVideo = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (audioPath != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            color: NHColors.gray100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.audiotrack, size: 40, color: NHColors.primary),
                SizedBox(height: 4),
                Text('음성 녹음 완료', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  audioPath = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Future<void> _pickReceiptFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedReceipt = File(image.path);
        selectedVideo = null; // 하나만 선택 가능
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedReceipt = File(image.path);
        selectedVideo = null; // 하나만 선택 가능
      });
    }
  }

  Future<void> _takeVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        selectedVideo = File(video.path);
        selectedReceipt = null; // 하나만 선택 가능
      });
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      isRecording = true;
    });

    // 시뮬레이션: 3초 후 자동 종료
    await Future.delayed(const Duration(seconds: 3));

    if (isRecording) {
      _stopRecording();
    }
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
      audioPath = 'recorded_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('음성 녹음이 완료되었습니다! 🎤'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 기존 _pickReceipt 메서드 제거를 위한 더미 메서드
  Future<void> _pickReceipt() async {
    _pickReceiptFromGallery();
  }

  Widget _buildDiaryList() {
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
            '📝 모임 기록',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 12),
          ...diaryEntries.map((entry) => _buildDiaryEntry(entry)),
        ],
      ),
    );
  }

  Widget _buildDiaryEntry(Map<String, dynamic> entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NHColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NHColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Text(entry['avatar'], style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry['member'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    entry['date'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: NHColors.gray500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: entry['type'] == 'contribution'
                      ? NHColors.blue.withOpacity(0.1)
                      : NHColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  entry['category'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: entry['type'] == 'contribution'
                        ? NHColors.blue
                        : NHColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 금액
          Text(
            '${entry['amount'] > 0 ? '+' : ''}${_formatNumber(entry['amount'])}원',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: entry['amount'] > 0 ? NHColors.blue : NHColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // 설명
          Text(
            entry['description'],
            style: const TextStyle(fontSize: 14, color: NHColors.gray700),
          ),
          const SizedBox(height: 12),

          // 상호작용 버튼
          Row(
            children: [
              _buildInteractionButton(
                icon:
                    entry['isLiked'] ? Icons.thumb_up : Icons.thumb_up_outlined,
                count: entry['likes'],
                isActive: entry['isLiked'],
                onTap: () => _handleThumbsUp(entry['id']),
              ),
              const SizedBox(width: 16),
              _buildInteractionButton(
                icon:
                    entry['isHearted'] ? Icons.favorite : Icons.favorite_border,
                count: entry['hearts'],
                isActive: entry['isHearted'],
                onTap: () => _handleHeart(entry['id']),
              ),
              const SizedBox(width: 16),
              _buildInteractionButton(
                icon: Icons.comment_outlined,
                count: entry['comments'].length,
                isActive: false,
                onTap: () => _handleComment(entry),
              ),
            ],
          ),

          // 댓글 목록
          if (entry['comments'].isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NHColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: entry['comments']
                    .map<Widget>(
                      (comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${comment['member']}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                comment['content'],
                                style: const TextStyle(fontSize: 12),
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
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? NHColors.primary : NHColors.gray500,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isActive ? NHColors.primary : NHColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleThumbsUp(String entryId) {
    setState(() {
      final entry = diaryEntries.firstWhere((e) => e['id'] == entryId);
      if (entry['isLiked']) {
        entry['likes']--;
        entry['isLiked'] = false;
      } else {
        entry['likes']++;
        entry['isLiked'] = true;
      }
    });
  }

  void _handleHeart(String entryId) {
    setState(() {
      final entry = diaryEntries.firstWhere((e) => e['id'] == entryId);
      if (entry['isHearted']) {
        entry['hearts']--;
        entry['isHearted'] = false;
      } else {
        entry['hearts']++;
        entry['isHearted'] = true;
      }
    });
  }

  void _handleComment(Map<String, dynamic> entry) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💬 댓글 작성'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: '댓글을 입력하세요...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                setState(() {
                  entry['comments'].add({
                    'member': '김올리',
                    'content': commentController.text,
                    'date': DateTime.now().toString().substring(0, 10),
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('작성'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryContentInput() {
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
              const Text(
                '📝 한 줄 기록',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: NHColors.gray800,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _generateAIContent,
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
            onChanged: (value) => setState(() => diaryContent = value),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '모임원들과 공유할 오늘의 기록을 남겨보세요...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '💡 예시: "숙소 예약 완료! 위치가 정말 좋네요 🏨", "이번 달 목표 달성! 다들 고생했어요 💪"',
            style: TextStyle(fontSize: 12, color: NHColors.gray500),
          ),
        ],
      ),
    );
  }

  void _generateAIContent() {
    String aiContent = '';
    final inputAmount = int.tryParse(amount.replaceAll(',', '')) ?? 0;

    if (transactionType == 'contribution') {
      if (inputAmount >= 1000000) {
        aiContent =
            '와! 정말 대박 기여에요! 💰 "이번에 ${_formatNumber(inputAmount)}원이나 넣었다고?!" 팀원들이 깜짝 놀라면서 감동받을 것 같아요. 목표 달성이 훨씬 빨라질 것 같아요! 🚀';
      } else if (inputAmount >= 500000) {
        aiContent =
            '엄청난 기여네요! 💪 "${_formatNumber(inputAmount)}원! 진짜 대단하다!" 팀원들이 환호성을 지를 것 같아요. 이런 적극적인 자세가 모임을 성공으로 이끄는 원동력이에요! 👏';
      } else if (inputAmount >= 100000) {
        aiContent =
            '꾸준한 기여 감사해요! 😊 "${_formatNumber(inputAmount)}원 추가했어요!" 작은 금액이라도 모이면 큰 힘이 되죠. 이런 성실함이 모임의 성공 비결이에요! ✨';
      } else {
        aiContent =
            '조금씩이라도 함께해주셔서 고마워요! 💝 "${_formatNumber(inputAmount)}원이지만 마음이 중요하죠!" 모든 기여가 소중하고 의미 있어요. 함께 목표를 달성해봐요! 🎯';
      }
    } else if (transactionType == 'expense') {
      if (category == 'booking') {
        aiContent =
            '예약 완료했어요! 🏨 "${_formatNumber(inputAmount)}원 지불했습니다." 드디어 구체적인 계획이 현실이 되고 있네요! 모임이 점점 기대되어요! 🎉';
      } else if (category == 'transport') {
        aiContent =
            '교통편 준비 완료! ✈️ "${_formatNumber(inputAmount)}원으로 이동 수단을 확보했어요!" 이제 진짜 여행 가는 기분이 나기 시작하네요! 설레어요! 😆';
      } else if (category == 'activity') {
        aiContent =
            '액티비티 예약했어요! 🎢 "${_formatNumber(inputAmount)}원이지만 추억은 priceless죠!" 함께 할 즐거운 시간을 생각하니 벌써 기대돼요! 🤩';
      } else {
        aiContent =
            '공동 지출 처리했어요! 💳 "${_formatNumber(inputAmount)}원 사용했습니다." 모임을 위한 투자라고 생각하니까 기분이 좋네요! 함께하는 시간이 소중해요! 💖';
      }
    } else if (transactionType == 'refund') {
      aiContent =
          '환급 처리 완료! ↩️ "${_formatNumber(inputAmount)}원 돌려받았어요!" 예상치 못한 보너스네요. 이 돈으로 더 재미있는 계획을 세워볼까요? 😄';
    }

    setState(() {
      diaryContent = aiContent;
      _diaryController.text = aiContent;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI가 모임 기록을 생성했습니다! ✨'),
        duration: Duration(seconds: 2),
      ),
    );
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
