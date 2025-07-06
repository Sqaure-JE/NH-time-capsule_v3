import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class NHHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;
  final VoidCallback? onNotificationPressed;
  final bool showBackButton;
  final bool showHomeButton;
  final bool showNotificationButton;

  const NHHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.onBackPressed,
    this.onHomePressed,
    this.onNotificationPressed,
    this.showBackButton = true,
    this.showHomeButton = true,
    this.showNotificationButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NHColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 메인 헤더
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  // 뒤로가기 버튼
                  if (showBackButton)
                    IconButton(
                      onPressed:
                          onBackPressed ?? () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: NHColors.gray600,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),

                  // 제목 영역
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: NHColors.gray800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: NHColors.gray500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),

                  // 액션 버튼들
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showNotificationButton)
                        IconButton(
                          onPressed: onNotificationPressed,
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: NHColors.gray600,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      if (showHomeButton)
                        IconButton(
                          onPressed: onHomePressed,
                          icon: const Icon(
                            Icons.home_outlined,
                            color: NHColors.gray600,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ],
              ),
            ),

            // 탭 네비게이션 (선택사항)
            if (subtitle == null) _buildTabNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    const tabs = ['자산', '소비', '타임캡슐', '즐겨찾기', '전체'];
    const selectedTab = '타임캡슐'; // 기본 선택된 탭

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: NHColors.gray100, width: 1)),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                // 탭 변경 로직 (나중에 구현)
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.smallPadding,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? NHColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? NHColors.primary : NHColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// NH마이데이터 전용 헤더
class NHMyDataHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;
  final VoidCallback? onNotificationPressed;

  const NHMyDataHeader({
    super.key,
    this.onBackPressed,
    this.onHomePressed,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NHColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: Row(
            children: [
              // 뒤로가기 버튼
              IconButton(
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: NHColors.gray600,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),

              // NH마이데이터 이미지
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/my.jpg',
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 액션 버튼들
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onNotificationPressed,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: NHColors.gray600,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: onHomePressed,
                    icon: const Icon(
                      Icons.home_outlined,
                      color: NHColors.gray600,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
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
}

// 시간 표시 헤더
class TimeDisplayHeader extends StatelessWidget {
  final String time;
  final VoidCallback? onRefreshPressed;

  const TimeDisplayHeader({
    super.key,
    required this.time,
    this.onRefreshPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NHColors.gray100,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: NHColors.gray600),
          ),
          if (onRefreshPressed != null)
            GestureDetector(
              onTap: onRefreshPressed,
              child: const Icon(
                Icons.refresh,
                size: 16,
                color: NHColors.gray600,
              ),
            ),
        ],
      ),
    );
  }
}
