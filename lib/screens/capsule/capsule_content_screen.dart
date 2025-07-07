import 'package:flutter/material.dart';
import '../../models/time_capsule.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';

class CapsuleContentScreen extends StatefulWidget {
  final TimeCapsule capsule;

  const CapsuleContentScreen({super.key, required this.capsule});

  @override
  State<CapsuleContentScreen> createState() => _CapsuleContentScreenState();
}

class _CapsuleContentScreenState extends State<CapsuleContentScreen> {
  int selectedTabIndex = 0;

  // 상호작용 데이터 관리
  Map<int, Map<String, dynamic>> interactionData = {
    0: {
      'thumbsUp': 3,
      'heart': 2,
      'comments': ['정말 좋은 계획이네요! 기대됩니다.', '저도 참여하고 싶어요']
    },
    1: {
      'thumbsUp': 2,
      'heart': 4,
      'comments': ['KTX 예약 성공! 👍', '빨리 가고 싶다']
    },
    2: {
      'thumbsUp': 5,
      'heart': 3,
      'comments': ['바다뷰 최고!', '예약 잘했어요', '벌써 설렌다']
    },
    3: {
      'thumbsUp': 1,
      'heart': 2,
      'comments': ['맛집 리스트 감사해요!']
    },
    4: {
      'thumbsUp': 8,
      'heart': 6,
      'comments': ['축하해요! 🎉', '드디어 달성!', '부산여행 즐겨요', '대단해요']
    },
  };

  // 일기 데이터 (캡슐 타입에 따라 다름)
  List<Map<String, dynamic>> get diaryEntries {
    if (widget.capsule.type == CapsuleType.group) {
      // 모임형 캡슐 - 부산여행 데이터
      return [
        {
          'date': '2025.06.15',
          'emotion': '😊',
          'amount': 120000,
          'title': '부산여행 계획 시작',
          'content': '친구들과 함께 부산여행을 계획하기 시작했어요. KTX 예약부터 숙소까지 차근차근 준비해보겠습니다!',
          'photo': 'assets/images/모임형_타임캡슐1.png',
          'members': ['김올리', '박수빈', '이정은', '최민수'],
          'author': '김올리(나)',
        },
        {
          'date': '2025.08.05',
          'emotion': '😊',
          'amount': 480000,
          'title': 'KTX 예약 완료',
          'content':
              '부산행 KTX 왕복을 예약했어요! 4명이서 48만원으로 저렴하게 예약 성공! 해운대 바다가 벌써 그리워집니다.',
          'photo': null,
          'members': ['김올리', '박수빈', '이정은', '최민수'],
          'author': '박수빈',
        },
        {
          'date': '2025.08.20',
          'emotion': '😊',
          'amount': 600000,
          'title': '숙소 예약 완료',
          'content':
              '해운대 근처 숙소를 예약했어요! 바다가 보이는 방이라서 모두 기대하고 있어요. 2박3일 60만원으로 합리적이네요!',
          'photo': 'assets/images/모임형_타임캡슐2.png',
          'members': ['김올리', '박수빈'],
          'author': '이정은',
        },
        {
          'date': '2025.09.15',
          'emotion': '😊',
          'amount': 160000,
          'title': '부산 맛집 리스트 완성',
          'content':
              '국제시장 맛집들과 자갈치시장 회센터까지 리스트업 완료! 친구들과 함께 부산의 모든 맛을 경험해보겠어요.',
          'photo': null,
          'members': ['김올리', '이정은', '최민수'],
          'author': '최민수',
        },
        {
          'date': '2025.10.15',
          'emotion': '😊',
          'amount': 200000,
          'title': '부산여행 목표 달성!',
          'content':
              '드디어 부산여행 목표 금액 200만원을 달성했어요! 친구들과 함께 만든 추억은 정말 소중할 것 같아요. 출발만 남았네요!',
          'photo': 'assets/images/모임형_타임캡슐3.png',
          'members': ['김올리', '박수빈', '이정은', '최민수'],
          'author': '김올리(나)',
        },
      ];
    } else {
      // 개인형 캡슐 - 제주도 데이터
      return [
        {
          'date': '2025.01.15',
          'emotion': '😊',
          'amount': 50000,
          'title': '제주도 여행 첫 저축',
          'content': '오늘부터 제주도 여행을 위한 저축을 시작했어요. 매일 조금씩 모으면 꼭 갈 수 있을 거예요!',
          'photo': 'assets/images/개인형_타임캡슐1.png',
        },
        {
          'date': '2025.02.14',
          'emotion': '😰',
          'amount': 30000,
          'title': '발렌타인데이 절약',
          'content': '커플들이 많은 날이라 카페에 가지 않고 집에서 커피를 마셨어요. 제주도 카페 투어를 위해 절약!',
          'photo': null,
        },
        {
          'date': '2025.03.20',
          'emotion': '😊',
          'amount': 100000,
          'title': '부업 수입 추가',
          'content': '프리랜서 작업으로 10만원을 벌었어요. 제주도 숙박비에 추가할 수 있어서 기뻐요!',
          'photo': 'assets/images/개인형_타임캡슐2.png',
        },
        {
          'date': '2025.04.15',
          'emotion': '😊',
          'amount': 200000,
          'title': '목표 달성 가까워지기',
          'content': '이제 목표 금액의 80%를 달성했어요! 제주도 여행이 점점 현실이 되어가고 있어요.',
          'photo': null,
        },
        {
          'date': '2025.06.01',
          'emotion': '😊',
          'amount': 100000,
          'title': '목표 달성!',
          'content': '드디어 제주도 여행 목표 금액을 달성했어요! 이제 항공권을 예약할 수 있어요.',
          'photo': 'assets/images/개인형_타임캡슐3.png',
        },
      ];
    }
  }

