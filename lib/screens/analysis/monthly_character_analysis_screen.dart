import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/nh_header_widget.dart';

class MonthlyCharacterAnalysisScreen extends StatefulWidget {
  const MonthlyCharacterAnalysisScreen({super.key});

  @override
  State<MonthlyCharacterAnalysisScreen> createState() =>
      _MonthlyCharacterAnalysisScreenState();
}

class _MonthlyCharacterAnalysisScreenState
    extends State<MonthlyCharacterAnalysisScreen> {
  // 샘플 월간 분석 데이터 - 일반 금융일기 반영
  final Map<String, dynamic> analysisData = {
    'month': '2025년 9월',
    'totalDiaries': 28, // 일반 금융일기 작성 일수
    'totalPoints': 1850,
    'totalSpending': 2850000,
    'totalIncome': 3500000,
    'savingsRate': 18.5,
    'mainCharacter': {
      'emoji': '😊',
      'name': '기쁨이',
      'level': 7,
      'percentage': 42,
      'growth': '+1레벨',
      'color': NHColors.joy,
    },
    'characters': [
      {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 7,
        'percentage': 42,
        'color': NHColors.joy,
        'growth': '+1레벨',
        'description': '일반 금융일기에서 긍정적 소비와 저축 성취감을 많이 표현했어요',
      },
      {
        'emoji': '😰',
        'name': '불안이',
        'level': 4,
        'percentage': 28,
        'color': NHColors.fear,
        'growth': '+0레벨',
        'description': '예상치 못한 지출과 목표 달성에 대한 걱정이 많았어요',
      },
      {
        'emoji': '😢',
        'name': '슬픔이',
        'level': 3,
        'percentage': 18,
        'color': NHColors.sadness,
        'growth': '-1레벨',
        'description': '충동구매 후 후회하는 감정이 줄어들었어요',
      },
      {
        'emoji': '😡',
        'name': '분노',
        'level': 2,
        'percentage': 8,
        'color': NHColors.anger,
        'growth': '+0레벨',
        'description': '불필요한 수수료나 가격 인상에 대한 불만이 있었어요',
      },
      {
        'emoji': '🤢',
        'name': '까칠이',
        'level': 1,
        'percentage': 4,
        'color': NHColors.disgust,
        'growth': '+0레벨',
        'description': '과도한 마케팅이나 불합리한 상품에 대한 거부감이 적었어요',
      },
    ],
    'monthlyHighlights': [
      {
        'date': '9/3',
        'title': '카페 대신 집에서 커피',
        'emotion': '😊',
        'amount': '+15,000원',
        'category': '절약',
        'diary': '매일 아침 카페 대신 집에서 커피를 마셔서 한 달에 15만원 절약했어요!',
      },
      {
        'date': '9/12',
        'title': '부업 수입 첫 달성',
        'emotion': '😊',
        'amount': '+800,000원',
        'category': '수입',
        'diary': '온라인 강의 판매로 첫 부업 수입을 올렸어요. 정말 뿌듯해요!',
      },
      {
        'date': '9/18',
        'title': '예상치 못한 병원비',
        'emotion': '😰',
        'amount': '-120,000원',
        'category': '지출',
        'diary': '갑작스런 치과 치료비로 예산을 초과했어요. 비상금의 중요성을 깨달았어요.',
      },
      {
        'date': '9/25',
        'title': '목표 저축액 달성',
        'emotion': '😊',
        'amount': '+500,000원',
        'category': '저축',
        'diary': '이번 달 저축 목표 50만원을 달성했어요! 다음 달은 60만원 도전!',
      },
    ],
    'financialPatterns': [
      {'category': '식비', 'amount': 850000, 'percentage': 30, 'trend': '↓5%'},
      {'category': '교통비', 'amount': 320000, 'percentage': 11, 'trend': '↑2%'},
      {'category': '쇼핑', 'amount': 680000, 'percentage': 24, 'trend': '↓8%'},
      {'category': '문화생활', 'amount': 450000, 'percentage': 16, 'trend': '↑12%'},
      {'category': '기타', 'amount': 550000, 'percentage': 19, 'trend': '↓3%'},
    ],
    'spendingInsights': [
      {
        'title': '식비 절약 성공',
        'description': '집에서 요리하는 횟수가 늘어 식비가 5% 감소했어요',
        'emotion': '😊',
        'tip': '이 패턴을 유지하면 연간 60만원 절약 가능해요',
      },
      {
        'title': '문화생활 증가',
        'description': '영화, 공연 관람이 늘어 문화생활비가 12% 증가했어요',
        'emotion': '😊',
        'tip': '적정 수준의 문화생활은 삶의 질을 높여줘요',
      },
      {
        'title': '쇼핑 절약 성공',
        'description': '충동구매가 줄어 쇼핑비가 8% 감소했어요',
        'emotion': '😊',
        'tip': '구매 전 하루 더 생각하는 습관이 도움이 되었어요',
      },
    ],
    'aiRecommendations': [
      {
        'type': '저축상품',
        'name': 'NH올원 적금',
        'description': '기쁨이와 함께하는 안정적 저축',
        'rate': '3.5%',
        'reason': '꾸준한 저축 패턴을 보이고 있어 적금 상품이 적합해요',
        'icon': '🏦',
      },
      {
        'type': '투자상품',
        'name': 'NH투자증권 ETF',
        'description': '장기 목표를 위한 분산투자',
        'risk': '중간',
        'reason': '안정적인 소득이 있어 중위험 투자 상품을 고려해보세요',
        'icon': '📈',
      },
      {
        'type': '보험상품',
        'name': 'NH생명 종합보험',
        'description': '예상치 못한 의료비 대비',
        'coverage': '1억원',
        'reason': '병원비 지출이 있었던 점을 고려한 보장성 보험이에요',
        'icon': '🛡️',
      },
      {
        'type': '카드상품',
        'name': 'NH미미카드',
        'description': '아침을 먹는 사람들을 위한 아침 할인카드',
        'benefit': '오전 5~9시 음식점 50% 청구할인',
        'reason': '식비 절약 패턴을 보이고 있어 아침식사 할인 혜택이 도움될 것 같아요',
        'icon': '🌅',
      },
    ],
    // 일자별 감정 데이터 추가
    'dailyEmotions': [
      {'date': '9/1', 'emotion': '😊', 'description': '월급날! 저축 목표 달성 기쁨'},
      {'date': '9/2', 'emotion': '😊', 'description': '카페 대신 집에서 커피 마시며 절약'},
      {'date': '9/3', 'emotion': '😰', 'description': '예상치 못한 교통비 지출'},
      {'date': '9/4', 'emotion': '😊', 'description': '부업 수입 첫 달성'},
      {'date': '9/5', 'emotion': '😢', 'description': '충동구매 후 후회'},
      {'date': '9/6', 'emotion': '😊', 'description': '목표 저축액 달성'},
      {'date': '9/7', 'emotion': '😡', 'description': '불필요한 수수료 지출'},
      {'date': '9/8', 'emotion': '😊', 'description': '친구와 공동구매로 절약'},
      {'date': '9/9', 'emotion': '😰', 'description': '병원비 지출로 예산 초과'},
      {'date': '9/10', 'emotion': '🤢', 'description': '과도한 마케팅에 속아 구매'},
      {'date': '9/11', 'emotion': '😊', 'description': '투자 수익 첫 달성'},
      {'date': '9/12', 'emotion': '😢', 'description': '목표 달성 실패'},
      {'date': '9/13', 'emotion': '😰', 'description': '급여 지연으로 불안'},
      {'date': '9/14', 'emotion': '😊', 'description': '절약 습관 형성 기쁨'},
      {'date': '9/15', 'emotion': '😡', 'description': '가격 인상에 대한 분노'},
      {'date': '9/16', 'emotion': '😊', 'description': '문화생활비 절약 성공'},
      {'date': '9/17', 'emotion': '😊', 'description': '저축 목표 50% 달성'},
      {'date': '9/18', 'emotion': '😰', 'description': '예상치 못한 수리비'},
      {'date': '9/19', 'emotion': '😊', 'description': '투자 상품 수익률 상승'},
      {'date': '9/20', 'emotion': '😡', 'description': '부당한 요금 청구'},
      {'date': '9/21', 'emotion': '😰', 'description': '경제 불안으로 인한 걱정'},
      {'date': '9/22', 'emotion': '😊', 'description': '가족과 함께하는 저렴한 외식'},
      {'date': '9/23', 'emotion': '😢', 'description': '목표 달성 실패로 인한 슬픔'},
      {'date': '9/24', 'emotion': '😊', 'description': '새로운 절약 방법 발견'},
      {'date': '9/25', 'emotion': '😰', 'description': '급여 삭감 소식'},
      {'date': '9/26', 'emotion': '😊', 'description': '저축 목표 80% 달성'},
      {'date': '9/27', 'emotion': '🤢', 'description': '불합리한 상품 구매'},
      {'date': '9/28', 'emotion': '😰', 'description': '예산 초과 위기'},
      {'date': '9/29', 'emotion': '😡', 'description': '서비스 품질 저하'},
      {'date': '9/30', 'emotion': '😊', 'description': '월말 저축 목표 달성!'},
    ],
    'nextMonthGoals': [
      {'goal': '저축 목표', 'target': '600,000원', 'current': '500,000원'},
      {'goal': '기쁨이 레벨업', 'target': 'Lv.8', 'current': 'Lv.7'},
      {'goal': '일기 작성', 'target': '30일', 'current': '28일'},
      {'goal': '식비 절약', 'target': '800,000원', 'current': '850,000원'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NHHeaderWidget(
              title: '월간 캐릭터 분석',
              subtitle: analysisData['month'],
              showBackButton: true,
              showHomeButton: false,
              showNotificationButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildMainCharacter(),
                    const SizedBox(height: 20),
                    _buildCharacterGrowth(),
                    const SizedBox(height: 20),
                    _buildDailyEmotionCalendar(),
                    const SizedBox(height: 20),
                    _buildMonthlyHighlights(),
                    const SizedBox(height: 20),
                    _buildFinancialPatterns(),
                    const SizedBox(height: 20),
                    _buildAIRecommendations(),
                    const SizedBox(height: 20),
                    _buildNextMonthGoals(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          '📊 월간 캐릭터 분석',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '일반 금융일기를 바탕으로 한 감정 여정과 금융 패턴 분석',
          style: TextStyle(fontSize: 16, color: NHColors.gray600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: NHColors.gradientGreenBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        '일기 작성',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${analysisData['totalDiaries']}일',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '적립 포인트',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${analysisData['totalPoints']}P',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '저축률',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${analysisData['savingsRate']}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '이번 달 총 수입',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${_formatNumber(analysisData['totalIncome'])}원',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '이번 달 총 지출',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${_formatNumber(analysisData['totalSpending'])}원',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainCharacter() {
    final mainChar = analysisData['mainCharacter'];
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
          const Text(
            '🌟 이번 달의 주인공',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Text(mainChar['emoji'], style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            '${mainChar['name']} ${mainChar['growth']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '이번 달의 ${mainChar['percentage']}%를 함께했어요!',
            style: const TextStyle(fontSize: 14, color: NHColors.gray600),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: mainChar['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '레벨',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: NHColors.gray800,
                  ),
                ),
                Text(
                  'Lv.${mainChar['level']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainChar['color'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrowth() {
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
            '📈 캐릭터별 성장 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...analysisData['characters'].map<Widget>(
            (character) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    character['emoji'],
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${character['name']} ${character['growth']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: NHColors.gray800,
                          ),
                        ),
                        Text(
                          'Lv.${character['level']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${character['percentage']}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: NHColors.gray800,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 8,
                        decoration: BoxDecoration(
                          color: NHColors.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: character['percentage'] / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: character['color'],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
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

  Widget _buildMonthlyHighlights() {
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
            '✨ 일반 금융일기 하이라이트',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '이번 달 가장 인상 깊었던 금융 경험들',
            style: TextStyle(fontSize: 14, color: NHColors.gray600),
          ),
          const SizedBox(height: 16),
          ...analysisData['monthlyHighlights'].map<Widget>(
            (highlight) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getCategoryColor(
                    highlight['category'],
                  ).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(
                            highlight['category'],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          highlight['emotion'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              highlight['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: NHColors.gray800,
                              ),
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
                                    color: _getCategoryColor(
                                      highlight['category'],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    highlight['category'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  highlight['date'],
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
                      Text(
                        highlight['amount'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: highlight['amount'].startsWith('+')
                              ? NHColors.success
                              : NHColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      highlight['diary'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: NHColors.gray700,
                        height: 1.4,
                      ),
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case '수입':
        return NHColors.success;
      case '절약':
        return NHColors.blue;
      case '저축':
        return NHColors.primary;
      case '지출':
        return NHColors.warning;
      default:
        return NHColors.gray500;
    }
  }

  Widget _buildFinancialPatterns() {
    return Column(
      children: [
        Container(
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
                '💰 카테고리별 지출 분석',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: NHColors.gray800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '일반 금융일기를 통해 분석한 소비 패턴',
                style: TextStyle(fontSize: 14, color: NHColors.gray600),
              ),
              const SizedBox(height: 16),
              ...analysisData['financialPatterns'].map<Widget>(
                (pattern) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              pattern['category'],
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
                                  width: (pattern['percentage'] / 100) * 150,
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(
                                      pattern['category'],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '${_formatNumber(pattern['amount'])}원',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: NHColors.gray800,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: pattern['trend'].startsWith('↑')
                                  ? NHColors.error.withOpacity(0.1)
                                  : NHColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pattern['trend'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: pattern['trend'].startsWith('↑')
                                    ? NHColors.error
                                    : NHColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(width: 100),
                          Text(
                            '${pattern['percentage']}%',
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
        ),
        const SizedBox(height: 20),
        _buildSpendingInsights(),
      ],
    );
  }

  Widget _buildSpendingInsights() {
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
            '💡 소비 인사이트',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '금융일기를 통해 발견한 소비 패턴과 개선 포인트',
            style: TextStyle(fontSize: 14, color: NHColors.gray600),
          ),
          const SizedBox(height: 16),
          ...analysisData['spendingInsights'].map<Widget>(
            (insight) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NHColors.success.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        insight['emotion'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          insight['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: NHColors.gray800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: NHColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NHColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: NHColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            insight['tip'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: NHColors.success,
                              fontWeight: FontWeight.w500,
                            ),
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

  Widget _buildAIRecommendations() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: NHColors.gradientGreenBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: NHColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI 맞춤 금융상품 추천',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '금융일기 분석을 통한 개인화 추천',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...analysisData['aiRecommendations'].map<Widget>(
                (recommendation) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: NHColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              recommendation['icon'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recommendation['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: NHColors.gray800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: NHColors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    recommendation['type'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: NHColors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (recommendation['rate'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: NHColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                recommendation['rate'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: NHColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (recommendation['benefit'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: NHColors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                recommendation['benefit'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: NHColors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        recommendation['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: NHColors.gray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: NHColors.gray50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.psychology,
                              size: 16,
                              color: NHColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                recommendation['reason'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: NHColors.gray700,
                                ),
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
        ),
      ],
    );
  }

  Widget _buildNextMonthGoals() {
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
            '🎯 다음 달 목표',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...analysisData['nextMonthGoals'].map<Widget>(
            (goal) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal['goal'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: NHColors.gray800,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        goal['current'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.gray500,
                        ),
                      ),
                      const Text(
                        ' → ',
                        style: TextStyle(fontSize: 12, color: NHColors.gray500),
                      ),
                      Text(
                        goal['target'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: NHColors.blue,
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
        content: const Text('월간 분석 결과를 친구들과 공유했습니다!'),
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
        content: const Text('월간 분석 리포트 PDF가 다운로드되었습니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEmotionCalendar() {
    final dailyEmotions = analysisData['dailyEmotions'] as List<dynamic>;

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
            '📅 일자별 감정 여정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '매일 어떤 감정들이 있었는지 한눈에 확인해보세요',
            style: TextStyle(
              fontSize: 14,
              color: NHColors.gray600,
            ),
          ),
          const SizedBox(height: 16),

          // 감정 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemCount: dailyEmotions.length,
            itemBuilder: (context, index) {
              final emotion = dailyEmotions[index];
              return _buildEmotionDay(emotion);
            },
          ),

          const SizedBox(height: 16),

          // 감정 범례
          _buildEmotionLegend(),
        ],
      ),
    );
  }

  Widget _buildEmotionDay(Map<String, dynamic> emotion) {
    return GestureDetector(
      onTap: () => _showEmotionDetail(emotion),
      child: Container(
        decoration: BoxDecoration(
          color: _getEmotionColor(emotion['emotion']).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _getEmotionColor(emotion['emotion']).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emotion['date'].split('/')[1], // 날짜만 추출
              style: const TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w500,
                color: NHColors.gray800,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              emotion['emotion'],
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case '😊':
        return NHColors.joy;
      case '😰':
        return NHColors.fear;
      case '😢':
        return NHColors.sadness;
      case '😡':
        return NHColors.anger;
      case '🤢':
        return NHColors.disgust;
      default:
        return NHColors.gray400;
    }
  }

  void _showEmotionDetail(Map<String, dynamic> emotion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(emotion['emotion'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(emotion['date']),
          ],
        ),
        content: Text(emotion['description']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NHColors.gray50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정 범례',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: NHColors.gray700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _buildLegendItem('😊', '기쁨이'),
              _buildLegendItem('😰', '불안이'),
              _buildLegendItem('😢', '슬픔이'),
              _buildLegendItem('😡', '분노'),
              _buildLegendItem('🤢', '까칠이'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String emoji, String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 10,
            color: NHColors.gray600,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 100000000) {
      return '${(number / 100000000).toStringAsFixed(1)}억';
    } else if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(0)}만';
    } else {
      return number.toString();
    }
  }
}
