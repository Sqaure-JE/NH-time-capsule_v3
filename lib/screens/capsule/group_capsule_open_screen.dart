import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';
import '../../models/time_capsule.dart';
import 'capsule_content_screen.dart';

class GroupCapsuleOpenScreen extends StatefulWidget {
  final TimeCapsule capsule;
  const GroupCapsuleOpenScreen({super.key, required this.capsule});

  @override
  State<GroupCapsuleOpenScreen> createState() => _GroupCapsuleOpenScreenState();
}

class _GroupCapsuleOpenScreenState extends State<GroupCapsuleOpenScreen>
    with TickerProviderStateMixin {
  int currentStep = 0;
  bool animating = false;
  bool showImages = false;
  late AnimationController _animationController;
  late TimeCapsule capsule;

  @override
  void initState() {
    super.initState();
    capsule = widget.capsule;
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _startOpeningSequence();
  }

  void _startOpeningSequence() {
    // 1초 후 자동으로 보물상자 열기
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && currentStep == 0) {
        setState(() {
          showImages = true;
        });
      }
    });

    // 3초 후 다음 단계로 이동
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && currentStep == 0) {
        setState(() {
          currentStep = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (currentStep < 1) {
      setState(() {
        animating = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            currentStep++;
            animating = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(child: currentStep == 0 ? _buildStep0() : _buildStep1()),
    );
  }

  Widget _buildStep0() {
    return Container(
      decoration: BoxDecoration(gradient: NHColors.gradientGreenBlue),
      child: Stack(
        children: [
          // 배경 장식 요소들
          Positioned(
            top: 120,
            left: 40,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 180,
            right: 60,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 50,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // 메인 콘텐츠
          Center(
            child: AnimatedOpacity(
              opacity: animating ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 보물상자 애니메이션
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showImages = !showImages;
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.9, end: 1.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.bounceOut,
                                      ),
                                    ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                        child: Container(
                          key: ValueKey<bool>(showImages),
                          width: 280,
                          height: 280,
                          child: showImages
                              ? Image.asset(
                                  'assets/images/treasure_box_open.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.card_giftcard,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/treasure_box_closed.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.brown,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.inventory,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // 따란! 텍스트
                    const Text(
                      '따란~',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '모임 타임캡슐이 열렸어요! 🎉',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: NHColors.gray800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            capsule.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: NHColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${capsule.memberCount}명이 함께한 특별한 여정이 완성되었습니다',
                            style: const TextStyle(
                              fontSize: 16,
                              color: NHColors.gray600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${capsule.startDate} ~ ${capsule.endDate}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: NHColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        NHHeaderWidget(
          title: '모임 타임캡슐 열기',
          subtitle: '모임형',
          showBackButton: true,
          showHomeButton: false,
          showNotificationButton: false,
        ),
        // 상단에 작성 내용 확인 버튼 추가
        Container(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NHColors.blue.withOpacity(0.1),
                  NHColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NHColors.blue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NHColors.blue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: NHColors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.groups_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '모임 기록 확인하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NHColors.gray800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '함께한 ${capsule.memberCount}명의 소중한 추억을 확인해보세요',
                            style: const TextStyle(
                              fontSize: 14,
                              color: NHColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: NHColors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _handleViewContent,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildCapsuleStatus(),
                const SizedBox(height: 20),
                _buildMemberContributions(),
                const SizedBox(height: 20),
                _buildExpenseBreakdown(),
                const SizedBox(height: 20),
                _buildHighlights(),
                const SizedBox(height: 20),
                _buildSettlementStatus(),
                const SizedBox(height: 20),
                _buildAchievements(),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          '👥 모임 성과',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '함께 달성한 특별한 여정',
          style: TextStyle(fontSize: 16, color: NHColors.gray600),
        ),
      ],
    );
  }

  Widget _buildCapsuleStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NHColors.gradientBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                capsule.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                  '👥 ${capsule.memberCount}명',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '전체 진행률',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '${capsule.achievementRate}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 12,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                height: 12,
                width: (capsule.achievementRate / 100) * 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatNumber(capsule.finalAmount)}원',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '목표: ${_formatNumber(capsule.targetAmount)}원',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberContributions() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            '👥 멤버별 기여도',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...capsule.members.map<Widget>(
            (member) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: member.isMe
                    ? NHColors.blue.withOpacity(0.1)
                    : NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: member.isMe
                    ? Border.all(color: NHColors.blue, width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  Text(member.avatar, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${member.name}${member.isMe ? ' (나)' : ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: NHColors.gray800,
                          ),
                        ),
                        Text(
                          '${member.percentage}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_formatNumber(member.contribution)}원',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
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

  Widget _buildExpenseBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            '💰 비용 구성 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...capsule.expenseBreakdown.map<Widget>(
            (expense) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      expense.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: NHColors.gray800,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: NHColors.gray200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: (expense.percentage / 100) * 200,
                          decoration: BoxDecoration(
                            color: NHColors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${_formatNumber(expense.amount)}원',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                        ),
                        Text(
                          '${expense.percentage}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
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

  Widget _buildHighlights() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            '✨ 여정의 하이라이트',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...capsule.highlights.map<Widget>(
            (highlight) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        highlight.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: NHColors.gray800,
                        ),
                      ),
                      Text(
                        highlight.amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: NHColors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        highlight.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                      Text(
                        highlight.members,
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NHColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NHColors.success.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: NHColors.success, size: 48),
          const SizedBox(height: 12),
          const Text(
            '정산 완료!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: NHColors.success,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '모든 멤버의 정산이 완료되었습니다.',
            style: TextStyle(fontSize: 14, color: NHColors.gray600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            '🏆 모임 성취',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: capsule.achievements
                .map<Widget>(
                  (achievement) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NHColors.gray50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            achievement.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: NHColors.gray800,
                            ),
                          ),
                          Text(
                            achievement.desc,
                            style: const TextStyle(
                              fontSize: 10,
                              color: NHColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _handleShare,
            icon: const Icon(Icons.share),
            label: const Text('공유'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: NHColors.blue),
              foregroundColor: NHColors.blue,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleDownload,
            icon: const Icon(Icons.download),
            label: const Text('PDF 다운로드'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: NHColors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _handleShare() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📱 공유하기'),
        content: const Text('모임 성과를 친구들에게 공유했습니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _handleDownload() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📄 PDF 다운로드'),
        content: const Text('모임 리포트 PDF가 다운로드되었습니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _handleViewContent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapsuleContentScreen(capsule: capsule),
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
