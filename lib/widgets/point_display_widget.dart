import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/number_formatter.dart';

class PointDisplayWidget extends StatelessWidget {
  final int points;
  final double? size;
  final bool showLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const PointDisplayWidget({
    super.key,
    required this.points,
    this.size,
    this.showLabel = true,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displaySize = size ?? 32.0;
    final bgColor = backgroundColor ?? NHColors.primary;
    final txtColor = textColor ?? NHColors.white;

    Widget pointWidget = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            NumberFormatter.formatPoints(points),
            style: TextStyle(
              fontSize: displaySize * 0.4,
              fontWeight: FontWeight.bold,
              color: txtColor,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      pointWidget = GestureDetector(onTap: onTap, child: pointWidget);
    }

    if (showLabel) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          pointWidget,
          const SizedBox(height: 4),
          Text(
            '포인트',
            style: TextStyle(
              fontSize: displaySize * 0.25,
              color: NHColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return pointWidget;
  }
}

// 큰 포인트 표시 위젯
class LargePointDisplayWidget extends StatelessWidget {
  final int points;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  const LargePointDisplayWidget({
    super.key,
    required this.points,
    this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 14,
                  color: NHColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  NumberFormatter.formatPoints(points),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: NHColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NHColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallBorderRadius,
                    ),
                  ),
                  child: const Text(
                    'P',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: NHColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(fontSize: 12, color: NHColors.gray500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 포인트 등급 표시 위젯
class PointGradeWidget extends StatelessWidget {
  final int points;
  final double size;

  const PointGradeWidget({super.key, required this.points, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final grade = _getGrade(points);
    final gradeInfo = _getGradeInfo(grade);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradeInfo['gradient'] as LinearGradient,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: gradeInfo['color']!.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          gradeInfo['emoji']!,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }

  String _getGrade(int points) {
    if (points >= 10000) return 'diamond';
    if (points >= 5000) return 'gold';
    if (points >= 2000) return 'silver';
    if (points >= 500) return 'bronze';
    return 'newbie';
  }

  Map<String, dynamic> _getGradeInfo(String grade) {
    switch (grade) {
      case 'diamond':
        return {
          'emoji': '💎',
          'color': const Color(0xFFB9F2FF),
          'gradient': const LinearGradient(
            colors: [Color(0xFFB9F2FF), Color(0xFF87CEEB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };
      case 'gold':
        return {
          'emoji': '🥇',
          'color': const Color(0xFFFFD700),
          'gradient': const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };
      case 'silver':
        return {
          'emoji': '🥈',
          'color': const Color(0xFFC0C0C0),
          'gradient': const LinearGradient(
            colors: [Color(0xFFC0C0C0), Color(0xFFA9A9A9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };
      case 'bronze':
        return {
          'emoji': '🥉',
          'color': const Color(0xFFCD7F32),
          'gradient': const LinearGradient(
            colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };
      default:
        return {
          'emoji': '🌱',
          'color': const Color(0xFF90EE90),
          'gradient': const LinearGradient(
            colors: [Color(0xFF90EE90), Color(0xFF32CD32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };
    }
  }
}

// 포인트 획득 애니메이션 위젯
class PointEarnedWidget extends StatefulWidget {
  final int points;
  final VoidCallback? onComplete;

  const PointEarnedWidget({super.key, required this.points, this.onComplete});

  @override
  State<PointEarnedWidget> createState() => _PointEarnedWidgetState();
}

class _PointEarnedWidgetState extends State<PointEarnedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -1),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: NHColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: NHColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: NHColors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '+${NumberFormatter.formatCurrency(widget.points)}P',
                      style: const TextStyle(
                        color: NHColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
