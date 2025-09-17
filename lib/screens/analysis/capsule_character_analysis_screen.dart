import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/emotion_assets.dart';
import '../../widgets/nh_header_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class CapsuleCharacterAnalysisScreen extends StatefulWidget {
  final String capsuleId;

  const CapsuleCharacterAnalysisScreen({super.key, required this.capsuleId});

  @override
  State<CapsuleCharacterAnalysisScreen> createState() =>
      _CapsuleCharacterAnalysisScreenState();
}

class _CapsuleCharacterAnalysisScreenState
    extends State<CapsuleCharacterAnalysisScreen> {
  // 타임캡슐 ID에 따른 분석 데이터 반환
  Map<String, dynamic> get analysisData {
    switch (widget.capsuleId) {
      // 홈 화면의 실제 ID에 맞춘 매칭
      case 'sample_1': // 제주도 여행 자금
        return _getJejuAnalysisData();
      case 'sample_2': // 친구들과 부산여행
        return _getBusanAnalysisData();
      case 'sample_3': // 골프 습관 일지
        return _getGolfHabitAnalysisData();
      case 'sample_4': // 내집마련
        return _getHouseAnalysisData();
      case 'sample_5': // 결혼기념일
        return _getAnniversaryAnalysisData();
      case 'capsule_running': // 러닝 습관
        return _getRunningAnalysisData();
      case 'capsule_reading': // 독서 습관
        return _getReadingAnalysisData();

      // 기존 ID들도 호환성을 위해 유지
      case 'capsule_1': // 다낭 여행 자금
        return _getDanangAnalysisData();
      case 'capsule_2': // 집 구매 자금
        return _getHouseAnalysisData();
      case 'capsule_3': // 결혼기념일 자금
        return _getAnniversaryAnalysisData();
      case 'capsule_4': // 제주도 여행 자금 (완료)
        return _getJejuAnalysisData();
      case 'capsule_7': // 결혼기념일
        return _getAnniversaryAnalysisData();
      case 'capsule_9': // 부산 여행 자금 (완료)
        return _getBusanAnalysisData();
      default:
        return _getNewCapsuleAnalysisData(); // 새로운 타임캡슐 기본값
    }
  }

  // 다낭 여행 자금 분석 데이터
  Map<String, dynamic> _getDanangAnalysisData() {
    return {
      'capsuleTitle': '다낭 여행',
      'period': '5개월',
      'startDate': '2025.08.01',
      'endDate': '2025.01.06',
      'totalDiaries': 32,
      'totalPoints': 950,
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 7,
        'percentage': 72,
        'growth': '+3레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1-2개월',
          'mainEmotion': '😰',
          'description': '해외여행 비용에 대한 부담감',
          'percentage': 35,
          'color': NHColors.fear,
        },
        {
          'phase': '중반',
          'period': '3-4개월',
          'mainEmotion': '😊',
          'description': '여행 계획 수립으로 인한 설렘',
          'percentage': 65,
          'color': NHColors.joy,
        },
        {
          'phase': '마지막',
          'period': '5개월',
          'mainEmotion': '😊',
          'description': '목표 달성 임박의 기쁨',
          'percentage': 85,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '8월',
          'joy': 25,
          'fear': 55,
          'sadness': 10,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '9월',
          'joy': 35,
          'fear': 45,
          'sadness': 12,
          'anger': 4,
          'disgust': 4,
        },
        {
          'month': '10월',
          'joy': 50,
          'fear': 30,
          'sadness': 12,
          'anger': 4,
          'disgust': 4,
        },
        {
          'month': '11월',
          'joy': 65,
          'fear': 20,
          'sadness': 10,
          'anger': 3,
          'disgust': 2,
        },
        {
          'month': '12월',
          'joy': 80,
          'fear': 10,
          'sadness': 6,
          'anger': 2,
          'disgust': 2,
        },
      ],
      'successPatterns': [
        {'pattern': '용돈 절약', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '외식 줄이기', 'frequency': '주 3회', 'effectiveness': '중간'},
        {'pattern': '부업 수입', 'frequency': '월 3회', 'effectiveness': '높음'},
        {'pattern': '할인 쇼핑', 'frequency': '주 1회', 'effectiveness': '중간'},
      ],
      'recommendations': [
        {
          'type': '여행상품',
          'name': 'NH여행적금',
          'reason': '해외여행 목적 저축',
          'rate': '3.8%',
        },
        {
          'type': '카드상품',
          'name': 'NH올원 여행카드',
          'reason': '해외 결제 혜택',
          'benefit': '해외 수수료 면제',
        },
        {
          'type': '보험상품',
          'name': 'NH여행보험',
          'reason': '안전한 해외여행',
          'coverage': '1억원',
        },
      ],
      'achievements': [
        {'icon': '🎯', 'title': '목표 달성 임박', 'desc': '90% 달성'},
        {'icon': '📈', 'title': '감정 성장', 'desc': '기쁨이 +3레벨'},
        {'icon': '📅', 'title': '꾸준한 기록', 'desc': '32일 기록'},
        {'icon': '💰', 'title': '효율적 저축', 'desc': '월 평균 360만원'},
      ],
    };
  }

  // 골프 습관 일지 분석 데이터
  Map<String, dynamic> _getGolfHabitAnalysisData() {
    return {
      'capsuleTitle': '골프 습관 일지',
      'period': '무기한',
      'startDate': '2025.08.01',
      'endDate': '—',
      'totalDiaries': 18,
      'totalPoints': 620,
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 7,
        'percentage': 68,
        'growth': '+1레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1-2주',
          'mainEmotion': '😰',
          'description': '루틴 정착에 대한 부담',
          'percentage': 42,
          'color': NHColors.fear,
        },
        {
          'phase': '중반',
          'period': '3-4주',
          'mainEmotion': '😊',
          'description': '샷 일관성 향상에 따른 만족',
          'percentage': 60,
          'color': NHColors.joy,
        },
        {
          'phase': '현재',
          'period': '5주~',
          'mainEmotion': '😊',
          'description': '숏게임 개선 성과에 대한 기쁨',
          'percentage': 78,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '8월',
          'joy': 40,
          'fear': 45,
          'sadness': 8,
          'anger': 4,
          'disgust': 3
        },
        {
          'month': '9월',
          'joy': 55,
          'fear': 30,
          'sadness': 8,
          'anger': 4,
          'disgust': 3
        },
        {
          'month': '10월',
          'joy': 68,
          'fear': 20,
          'sadness': 6,
          'anger': 3,
          'disgust': 3
        },
      ],
      'successPatterns': [
        {'pattern': '3일 연속 루틴', 'frequency': '주 1회', 'effectiveness': '높음'},
        {'pattern': '퍼팅 메트로놈', 'frequency': '주 3회', 'effectiveness': '중간'},
        {'pattern': '숏게임 9시-3시', 'frequency': '주 2회', 'effectiveness': '높음'},
      ],
      'recommendations': [
        {
          'type': '용품',
          'name': '퍼팅 매트',
          'reason': '롱퍼팅 거리감 향상',
          'benefit': '집중도↑'
        },
        {
          'type': '루틴',
          'name': '3단계 티샷 루틴',
          'reason': '오비 감소',
          'benefit': '일관성↑'
        },
      ],
      'achievements': [
        {'icon': '🏆', 'title': '루틴 정착', 'desc': '연속 7일 기록'},
        {'icon': '⛳', 'title': '스크린 베스트', 'desc': '최근 85타'},
        {'icon': '🕳️', 'title': '3퍼 감소', 'desc': '3퍼 빈도 40%→25%'},
        {'icon': '🏌️‍♂️', 'title': '드라이버 안정', 'desc': '훅/슬라이스 감소'},
      ],
    };
  }

  // 집 구매 자금 분석 데이터
  Map<String, dynamic> _getHouseAnalysisData() {
    return {
      'capsuleTitle': '내집마련',
      'period': '36개월',
      'startDate': '2022.01.01',
      'endDate': '2025.01.06',
      'totalDiaries': 89,
      'totalPoints': 2150,
      'mainCharacter': {
        'emoji': '😤',
        'name': '분노',
        'level': 5,
        'percentage': 45,
        'growth': '+1레벨',
        'color': NHColors.anger,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1-12개월',
          'mainEmotion': '😰',
          'description': '큰 목표에 대한 막막함',
          'percentage': 30,
          'color': NHColors.fear,
        },
        {
          'phase': '중반',
          'period': '13-24개월',
          'mainEmotion': '😤',
          'description': '부동산 시장 변화에 대한 불안',
          'percentage': 50,
          'color': NHColors.anger,
        },
        {
          'phase': '현재',
          'period': '25-36개월',
          'mainEmotion': '😤',
          'description': '목표 달성의 어려움',
          'percentage': 40,
          'color': NHColors.anger,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '1월',
          'joy': 15,
          'fear': 60,
          'sadness': 15,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '2월',
          'joy': 20,
          'fear': 55,
          'sadness': 15,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '3월',
          'joy': 25,
          'fear': 50,
          'sadness': 15,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '4월',
          'joy': 30,
          'fear': 45,
          'sadness': 15,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '5월',
          'joy': 35,
          'fear': 40,
          'sadness': 15,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '6월',
          'joy': 40,
          'fear': 35,
          'sadness': 15,
          'anger': 5,
          'disgust': 5,
        },
      ],
      'successPatterns': [
        {'pattern': '정기 적금', 'frequency': '매월', 'effectiveness': '높음'},
        {'pattern': '투자 수익', 'frequency': '분기별', 'effectiveness': '중간'},
        {'pattern': '부업 소득', 'frequency': '월 2회', 'effectiveness': '높음'},
        {'pattern': '생활비 절약', 'frequency': '매일', 'effectiveness': '중간'},
      ],
      'recommendations': [
        {
          'type': '대출상품',
          'name': 'NH주택담보대출',
          'reason': '집 구매 목적',
          'rate': '3.2%',
        },
        {
          'type': '적금상품',
          'name': 'NH청약통장',
          'reason': '주택 청약 대비',
          'benefit': '청약 가점',
        },
        {
          'type': '투자상품',
          'name': 'NH부동산펀드',
          'reason': '부동산 투자 경험',
          'risk': '중간',
        },
      ],
      'achievements': [
        {'icon': '🏆', 'title': '장기 목표 도전', 'desc': '30% 달성'},
        {'icon': '📈', 'title': '꾸준한 성장', 'desc': '분노 +1레벨'},
        {'icon': '📅', 'title': '장기 기록', 'desc': '89일 기록'},
        {'icon': '💰', 'title': '대규모 저축', 'desc': '월 평균 417만원'},
      ],
    };
  }

  // 결혼기념일 자금 분석 데이터
  Map<String, dynamic> _getAnniversaryAnalysisData() {
    return {
      'capsuleTitle': '💕 결혼기념일',
      'period': '3개월',
      'startDate': '2024.10.01',
      'endDate': '2024.12.31',
      'totalDiaries': 18,
      'totalPoints': 520,
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 8,
        'percentage': 78,
        'growth': '+2레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1개월',
          'mainEmotion': '😊',
          'description': '특별한 날 준비의 설렘',
          'percentage': 70,
          'color': NHColors.joy,
        },
        {
          'phase': '중반',
          'period': '2개월',
          'mainEmotion': '😊',
          'description': '목표 달성 확신',
          'percentage': 80,
          'color': NHColors.joy,
        },
        {
          'phase': '현재',
          'period': '3개월',
          'mainEmotion': '😊',
          'description': '성공적인 목표 달성',
          'percentage': 85,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '10월',
          'joy': 70,
          'fear': 15,
          'sadness': 8,
          'anger': 4,
          'disgust': 3,
        },
        {
          'month': '11월',
          'joy': 80,
          'fear': 10,
          'sadness': 6,
          'anger': 2,
          'disgust': 2,
        },
        {
          'month': '12월',
          'joy': 85,
          'fear': 8,
          'sadness': 4,
          'anger': 2,
          'disgust': 1,
        },
      ],
      'successPatterns': [
        {'pattern': '특별 저축', 'frequency': '주 2회', 'effectiveness': '높음'},
        {'pattern': '용돈 절약', 'frequency': '매일', 'effectiveness': '중간'},
        {'pattern': '선물 계획', 'frequency': '주 1회', 'effectiveness': '높음'},
        {'pattern': '이벤트 준비', 'frequency': '월 1회', 'effectiveness': '높음'},
      ],
      'recommendations': [
        {
          'type': '이벤트상품',
          'name': 'NH기념일 적금',
          'reason': '특별한 날 준비',
          'rate': '4.0%',
        },
        {
          'type': '카드상품',
          'name': 'NH커플카드',
          'reason': '함께 사용 혜택',
          'benefit': '커플 적립',
        },
        {'type': '선물상품', 'name': 'NH선물펀드', 'reason': '미래 선물 준비', 'risk': '낮음'},
      ],
      'achievements': [
        {'icon': '🎯', 'title': '목표 초과 달성', 'desc': '83% 달성'},
        {'icon': '📈', 'title': '감정 성장', 'desc': '기쁨이 +2레벨'},
        {'icon': '📅', 'title': '꾸준한 기록', 'desc': '18일 기록'},
        {'icon': '💰', 'title': '효율적 저축', 'desc': '월 평균 83만원'},
      ],
    };
  }

  // 제주도 여행 자금 분석 데이터 (완료)
  Map<String, dynamic> _getJejuAnalysisData() {
    return {
      'capsuleTitle': '🏖️ 제주도 여행 자금',
      'period': '6개월',
      'startDate': '2025.08.01',
      'endDate': '2025.01.06',
      'totalDiaries': 28,
      'totalPoints': 850,
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 9,
        'percentage': 68,
        'growth': '+2레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1-2개월',
          'mainEmotion': '😰',
          'description': '목표 달성에 대한 불안과 긴장',
          'percentage': 40,
          'color': NHColors.fear,
        },
        {
          'phase': '중반',
          'period': '3-4개월',
          'mainEmotion': '😊',
          'description': '꾸준한 저축으로 인한 만족감',
          'percentage': 60,
          'color': NHColors.joy,
        },
        {
          'phase': '마지막',
          'period': '5-6개월',
          'mainEmotion': '😊',
          'description': '목표 달성의 기쁨과 성취감',
          'percentage': 80,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '8월',
          'joy': 30,
          'fear': 50,
          'sadness': 10,
          'anger': 5,
          'disgust': 5,
        },
        {
          'month': '9월',
          'joy': 35,
          'fear': 45,
          'sadness': 12,
          'anger': 4,
          'disgust': 4,
        },
        {
          'month': '10월',
          'joy': 45,
          'fear': 35,
          'sadness': 12,
          'anger': 4,
          'disgust': 4,
        },
        {
          'month': '11월',
          'joy': 55,
          'fear': 25,
          'sadness': 12,
          'anger': 4,
          'disgust': 4,
        },
        {
          'month': '12월',
          'joy': 65,
          'fear': 15,
          'sadness': 12,
          'anger': 4,
          'disgust': 4,
        },
        {
          'month': '1월',
          'joy': 75,
          'fear': 10,
          'sadness': 10,
          'anger': 3,
          'disgust': 2,
        },
      ],
      'successPatterns': [
        {'pattern': '정기 저축', 'frequency': '매주 금요일', 'effectiveness': '높음'},
        {'pattern': '목표 시각화', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '소액 절약', 'frequency': '매일', 'effectiveness': '중간'},
        {'pattern': '부업 수입', 'frequency': '월 2회', 'effectiveness': '높음'},
      ],
      'recommendations': [
        {
          'type': '저축상품',
          'name': 'NH올원 적금',
          'reason': '정기 저축 패턴에 최적화',
          'rate': '3.5%',
        },
        {
          'type': '투자상품',
          'name': 'NH투자증권 펀드',
          'reason': '장기 목표 달성 경험 활용',
          'risk': '중간',
        },
        {
          'type': '보험상품',
          'name': 'NH생명 종신보험',
          'reason': '안정적인 미래 계획',
          'coverage': '1억원',
        },
      ],
      'achievements': [
        {'icon': '🏆', 'title': '목표 초과 달성', 'desc': '112% 달성'},
        {'icon': '📈', 'title': '감정 성장', 'desc': '기쁨이 +2레벨'},
        {'icon': '📅', 'title': '꾸준한 기록', 'desc': '28일 기록'},
        {'icon': '💰', 'title': '효율적 저축', 'desc': '월 평균 280만원'},
      ],
    };
  }

  // 부산 여행 자금 분석 데이터 (완료)
  Map<String, dynamic> _getBusanAnalysisData() {
    return {
      'capsuleTitle': '🚄 친구들과 부산여행',
      'period': '4개월',
      'startDate': '2025.08.01',
      'endDate': '2025.01.06',
      'totalDiaries': 25,
      'totalPoints': 800,
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 6,
        'percentage': 85,
        'growth': '+3레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1개월',
          'mainEmotion': '😊',
          'description': '친구들과의 국내여행 계획 설렘',
          'percentage': 75,
          'color': NHColors.joy,
        },
        {
          'phase': '중반',
          'period': '2-3개월',
          'mainEmotion': '😊',
          'description': '부산 여행지 조사와 예약',
          'percentage': 80,
          'color': NHColors.joy,
        },
        {
          'phase': '마지막',
          'period': '4개월',
          'mainEmotion': '😊',
          'description': '성공적인 부산여행 완료의 만족감',
          'percentage': 90,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '8월',
          'joy': 70,
          'fear': 15,
          'sadness': 8,
          'anger': 4,
          'disgust': 3,
        },
        {
          'month': '9월',
          'joy': 75,
          'fear': 12,
          'sadness': 7,
          'anger': 3,
          'disgust': 3,
        },
        {
          'month': '10월',
          'joy': 80,
          'fear': 10,
          'sadness': 6,
          'anger': 2,
          'disgust': 2,
        },
        {
          'month': '11월',
          'joy': 90,
          'fear': 5,
          'sadness': 3,
          'anger': 1,
          'disgust': 1,
        },
      ],
      'successPatterns': [
        {'pattern': '친구 모임 저축', 'frequency': '매주', 'effectiveness': '높음'},
        {'pattern': '국내여행 계획', 'frequency': '월 1회', 'effectiveness': '높음'},
        {'pattern': '공동 절약', 'frequency': '매일', 'effectiveness': '중간'},
        {'pattern': '할인 혜택 활용', 'frequency': '주 2회', 'effectiveness': '높음'},
      ],
      'recommendations': [
        {
          'type': '여행상품',
          'name': 'NH국내여행적금',
          'reason': '친구들과 함께 저축',
          'rate': '3.8%',
        },
        {
          'type': '카드상품',
          'name': 'NH여행카드',
          'reason': '국내여행 특화 혜택',
          'benefit': '교통비 적립 2%',
        },
        {
          'type': '보험상품',
          'name': 'NH국내여행보험',
          'reason': '안전한 국내여행',
          'coverage': '5천만원',
        },
      ],
      'achievements': [
        {'icon': '🎯', 'title': '목표 완벽 달성', 'desc': '100% 달성'},
        {'icon': '📈', 'title': '감정 성장', 'desc': '기쁨이 +3레벨'},
        {'icon': '📅', 'title': '꾸준한 기록', 'desc': '25일 기록'},
        {'icon': '💰', 'title': '효율적 저축', 'desc': '월 평균 50만원'},
      ],
    };
  }

  // 러닝 타임캡슐 분석 데이터
  Map<String, dynamic> _getRunningAnalysisData() {
    return {
      'capsuleTitle': '🏃‍♂️ 러닝 습관',
      'period': '3개월',
      'startDate': '2024.10.01',
      'endDate': '2025.01.01',
      'totalDiaries': 85,
      'totalPoints': 0, // 포인트 개념 제거
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 8,
        'percentage': 90,
        'growth': '+4레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1개월',
          'mainEmotion': '😰',
          'description': '매일 러닝에 대한 부담감과 체력적 부족',
          'percentage': 40,
          'color': NHColors.fear,
        },
        {
          'phase': '중반',
          'period': '2개월',
          'mainEmotion': '😊',
          'description': '꾸준한 러닝으로 체력과 자신감 증가',
          'percentage': 75,
          'color': NHColors.joy,
        },
        {
          'phase': '마지막',
          'period': '3개월',
          'mainEmotion': '😊',
          'description': '러닝이 일상이 되어 자연스러운 루틴 완성',
          'percentage': 95,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '10월',
          'joy': 35,
          'fear': 40,
          'sadness': 15,
          'anger': 6,
          'disgust': 4,
        },
        {
          'month': '11월',
          'joy': 65,
          'fear': 20,
          'sadness': 10,
          'anger': 3,
          'disgust': 2,
        },
        {
          'month': '12월',
          'joy': 85,
          'fear': 8,
          'sadness': 4,
          'anger': 2,
          'disgust': 1,
        },
      ],
      'successPatterns': [
        {'pattern': '매일 정해진 시간 러닝', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '러닝 기록 및 거리 측정', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '주간 러닝 목표 설정', 'frequency': '주 1회', 'effectiveness': '중간'},
        {
          'pattern': '체력 및 속도 개선 체크',
          'frequency': '주 2회',
          'effectiveness': '중간'
        },
      ],
      'recommendations': [
        {
          'type': '러닝 도구',
          'name': '러닝 워치',
          'reason': '정확한 거리와 페이스 측정',
          'benefit': '실시간 운동량 모니터링',
        },
        {
          'type': '습관 앱',
          'name': '러닝 기록 앱',
          'reason': '일일 러닝 기록 및 동기 부여',
          'benefit': '연속 러닝일 확인',
        },
      ],
      'achievements': [
        {'icon': '🎯', 'title': '완벽한 루틴', 'desc': '85일 연속 러닝'},
        {'icon': '📈', 'title': '감정 성장', 'desc': '체력과 자신감 크게 향상'},
        {'icon': '📅', 'title': '습관 완성', 'desc': '3개월 지속 성공'},
        {'icon': '💪', 'title': '체력 향상', 'desc': '평균 페이스 30초 단축'},
      ],
    };
  }

  // 독서 타임캡슐 분석 데이터
  Map<String, dynamic> _getReadingAnalysisData() {
    return {
      'capsuleTitle': '📖 독서 습관',
      'period': '2개월',
      'startDate': '2024.11.01',
      'endDate': '2025.01.01',
      'totalDiaries': 58,
      'totalPoints': 0, // 포인트 개념 제거
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 6,
        'percentage': 85,
        'growth': '+3레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '2주',
          'mainEmotion': '😰',
          'description': '매일 독서 시간 확보의 어려움과 집중력 부족',
          'percentage': 35,
          'color': NHColors.fear,
        },
        {
          'phase': '중반',
          'period': '4-6주',
          'mainEmotion': '😊',
          'description': '독서가 주는 즐거움과 지식 습득의 기쁨',
          'percentage': 70,
          'color': NHColors.joy,
        },
        {
          'phase': '마지막',
          'period': '7-8주',
          'mainEmotion': '😊',
          'description': '독서가 자연스러운 일상이 된 만족감',
          'percentage': 90,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '11월',
          'joy': 50,
          'fear': 30,
          'sadness': 12,
          'anger': 5,
          'disgust': 3,
        },
        {
          'month': '12월',
          'joy': 80,
          'fear': 10,
          'sadness': 6,
          'anger': 2,
          'disgust': 2,
        },
      ],
      'successPatterns': [
        {'pattern': '매일 정해진 시간 독서', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '독서 후 감상 기록', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '책별 목표 페이지 설정', 'frequency': '주 3회', 'effectiveness': '중간'},
        {'pattern': '독서 환경 최적화', 'frequency': '매일', 'effectiveness': '중간'},
      ],
      'recommendations': [
        {
          'type': '독서 도구',
          'name': '독서 노트',
          'reason': '인상 깊은 구절과 감상 기록',
          'benefit': '기억에 오래 남는 독서',
        },
        {
          'type': '독서 환경',
          'name': '조용한 독서 공간',
          'reason': '집중력 향상을 위한 전용 공간',
          'benefit': '몰입도 높은 독서',
        },
      ],
      'achievements': [
        {'icon': '🎯', 'title': '꾸준한 독서', 'desc': '58일 연속 독서'},
        {'icon': '📈', 'title': '감정 성장', 'desc': '독서 즐거움 발견'},
        {'icon': '📅', 'title': '습관 형성', 'desc': '2개월 지속 성공'},
        {'icon': '📚', 'title': '지식 확장', 'desc': '다양한 분야 12권 완독'},
      ],
    };
  }

  // 새로운 타임캡슐 분석 데이터
  Map<String, dynamic> _getNewCapsuleAnalysisData() {
    return {
      'capsuleTitle': '✨ 새로운 타임캡슐',
      'period': '1개월',
      'startDate': '2024.09.23',
      'endDate': '2024.10.23',
      'totalDiaries': 1,
      'totalPoints': 30,
      'mainCharacter': {
        'emoji': '😊',
        'name': '기쁨이',
        'level': 1,
        'percentage': 80,
        'growth': '+0레벨',
        'color': NHColors.joy,
      },
      'emotionJourney': [
        {
          'phase': '시작',
          'period': '1주일',
          'mainEmotion': '😊',
          'description': '새로운 저축 습관 형성의 기쁨',
          'percentage': 80,
          'color': NHColors.joy,
        },
      ],
      'monthlyEmotionChanges': [
        {
          'month': '9월',
          'joy': 80,
          'fear': 10,
          'sadness': 5,
          'anger': 3,
          'disgust': 2,
        },
      ],
      'successPatterns': [
        {'pattern': '기본 저축', 'frequency': '매일', 'effectiveness': '높음'},
        {'pattern': '습관 형성', 'frequency': '주 3회', 'effectiveness': '중간'},
      ],
      'recommendations': [
        {
          'type': '적금상품',
          'name': 'NH기본 적금',
          'reason': '안정적인 저축 습관 형성',
          'rate': '3.0%',
        },
      ],
      'achievements': [
        {'icon': '🎯', 'title': '시작', 'desc': '80% 달성'},
        {'icon': '📈', 'title': '성장', 'desc': '기쁨이 Lv.1'},
        {'icon': '📅', 'title': '기록', 'desc': '1일 기록'},
        {'icon': '💰', 'title': '저축', 'desc': '기본 습관'},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NHColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NHHeaderWidget(
              title: '타임캡슐 분석',
              subtitle: analysisData['capsuleTitle'],
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
                    _buildEmotionJourney(),
                    const SizedBox(height: 20),
                    _buildMonthlyEmotionChanges(),
                    const SizedBox(height: 20),
                    _buildSuccessPatterns(),
                    const SizedBox(height: 20),
                    _buildRecommendations(),
                    const SizedBox(height: 20),
                    _buildAchievements(),
                    const SizedBox(height: 20),
                    _buildCapsuleInfoSummary(),
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
          '🎭 타임캡슐 감정 여정',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NHColors.gray800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${analysisData['period']}간의 감정 변화와 성장 스토리',
          style: TextStyle(fontSize: 16, color: NHColors.gray600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: NHColors.gradientOrange,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    '기간',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    analysisData['period'],
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
                    '총 일기',
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
                  Text(
                    analysisData['totalPoints'] == 0 ? '연속 달성' : '총 포인트',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    analysisData['totalPoints'] == 0
                        ? '${analysisData['totalDiaries']}일'
                        : '${analysisData['totalPoints']}P',
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
            '🌟 이 여정의 주인공',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          (EmotionAssets.pathByEmoji(mainChar['emoji']) != null)
              ? Image.asset(
                  EmotionAssets.pathByEmoji(mainChar['emoji'])!,
                  width: 48,
                  height: 48,
                )
              : Text(mainChar['emoji'], style: const TextStyle(fontSize: 48)),
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
            '이 여정의 ${mainChar['percentage']}%를 함께했어요!',
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
                  '최종 레벨',
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

  Widget _buildEmotionJourney() {
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
            '📈 3단계 감정 변화',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...analysisData['emotionJourney'].map<Widget>(
            (phase) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: phase['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: phase['color'].withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      (EmotionAssets.pathByEmoji(phase['mainEmotion']) != null)
                          ? Image.asset(
                              EmotionAssets.pathByEmoji(phase['mainEmotion'])!,
                              width: 24,
                              height: 24,
                            )
                          : Text(
                              phase['mainEmotion'],
                              style: const TextStyle(fontSize: 24),
                            ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phase['phase'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: NHColors.gray800,
                              ),
                            ),
                            Text(
                              phase['period'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: NHColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${phase['percentage']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: phase['color'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phase['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: NHColors.gray600,
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

  Widget _buildMonthlyEmotionChanges() {
    final List<dynamic> months = analysisData['monthlyEmotionChanges'];
    // X축 라벨을 0..n-1 인덱스로 매핑
    final List<String> labels =
        months.map((m) => m['month'] as String).toList();

    List<FlSpot> spotsOf(String key) {
      return List<FlSpot>.generate(months.length, (i) {
        final v = (months[i][key] as num).toDouble();
        return FlSpot(i.toDouble(), v);
      });
    }

    final joySpots = spotsOf('joy');
    final fearSpots = spotsOf('fear');
    final sadnessSpots = spotsOf('sadness');
    final angerSpots = spotsOf('anger');
    final disgustSpots = spotsOf('disgust');

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
            '📊 월별 감정 변화 (꺾은선)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(show: true, drawVerticalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: 20,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                            fontSize: 10, color: NHColors.gray500),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= labels.length)
                          return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            labels[i],
                            style: const TextStyle(
                                fontSize: 10, color: NHColors.gray500),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                      spots: joySpots,
                      isCurved: true,
                      color: NHColors.joy,
                      barWidth: 2),
                  LineChartBarData(
                      spots: fearSpots,
                      isCurved: true,
                      color: NHColors.fear,
                      barWidth: 2),
                  LineChartBarData(
                      spots: sadnessSpots,
                      isCurved: true,
                      color: NHColors.sadness,
                      barWidth: 2),
                  LineChartBarData(
                      spots: angerSpots,
                      isCurved: true,
                      color: NHColors.anger,
                      barWidth: 2),
                  LineChartBarData(
                      spots: disgustSpots,
                      isCurved: true,
                      color: NHColors.disgust,
                      barWidth: 2),
                ],
                borderData: FlBorderData(show: true),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
                      final emotion = s.barIndex == 0
                          ? '기쁨이'
                          : s.barIndex == 1
                              ? '불안이'
                              : s.barIndex == 2
                                  ? '슬픔이'
                                  : s.barIndex == 3
                                      ? '버럭이'
                                      : '까칠이';
                      return LineTooltipItem(
                        '$emotion ${s.y.toInt()}%',
                        const TextStyle(fontSize: 11, color: NHColors.gray800),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _legendItemWithIcon(
                  '기쁨이', NHColors.joy, EmotionAssets.pathByEmoji('😊')),
              _legendItemWithIcon(
                  '불안이', NHColors.fear, EmotionAssets.pathByEmoji('😰')),
              _legendItemWithIcon(
                  '슬픔이', NHColors.sadness, EmotionAssets.pathByEmoji('😢')),
              _legendItemWithIcon(
                  '버럭이', NHColors.anger, EmotionAssets.pathByEmoji('😡')),
              _legendItemWithIcon(
                  '까칠이', NHColors.disgust, EmotionAssets.pathByEmoji('🤢')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 11, color: NHColors.gray600)),
      ],
    );
  }

  Widget _legendItemWithIcon(String label, Color color, String? assetPath) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (assetPath != null)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Image.asset(assetPath, width: 16, height: 16),
          ),
        _legendItem(label, color),
      ],
    );
  }

  // (old bar helper removed)

  Widget _buildSuccessPatterns() {
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
            '🎯 성공 패턴 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          ...analysisData['successPatterns'].map<Widget>(
            (pattern) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NHColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pattern['pattern'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: NHColors.gray800,
                          ),
                        ),
                        Text(
                          pattern['frequency'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: NHColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: pattern['effectiveness'] == '높음'
                          ? NHColors.success
                          : NHColors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pattern['effectiveness'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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

  Widget _buildRecommendations() {
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
            '🤖 성공 패턴 기반 추천',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '이번 경험을 바탕으로 한 맞춤 상품',
            style: TextStyle(fontSize: 14, color: NHColors.gray600),
          ),
          const SizedBox(height: 16),
          ...analysisData['recommendations'].map<Widget>(
            (recommendation) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NHColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: NHColors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recommendation['type'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: NHColors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (recommendation['rate'] != null)
                        Text(
                          '${recommendation['rate']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: NHColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recommendation['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NHColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recommendation['reason'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: NHColors.gray600,
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
            '🏆 타임캡슐 성취',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NHColors.gray800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: analysisData['achievements']
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
                            achievement['icon'],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement['title'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: NHColors.gray800,
                            ),
                          ),
                          Text(
                            achievement['desc'],
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

  Widget _buildCapsuleInfoSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              const Icon(Icons.lock, color: NHColors.primary),
              const SizedBox(width: 8),
              Text(
                analysisData['capsuleTitle'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (analysisData['totalPoints'] != 0) ...[
            // 금융 타임캡슐인 경우만 목표금액과 진행률 표시
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: NHColors.gray500,
                ),
                const SizedBox(width: 4),
                Text('기간: ${analysisData['period'] ?? ''}'),
                const SizedBox(width: 16),
                const Icon(Icons.flag, size: 16, color: NHColors.gray500),
                const SizedBox(width: 4),
                Text('목표금액: 1,500,000원'), // 샘플
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.show_chart, size: 16, color: NHColors.gray500),
                const SizedBox(width: 4),
                Text('진행률: 112%'), // 샘플
              ],
            ),
          ] else ...[
            // 습관형 타임캡슐인 경우 기간만 표시
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: NHColors.gray500,
                ),
                const SizedBox(width: 4),
                Text('기간: ${analysisData['period'] ?? ''}'),
                const SizedBox(width: 16),
                const Icon(Icons.fitness_center,
                    size: 16, color: NHColors.gray500),
                const SizedBox(width: 4),
                Text('연속 달성: ${analysisData['totalDiaries']}일'),
              ],
            ),
          ],
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
        content: const Text('타임캡슐 분석 결과를 친구들과 공유했습니다!'),
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
        content: const Text('타임캡슐 분석 리포트 PDF가 다운로드되었습니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
