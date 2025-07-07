import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ProgressBarWidget extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final bool animate;
  final Duration animationDuration;
  final BorderRadius? borderRadius;

  const ProgressBarWidget({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = false,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? NHColors.gray200;
    final progColor = progressColor ?? NHColors.primary;
    final radius = borderRadius ?? BorderRadius.circular(height / 2);

    Widget progressBar = Container(
      height: height,
      decoration: BoxDecoration(color: bgColor, borderRadius: radius),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: NHColors.gradientGreen,
            borderRadius: radius,
          ),
        ),
      ),
    );

    if (animate) {
      progressBar = TweenAnimationBuilder<double>(
        duration: animationDuration,
        tween: Tween(begin: 0.0, end: progress),
        builder: (context, value, child) {
          return Container(
            height: height,
            decoration: BoxDecoration(color: bgColor, borderRadius: radius),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: NHColors.gradientGreen,
                  borderRadius: radius,
                ),
              ),
            ),
          );
        },
      );
    }

    if (showPercentage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행률',
                style: TextStyle(
                  fontSize: height * 1.2,
                  color: NHColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: height * 1.2,
                  color: NHColors.gray700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          progressBar,
        ],
      );
    }

    return progressBar;
  }
}

// 타임캡슐 전용 진행률 바
class CapsuleProgressBar extends StatelessWidget {
  final double progress;
  final int currentAmount;
  final int targetAmount;
  final bool showAmounts;
  final bool animate;

  const CapsuleProgressBar({
    super.key,
    required this.progress,
    required this.currentAmount,
    required this.targetAmount,
    this.showAmounts = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAmounts) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '현재 금액',
                style: const TextStyle(fontSize: 12, color: NHColors.gray600),
              ),
              Text(
                '${_formatAmount(currentAmount)}원',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: NHColors.gray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ProgressBarWidget(
          progress: progress,
          height: 12,
          animate: animate,
          showPercentage: false,
        ),
        if (showAmounts) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행률',
                style: const TextStyle(fontSize: 12, color: NHColors.gray500),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: NHColors.gray700,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(0)}만';
    }
    return amount.toString();
  }
}

// 감정 캐릭터 경험치 진행률 바
class CharacterExpProgressBar extends StatelessWidget {
  final int currentExp;
  final int maxExp;
  final int level;
  final Color characterColor;
  final bool showDetails;

  const CharacterExpProgressBar({
    super.key,
    required this.currentExp,
    required this.maxExp,
    required this.level,
    required this.characterColor,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxExp > 0 ? currentExp / maxExp : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDetails) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lv.$level',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: characterColor,
                ),
              ),
              Text(
                '$currentExp/$maxExp',
                style: const TextStyle(fontSize: 12, color: NHColors.gray600),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: characterColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: characterColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        if (showDetails) ...[
          const SizedBox(height: 2),
          Text(
            '다음 레벨까지 ${maxExp - currentExp}EXP',
            style: TextStyle(fontSize: 10, color: NHColors.gray500),
          ),
        ],
      ],
    );
  }
}

// 원형 진행률 바
class CircularProgressBar extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final Widget? child;
  final bool animate;

  const CircularProgressBar({
    super.key,
    required this.progress,
    this.size = 60.0,
    this.strokeWidth = 4.0,
    this.backgroundColor,
    this.progressColor,
    this.child,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? NHColors.gray200;
    final progColor = progressColor ?? NHColors.primary;

    Widget progressWidget = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        strokeWidth: strokeWidth,
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(progColor),
      ),
    );

    if (animate) {
      progressWidget = TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: progress),
        builder: (context, value, child) {
          return SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progColor),
            ),
          );
        },
      );
    }

    if (child != null) {
      return Stack(
        alignment: Alignment.center,
        children: [progressWidget, child!],
      );
    }

    return progressWidget;
  }
}
