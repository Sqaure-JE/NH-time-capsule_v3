import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/time_capsule.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/number_formatter.dart';
import '../../widgets/nh_header_widget.dart';
import '../../widgets/progress_bar_widget.dart';

class CapsuleCreateScreen extends StatefulWidget {
  const CapsuleCreateScreen({super.key});

  @override
  State<CapsuleCreateScreen> createState() => _CapsuleCreateScreenState();
}

class _CapsuleCreateScreenState extends State<CapsuleCreateScreen> {
  int currentStep = 1;
  final ImagePicker _picker = ImagePicker();

  // 폼 데이터
  CapsuleType selectedType = CapsuleType.personal;
  String selectedCategory = '';
  String title = '';
  String targetAmount = '';
  String selectedPeriod = '';
  String firstMessage = '';
  File? selectedImage;
  String customCategory = '';

  // 멤버 선택 관련
  final List<String> allMembers = ['김올리', '박수빈', '이정은'];
  List<String> selectedMembers = [];

  // 유효성 검사
  bool get isStep1Valid =>
      selectedCategory.isNotEmpty &&
      title.isNotEmpty &&
      targetAmount.isNotEmpty &&
      selectedPeriod.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            _buildHeader(),

            // 진행률 바
            _buildProgressBar(),

            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: currentStep == 1 ? _buildStep1() : _buildStep2(),
              ),
            ),

            // 하단 버튼
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return NHHeaderWidget(
      title: '새 타임캡슐',
      subtitle: currentStep == 1 ? '기본 정보' : '첫 기록 (선택)',
      showBackButton: true,
      showHomeButton: false,
      showNotificationButton: false,
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: ProgressBarWidget(
        progress: currentStep / 2,
        height: 4,
        animate: true,
        showPercentage: false,
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        // 타입 선택
        _buildTypeSelection(),
        const SizedBox(height: 20),

        // 모임형일 때 인원 선택
        if (selectedType == CapsuleType.group) ...[
          _buildMemberSelection(),
          const SizedBox(height: 20),
        ],

        // 카테고리 선택
        _buildCategorySelection(),
        const SizedBox(height: 20),

        // 제목 입력
        _buildTitleInput(),
        const SizedBox(height: 20),

        // 목표 금액
        _buildTargetAmountInput(),
        const SizedBox(height: 20),

        // 기간 선택
        _buildPeriodSelection(),
        const SizedBox(height: 20),

        // 예상 리워드
        _buildRewardInfo(),
      ],
    );
  }

  Widget _buildTypeSelection() {
    return Container(
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
          const Text(
            '누구와 함께 하나요?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(
                  type: CapsuleType.personal,
                  icon: Icons.person,
                  title: '나 혼자',
                  subtitle: '개인 목표',
                  color: NHColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(
                  type: CapsuleType.group,
                  icon: Icons.people,
                  title: '함께',
                  subtitle: '모임 목표',
                  color: NHColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required CapsuleType type,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : NHColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? color : NHColors.gray200,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: isSelected ? color : NHColors.gray400),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : NHColors.gray800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color.withOpacity(0.8) : NHColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberSelection() {
    return Container(
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
          const Text(
            '함께할 멤버를 선택하세요',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...allMembers.map(
            (member) => CheckboxListTile(
              value: selectedMembers.contains(member),
              title: Text(member),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selectedMembers.add(member);
                  } else {
                    selectedMembers.remove(member);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection() {
    // 개인형/모임형에 따라 카테고리 분기
    final categories = selectedType == CapsuleType.personal
        ? AppConstants.personalCapsuleCategories
        : AppConstants.groupCapsuleCategories;
    return Container(
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
          Text(
            selectedType == CapsuleType.personal
                ? '무엇을 위한 타임캡슐인가요?'
                : '모임의 목적을 선택하세요!',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories.values.elementAt(index);
              final categoryId = categories.keys.elementAt(index);
              final isSelected = selectedCategory == categoryId;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = categoryId;
                    if (categoryId != 'other') customCategory = '';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(category['color'] as int).withOpacity(0.1)
                        : NHColors.white,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? Color(category['color'] as int)
                          : NHColors.gray200,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category['icon'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Color(category['color'] as int)
                              : NHColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (selectedCategory == 'other') ...[
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                setState(() {
                  customCategory = value;
                });
              },
              decoration: const InputDecoration(
                hintText: '직접 입력 (예: 동호회 회비, 가족여행 등)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: NHColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
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
          const Text(
            '타임캡슐 이름',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
            decoration: const InputDecoration(
              hintText: '예: 제주도 여행 자금 모으기',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: NHColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '💡 구체적인 목표가 성공률을 높여요!',
            style: TextStyle(fontSize: 12, color: NHColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetAmountInput() {
    final List<int> recommendedAmounts = [100000, 500000, 1000000, 5000000];
    return Container(
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
          const Text(
            '목표 금액',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: recommendedAmounts.map((amount) {
              final isSelected = targetAmount == amount.toString();
              return ChoiceChip(
                label: Text(NumberFormatter.formatCurrency(amount)),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    targetAmount = amount.toString();
                  });
                },
                selectedColor: NHColors.primary.withOpacity(0.15),
                backgroundColor: NHColors.gray50,
                labelStyle: TextStyle(
                  color: isSelected ? NHColors.primary : NHColors.gray700,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                targetAmount = value;
              });
            },
            decoration: const InputDecoration(
              hintText: '직접 입력 (숫자만)',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: NHColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelection() {
    return Container(
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
          const Text(
            '언제까지 모을까요?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: AppConstants.periodOptions.map((period) {
              final isSelected = selectedPeriod == period['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPeriod = period['id'] as String;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? NHColors.primary.withOpacity(0.1)
                          : NHColors.white,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      border: Border.all(
                        color: isSelected ? NHColors.primary : NHColors.gray200,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          period['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? NHColors.primary
                                : NHColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          period['desc'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? NHColors.primary.withOpacity(0.8)
                                : NHColors.gray500,
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

  Widget _buildRewardInfo() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: NHColors.gradientOrange,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: NHColors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '예상 적립 포인트',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: NHColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '생성 100P + 매일 기록 50P + 달성 보너스 200P',
                  style: TextStyle(fontSize: 12, color: NHColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        // 첫 기록 작성
        _buildFirstMessageInput(),
        const SizedBox(height: 20),

        // 사진 추가
        _buildImageUpload(),
        const SizedBox(height: 20),

        // 요약 정보
        _buildSummaryInfo(),
      ],
    );
  }

  Widget _buildFirstMessageInput() {
    return Container(
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
          Row(
            children: [
              const Text('😊', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '첫 번째 다짐을 남겨보세요',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: NHColors.gray800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) {
              setState(() {
                firstMessage = value;
              });
            },
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: '이 목표를 세운 이유나 각오를 자유롭게 적어보세요... (선택사항)',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: NHColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return Container(
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
          const Text(
            '사진 추가 (선택)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedImage != null
                      ? NHColors.primary
                      : NHColors.gray300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: NHColors.gray400,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '첫 추억 사진 추가',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: NHColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '+20P 추가 적립',
                          style: TextStyle(
                            fontSize: 12,
                            color: NHColors.gray400,
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

  Widget _buildSummaryInfo() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: NHColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 타임캡슐 요약',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('이름:', title),
          _buildSummaryRow('목표:', '$targetAmount원'),
          _buildSummaryRow('기간:', '$selectedPeriod개월'),
          _buildSummaryRow(
            '유형:',
            selectedType == CapsuleType.personal ? '개인형' : '모임형',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: NHColors.gray600),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: NHColors.gray800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        color: NHColors.white,
        border: Border(top: BorderSide(color: NHColors.gray200)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (currentStep == 2)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        currentStep = 1;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: NHColors.gray300),
                    ),
                    child: const Text(
                      '이전',
                      style: TextStyle(
                        color: NHColors.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (currentStep == 2) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: currentStep == 1
                      ? (isStep1Valid ? _nextStep : null)
                      : _createCapsule,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: currentStep == 1 && !isStep1Valid
                        ? NHColors.gray300
                        : NHColors.primary,
                  ),
                  child: Text(
                    currentStep == 1 ? '다음 단계' : '타임캡슐 만들기 🎉',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          if (currentStep == 2) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _createCapsule,
              child: const Text(
                '첫 기록 건너뛰고 만들기',
                style: TextStyle(color: NHColors.gray600, fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _nextStep() {
    setState(() {
      currentStep = 2;
    });
  }

  void _createCapsule() {
    // 타임캡슐 생성 로직
    final capsule = TimeCapsule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: selectedCategory,
      type: selectedType,
      targetAmount: int.tryParse(targetAmount.replaceAll(',', '')) ?? 0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(
        Duration(days: (int.tryParse(selectedPeriod) ?? 6) * 30),
      ),
      firstMessage: firstMessage.isNotEmpty ? firstMessage : null,
      firstImagePath: selectedImage?.path,
      createdAt: DateTime.now(),
      memberIds: selectedType == CapsuleType.group ? selectedMembers : [],
    );

    // 성공 메시지 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 타임캡슐 생성 완료!'),
        content: Text(
          '${capsule.title} 타임캡슐이 생성되었습니다!\n기본 100P + 첫 기록 50P 적립!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(capsule);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }
}
