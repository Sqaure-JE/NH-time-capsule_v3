import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';
import '../../models/time_capsule.dart';
import '../../utils/emotion_assets.dart';
import 'capsule_content_screen.dart';

class PersonalCapsuleOpenScreen extends StatefulWidget {
  final TimeCapsule capsule;
  const PersonalCapsuleOpenScreen({super.key, required this.capsule});

  @override
  State<PersonalCapsuleOpenScreen> createState() =>
      _PersonalCapsuleOpenScreenState();
}

class _PersonalCapsuleOpenScreenState extends State<PersonalCapsuleOpenScreen>
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
    if (currentStep < 2) {
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
            top: 100,
            right: 50,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            right: 80,
            child: Container(
              width: 80,
              height: 80,
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
                            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
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
                            '개인 타임캡슐이 열렸어요! 🎉',
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
                            '${capsule.period}간의 특별한 여정이 완성되었습니다',
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
          title: '타임캡슐 열기',
          subtitle: '개인형',
          showBackButton: true,
          showHomeButton: false,
          showNotificationButton: false,
        ),
        Container(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NHColors.primary.withOpacity(0.1),
                  NHColors.blue.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NHColors.primary.withOpacity(0.2),
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
                        color: NHColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: NHColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.article_outlined,
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
                            '작성 내용 확인하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NHColors.gray800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${capsule.period}간의 소중한 기록들을 확인해보세요',
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
                        color: NHColors.primary,
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
          child: AnimatedOpacity(
            opacity: animating ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildMainCharacter(),
                  const SizedBox(height: 20),
                  _buildAchievementStatus(),
                  const SizedBox(height: 20),
                  _buildHighlights(),
                  const SizedBox(height: 20),
                  _buildEmotionStats(),
                  const SizedBox(height: 20),
                  _buildAchievements(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
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
          '🎭 나의 감정 여정',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '캐릭터 친구들과 함께한 성장 스토리',
          style: TextStyle(fontSize: 16, color: NHColors.gray600),
        ),
      ],
    );
  }

  Widget _buildMainCharacter() {
    final mainEmotion = capsule.mainEmotion;
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
        children: [
          (EmotionAssets.pathByEmoji(mainEmotion.emoji) != null)
              ? Image.asset(
                  EmotionAssets.pathByEmoji(mainEmotion.emoji)!,
                  width: 48,
                  height: 48,
                )
              : Text(mainEmotion.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            '${mainEmotion.name} ${mainEmotion.growth}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '이 여정의 ${mainEmotion.percentage}%를 함께했어요!',
            style: const TextStyle(fontSize: 14, color: NHColors.gray600),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NHColors.joy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '레벨 성장',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: NHColors.gray800,
                      ),
                    ),
                    Text(
                      'Lv.${mainEmotion.level}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: NHColors.joy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: NHColors.joy.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      height: 12,
                      width: 200,
                      decoration: BoxDecoration(
                        color: NHColors.joy,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '다음 레벨까지 15% 남았어요!',
                  style: TextStyle(fontSize: 12, color: NHColors.gray600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementStatus() {
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
            '🎯 목표 달성 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('목표 금액', style: TextStyle(color: NHColors.gray600)),
              Text(
                '${_formatNumber(capsule.targetAmount)}원',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: NHColors.gray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최종 달성', style: TextStyle(color: NHColors.gray600)),
              Text(
                '${_formatNumber(capsule.currentAmount)}원',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: NHColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('달성률', style: TextStyle(color: NHColors.gray600)),
              Text(
                '${capsule.achievementRate}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: NHColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NHColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '+${_formatNumber(capsule.currentAmount - capsule.targetAmount)}원',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: NHColors.success,
                  ),
                ),
                const Text(
                  '목표 초과 달성! 🎉',
                  style: TextStyle(fontSize: 14, color: NHColors.success),
                ),
              ],
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
          ...capsule.personalHighlights.map<Widget>(
            (highlight) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  (EmotionAssets.pathByEmoji(highlight.emotion) != null)
                      ? Image.asset(
                          EmotionAssets.pathByEmoji(highlight.emotion)!,
                          width: 24,
                          height: 24,
                        )
                      : Text(highlight.emotion,
                          style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          highlight.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: NHColors.gray800,
                          ),
                        ),
                        Text(
                          highlight.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    highlight.amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: NHColors.success,
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

  Widget _buildEmotionStats() {
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
            '📊 감정 분포',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...capsule.emotionStats.map<Widget>(
            (stat) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(stat.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: NHColors.gray800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: NHColors.gray200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              height: 8,
                              width: (stat.percentage / 100) * 200,
                              decoration: BoxDecoration(
                                color: stat.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${stat.percentage}%',
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
            '🏆 성취 배지',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: capsule.personalAchievements
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
        content: const Text('인스타그램 스토리로 공유되었습니다!\n친구들에게 성취를 자랑해보세요!'),
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
        content: const Text('PDF 리포트가 다운로드되었습니다!\n상세한 분석 결과를 확인하세요!'),
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