  // 거래 내역 데이터 (캡슐 타입에 따라 다름)
  List<Map<String, dynamic>> get transactions {
    if (widget.capsule.type == CapsuleType.group) {
      // 모임형 캡슐 - 부산여행 거래내역
      return [
        {
          'date': '2025.06.15',
          'type': '입금',
          'amount': 120000,
          'description': '부산여행 계획 자금 (김올리)',
          'category': '개인기여',
          'member': '김올리(나)',
        },
        {
          'date': '2025.07.10',
          'type': '입금',
          'amount': 120000,
          'description': '부산여행 계획 자금 (박수빈)',
          'category': '개인기여',
          'member': '박수빈',
        },
        {
          'date': '2025.08.05',
          'type': '지출',
          'amount': 480000,
          'description': 'KTX 부산행 4인 왕복 예약',
          'category': '교통비',
          'member': '공동',
        },
        {
          'date': '2025.08.20',
          'type': '지출',
          'amount': 600000,
          'description': '해운대 숙소 예약 (2박3일)',
          'category': '숙박비',
          'member': '공동',
        },
        {
          'date': '2025.09.15',
          'type': '입금',
          'amount': 160000,
          'description': '부산여행 추가 자금 (이정은)',
          'category': '개인기여',
          'member': '이정은',
        },
        {
          'date': '2025.10.01',
          'type': '입금',
          'amount': 160000,
          'description': '부산여행 추가 자금 (최민수)',
          'category': '개인기여',
          'member': '최민수',
        },
        {
          'date': '2025.10.15',
          'type': '지출',
          'amount': 360000,
          'description': '부산여행 식비 및 관광비',
          'category': '여행비',
          'member': '공동',
        },
      ];
    } else {
      // 개인형 캡슐 - 제주도 거래내역
      return [
        {
          'date': '2025.01.15',
          'type': '입금',
          'amount': 50000,
          'description': '제주도 여행 저축',
          'category': '저축',
        },
        {
          'date': '2025.02.14',
          'type': '입금',
          'amount': 30000,
          'description': '발렌타인데이 절약',
          'category': '절약',
        },
        {
          'date': '2025.03.20',
          'type': '입금',
          'amount': 100000,
          'description': '부업 수입',
          'category': '수입',
        },
        {
          'date': '2025.04.15',
          'type': '입금',
          'amount': 200000,
          'description': '월급 절약',
          'category': '저축',
        },
        {
          'date': '2025.06.01',
          'type': '입금',
          'amount': 100000,
          'description': '목표 달성 추가 저축',
          'category': '저축',
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NHHeaderWidget(
              title: '타임캡슐 내용',
              subtitle:
                  widget.capsule.type == CapsuleType.personal ? '개인형' : '모임형',
              showBackButton: true,
              showHomeButton: false,
              showNotificationButton: false,
            ),

            // 탭 바
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              decoration: BoxDecoration(
                color: NHColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: NHColors.gray300.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildTabButton('작성 내용', 0),
                  _buildTabButton('거래 내역', 1),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 탭 콘텐츠
            Expanded(
              child: selectedTabIndex == 0
                  ? _buildDiaryContent()
                  : _buildTransactionContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? NHColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? NHColors.white : NHColors.gray600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiaryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.capsule.title} 일기',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NHColors.gray800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: NHColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${diaryEntries.length}개',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: NHColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 일기 목록
          ...diaryEntries.map((entry) => _buildDiaryEntry(entry)),
        ],
      ),
    );
  }

  Widget _buildDiaryEntry(Map<String, dynamic> entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Text(entry['emotion'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: NHColors.gray800,
                            ),
                          ),
                        ),
                        // 모임형인 경우 작성자 표시
                        if (widget.capsule.type == CapsuleType.group &&
                            entry['author'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: NHColors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              entry['author'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: NHColors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      entry['date'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: NHColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+${entry['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: NHColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 내용
          Text(
            entry['content'],
            style: const TextStyle(
              fontSize: 14,
              color: NHColors.gray700,
              height: 1.5,
            ),
          ),

          // 모임형 캡슐인 경우 참여 멤버 표시
          if (widget.capsule.type == CapsuleType.group &&
              entry['members'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: NHColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.group, size: 16, color: NHColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '참여멤버: ${(entry['members'] as List<String>).join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: NHColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 사진
          if (entry['photo'] != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                entry['photo'],
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ],

          // 모임형 캡슐인 경우 상호작용 버튼 추가
          if (widget.capsule.type == CapsuleType.group) ...[
            const SizedBox(height: 12),
            _buildInteractionButtons(diaryEntries.indexOf(entry)),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '전체 거래 내역',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: NHColors.gray800,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _downloadExcel,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('엑셀 다운로드'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NHColors.primary,
                  foregroundColor: NHColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 거래 내역 목록
          ...transactions.map(
            (transaction) => _buildTransactionEntry(transaction),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionEntry(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NHColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: NHColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 카테고리 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: NHColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: NHColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // 거래 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: NHColors.gray800,
                  ),
                ),
                Text(
                  transaction['date'],
                  style: const TextStyle(fontSize: 14, color: NHColors.gray600),
                ),
                // 모임형 캡슐인 경우 멤버 정보 표시
                if (widget.capsule.type == CapsuleType.group &&
                    transaction['member'] != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 12,
                        color: NHColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        transaction['member'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // 금액
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction['type'] == '지출' ? '-' : '+'}${transaction['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction['type'] == '지출'
                      ? NHColors.anger
                      : NHColors.primary,
                ),
              ),
              Text(
                transaction['category'],
                style: const TextStyle(fontSize: 12, color: NHColors.gray500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButtons(int entryIndex) {
    final data = interactionData[entryIndex] ??
        {'thumbsUp': 0, 'heart': 0, 'comments': <String>[]};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NHColors.gray50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildInteractionButton(
            icon: Icons.thumb_up,
            count: data['thumbsUp'],
            onTap: () => _handleThumbsUp(entryIndex),
            color: NHColors.blue,
          ),
          const SizedBox(width: 16),
          _buildInteractionButton(
            icon: Icons.favorite,
            count: data['heart'],
            onTap: () => _handleHeart(entryIndex),
            color: NHColors.anger,
          ),
          const SizedBox(width: 16),
          _buildInteractionButton(
            icon: Icons.chat_bubble_outline,
            count: (data['comments'] as List).length,
            onTap: () => _handleComment(entryIndex),
            color: NHColors.success,
          ),
          const Spacer(),
          if ((data['comments'] as List).isNotEmpty)
            TextButton(
              onPressed: () => _showComments(entryIndex),
              child: const Text(
                '댓글 보기',
                style: TextStyle(fontSize: 12, color: NHColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleThumbsUp(int entryIndex) {
    setState(() {
      interactionData[entryIndex] ??= {
        'thumbsUp': 0,
        'heart': 0,
        'comments': <String>[]
      };
      interactionData[entryIndex]!['thumbsUp']++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('👍 따봉을 눌렀습니다!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleHeart(int entryIndex) {
    setState(() {
      interactionData[entryIndex] ??= {
        'thumbsUp': 0,
        'heart': 0,
        'comments': <String>[]
      };
      interactionData[entryIndex]!['heart']++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❤️ 하트를 눌렀습니다!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleComment(int entryIndex) {
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
          ElevatedButton(
            onPressed: () {
              if (commentController.text.trim().isNotEmpty) {
                setState(() {
                  interactionData[entryIndex] ??= {
                    'thumbsUp': 0,
                    'heart': 0,
                    'comments': <String>[]
                  };
                  (interactionData[entryIndex]!['comments'] as List<String>)
                      .add(commentController.text.trim());
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('댓글이 작성되었습니다!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: const Text('작성'),
          ),
        ],
      ),
    );
  }

  void _showComments(int entryIndex) {
    final comments =
        interactionData[entryIndex]?['comments'] as List<String>? ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💬 댓글 목록'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                comments[index],
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _downloadExcel() {
    // 엑셀 다운로드 로직
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('엑셀 파일이 다운로드되었습니다.'),
        backgroundColor: NHColors.primary,
      ),
    );
  }
}
