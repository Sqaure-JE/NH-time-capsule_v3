import 'package:flutter/material.dart';
import '../models/time_capsule.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as NHDateUtils;
import '../utils/number_formatter.dart';
import 'progress_bar_widget.dart';

class CapsuleCardWidget extends StatelessWidget {
  final TimeCapsule capsule;
  final VoidCallback? onTap;
  final bool showProgress;
  final bool showStatus;
  final bool isHighlighted;

  const CapsuleCardWidget({
    super.key,
    required this.capsule,
    this.onTap,
    this.showProgress = true,
    this.showStatus = true,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: NHColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: isHighlighted
              ? Border.all(color: NHColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: NHColors.gray200.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 영역
              Row(
                children: [
                  // 카테고리 아이콘
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        capsule.categoryIcon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 제목과 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capsule.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: capsule.isPersonal
                                    ? NHColors.blue.withOpacity(0.1)
                                    : NHColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                capsule.isPersonal ? '개인형' : '모임형',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: capsule.isPersonal
                                      ? NHColors.blue
                                      : NHColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${capsule.durationInMonths}개월',
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

                  // 상태 표시
                  if (showStatus) _buildStatusIndicator(),
                ],
              ),

              const SizedBox(height: 16),

              // 진행률 영역
              if (showProgress) ...[
                CapsuleProgressBar(
                  progress: capsule.progress,
                  currentAmount: capsule.currentAmount,
                  targetAmount: capsule.targetAmount,
                  showAmounts: true,
                  animate: true,
                ),
                const SizedBox(height: 12),
              ],

              // 하단 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 기록 정보
                  Row(
                    children: [
                      Icon(Icons.edit_note, size: 16, color: NHColors.gray500),
                      const SizedBox(width: 4),
                      Text(
                        '${capsule.recordCount}회',
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: NHColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${capsule.photoCount}장',
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                    ],
                  ),

                  // 남은 일수
                  Text(
                    NHDateUtils.DateUtils.formatDays(capsule.daysLeft),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: capsule.daysLeft <= 7
                          ? NHColors.error
                          : NHColors.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (capsule.isOpenable) {
      statusColor = NHColors.success;
      statusText = '열기 가능';
      statusIcon = Icons.lock_open;
    } else if (capsule.isExpired) {
      statusColor = NHColors.error;
      statusText = '만료';
      statusIcon = Icons.schedule;
    } else {
      statusColor = NHColors.info;
      statusText = '진행중';
      statusIcon = Icons.trending_up;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    const categoryColors = {
      'travel': NHColors.blue,
      'financial': NHColors.primary,
      'home': NHColors.fear,
      'lifestyle': NHColors.joy,
      'relationship': NHColors.anger,
      'other': NHColors.gray500,
    };
    return categoryColors[capsule.category] ?? NHColors.gray500;
  }
}

// 열기 가능한 캡슐 강조 카드
class OpenableCapsuleCard extends StatelessWidget {
  final TimeCapsule capsule;
  final VoidCallback? onTap;

  const OpenableCapsuleCard({super.key, required this.capsule, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: NHColors.gradientGreen,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: NHColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: NHColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.celebration,
                      color: NHColors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎉 목표 달성!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NHColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        capsule.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: NHColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 진행률
            CapsuleProgressBar(
              progress: 1.0,
              currentAmount: capsule.targetAmount,
              targetAmount: capsule.targetAmount,
              showAmounts: false,
              animate: true,
            ),

            const SizedBox(height: 16),

            // 액션 버튼
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: NHColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '타임캡슐 열기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NHColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 간단한 캡슐 카드 (목록용)
class SimpleCapsuleCard extends StatelessWidget {
  final TimeCapsule capsule;
  final VoidCallback? onTap;

  const SimpleCapsuleCard({super.key, required this.capsule, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: NHColors.white,
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          border: Border.all(color: NHColors.gray200),
        ),
        child: Row(
          children: [
            Text(capsule.categoryIcon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capsule.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${capsule.progressPercentage}% 완료',
                    style: const TextStyle(
                      fontSize: 12,
                      color: NHColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: NHColors.gray400, size: 20),
          ],
        ),
      ),
    );
  }
}
