# NH 금융 타임캡슐 Flutter 앱 개발 가이드

## 📋 프로젝트 개요

NH농협 올원뱅크 내 "금융 타임캡슐" 서비스를 Flutter로 구현하는 프로젝트입니다. 감정 기반 금융 관리와 목표 달성을 위한 스토리텔링 서비스입니다.

## 🎯 핵심 컨셉

- **감정 캐릭터**: 기쁨이, 슬픔이, 분노, 불안이, 까칠이 (5개)
- **타임캡슐 유형**: 개인형(감정 중심) vs 모임형(실용 중심)
- **금융일기 유형**: 일반형, 개인형 타임캡슐, 모임형 타임캡슐
- **진입점 자동 구분**: 월간 분석 vs 타임캡슐 완료시 분석

## 📁 프로젝트 구조

```
lib/
├── main.dart
├── models/
│   ├── emotion_character.dart
│   ├── time_capsule.dart
│   ├── financial_diary.dart
│   ├── user_data.dart
│   ├── milestone.dart
│   └── point_system.dart
├── screens/
│   ├── home/
│   │   └── nh_home_screen.dart
│   ├── capsule/
│   │   ├── capsule_create_screen.dart
│   │   ├── personal_capsule_open_screen.dart
│   │   └── group_capsule_open_screen.dart
│   ├── diary/
│   │   ├── general_diary_screen.dart
│   │   ├── personal_capsule_diary_screen.dart
│   │   └── group_capsule_diary_screen.dart
│   └── analysis/
│       ├── monthly_character_analysis_screen.dart
│       └── capsule_character_analysis_screen.dart
├── widgets/
│   ├── emotion_character_widget.dart
│   ├── progress_bar_widget.dart
│   ├── capsule_card_widget.dart
│   ├── nh_header_widget.dart
│   ├── point_display_widget.dart
│   └── milestone_widget.dart
├── services/
│   ├── nh_data_service.dart
│   ├── point_service.dart
│   ├── emotion_analysis_service.dart
│   └── storage_service.dart
├── utils/
│   ├── colors.dart
│   ├── constants.dart
│   ├── date_utils.dart
│   └── number_formatter.dart
└── assets/
    ├── images/
    │   ├── nh_logo.png
    │   ├── emotion_characters/
    │   └── backgrounds/
    └── animations/
        └── capsule_open.json
```

## 🚀 개발 순서

### Phase 1: 기본 구조 및 모델 (1-2일)

1. **Flutter 프로젝트 생성**
```bash
flutter create nh_timecapsule
cd nh_timecapsule
```

2. **필요한 패키지 추가** (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  shared_preferences: ^2.2.2
  image_picker: ^1.0.4
  intl: ^0.18.1
  fl_chart: ^0.64.0
  animations: ^2.0.8
  lottie: ^2.7.0
  cached_network_image: ^3.3.0
  path_provider: ^2.1.1
  permission_handler: ^11.0.1
```

3. **데이터 모델 생성**
   - `models/emotion_character.dart` - 감정 캐릭터 데이터
   - `models/time_capsule.dart` - 타임캡슐 데이터
   - `models/financial_diary.dart` - 금융일기 데이터
   - `models/user_data.dart` - 사용자 데이터
   - `models/milestone.dart` - 이정표 데이터
   - `models/point_system.dart` - 포인트 시스템

### Phase 2: 홈화면 구현 (2-3일)

4. **홈화면 구현** (`screens/home/nh_home_screen.dart`)
   - NH마이데이터 스타일 헤더 (require/my.jpg 참고)
   - 자산 요약 카드
   - 타임캡슐 현황
   - 열기 가능한 캡슐 강조
   - 퀵 액션 버튼

### Phase 3: 타임캡슐 생성 (2일)

5. **타임캡슐 생성화면** (`screens/capsule/capsule_create_screen.dart`)
   - 2단계 간소화된 플로우
   - 개인형/모임형 선택
   - 6개 목적 중심 카테고리
   - 실시간 유효성 검사

### Phase 4: 금융일기 구현 (3-4일)

6. **일반 금융일기** (`screens/diary/general_diary_screen.dart`)
   - 감정 캐릭터 선택
   - 자동 연동 내역 표시
   - 수동 추가 기록
   - 30P + 사진 15P 포인트

7. **개인형 타임캡슐 일기** (`screens/diary/personal_capsule_diary_screen.dart`)
   - 특정 타임캡슐 연결
   - 이정표 시스템
   - 캐릭터 경험치 시스템
   - 50P + 보너스 포인트

8. **모임형 타임캡슐 일기** (`screens/diary/group_capsule_diary_screen.dart`)
   - 감정 기록 없음 (실용 중심)
   - 비용 분할 기능
   - 영수증 첨부
   - 멤버 알림 시스템

### Phase 5: 타임캡슐 열기 (2-3일)

9. **개인형 타임캡슐 열기** (`screens/capsule/personal_capsule_open_screen.dart`)
   - 3단계 스토리텔링
   - 캐릭터 성장 스토리
   - 감정 분포 분석
   - 인스타그램 공유

10. **모임형 타임캡슐 열기** (`screens/capsule/group_capsule_open_screen.dart`)
    - 모임 성과 중심
    - 멤버별 기여도 순위
    - 비용 구성 분석
    - 정산 완료 확인

### Phase 6: 캐릭터 분석 (2-3일)

11. **월간 캐릭터 분석** (`screens/analysis/monthly_character_analysis_screen.dart`)
    - 일반 + 개인형 타임캡슐 통합 분석
    - 캐릭터별 성장 현황
    - AI 맞춤 금융상품 추천
    - 다음 달 목표 설정

12. **타임캡슐 완료시 캐릭터 분석** (`screens/analysis/capsule_character_analysis_screen.dart`)
    - 특정 타임캡슐 기간 집중 분석
    - 감정 여정 스토리텔링
    - 3단계 감정 변화
    - 성공 패턴 기반 추천

## 💡 구현 팁

### 1. 감정 캐릭터 시스템
```dart
class EmotionCharacter {
  final String id;
  final String emoji;
  final String name;
  final Color color;
  final int level;
  final int exp;
  final int maxExp;
  
  // 레벨업 로직
  bool canLevelUp() => exp >= maxExp;
  
  // 경험치 추가
  void addExp(int amount) {
    exp += amount;
    if (canLevelUp()) {
      levelUp();
    }
  }
  
  void levelUp() {
    level++;
    exp -= maxExp;
    maxExp = calculateNextLevelExp();
  }
}
```

### 2. 포인트 시스템
```dart
class PointService {
  static int calculateDiaryPoints({
    required DiaryType type,
    bool hasImage = false,
    bool hasMilestone = false,
    bool hasAmount = false,
  }) {
    switch (type) {
      case DiaryType.general:
        return 30 + (hasImage ? 15 : 0);
      case DiaryType.personalCapsule:
        return 50 + (hasImage ? 20 : 0) + (hasMilestone ? 25 : 0);
      case DiaryType.groupCapsule:
        return 25 + (hasImage ? 15 : 0);
    }
  }
}
```

### 3. 진입점 자동 구분
```dart
class AnalysisNavigator {
  static void navigateToAnalysis(BuildContext context, {
    AnalysisType? type,
    String? capsuleId,
  }) {
    if (type == AnalysisType.monthly) {
      Navigator.push(context, MonthlyCharacterAnalysisScreen());
    } else if (capsuleId != null) {
      Navigator.push(context, CapsuleCharacterAnalysisScreen(capsuleId));
    }
  }
}
```

### 4. NH 디자인 시스템
```dart
class NHColors {
  static const primary = Color(0xFF00A651);
  static const blue = Color(0xFF0066CC);
  static const background = Color(0xFFF8F9FA);
  
  // 감정 캐릭터 색상
  static const joy = Color(0xFFFFD700);
  static const sadness = Color(0xFF4A90E2);
  static const anger = Color(0xFFFF4444);
  static const fear = Color(0xFF9B59B6);
  static const disgust = Color(0xFF2ECC71);
}
```

## 📱 화면별 우선순위

### 필수 구현 (MVP)
1. ✅ 홈화면 (`nh_home_screen.dart`) - require 폴더의 '홈화면.txt' 참고
2. ✅ 타임캡슐 생성 (`capsule_create_screen.dart`) - require 폴더의 '타임캡슐 생성화면2.txt' 참고
3. ✅ 개인형 타임캡슐 일기 (`personal_capsule_diary_screen.dart`) - require 폴더의 '나의 금융일기_개인형.txt' 참고
4. ✅ 개인형 타임캡슐 열기 (`personal_capsule_open_screen.dart`) - require 폴더의 '타임캡슐 여는 화면_개인형.txt' 참고

### 확장 구현
5. ✅ 일반 금융일기 (`general_diary_screen.dart`) - require 폴더의 '나의 금융일기_일반형.txt' 참고
6. ✅ 모임형 타임캡슐 일기 (`group_capsule_diary_screen.dart`) - require 폴더의 '나의 금융일기_모임형.txt' 참고
7. ✅ 모임형 타임캡슐 열기 (`group_capsule_open_screen.dart`) - require 폴더의 '타임캡슐 여는 화면_모임형.txt' 참고
8. ✅ 월간 캐릭터 분석 (`monthly_character_analysis_screen.dart`) - require 폴더의 '감정캐릭터분석_월간.txt' 참고
9. ✅ 타임캡슐 캐릭터 분석 (`capsule_character_analysis_screen.dart`) - require 폴더의 '감정캐릭터분석_모임형 타임캡슐.txt' 참고

## 🔧 기술적 고려사항

### 1. 상태 관리
- **Provider 패턴** 사용 권장
- 감정 캐릭터 상태, 타임캡슐 상태, 사용자 데이터 분리

### 2. 데이터 저장
- **SharedPreferences**: 설정 및 간단한 데이터
- **로컬 JSON**: 타임캡슐 및 일기 데이터
- **향후 서버 연동** 준비

### 3. 애니메이션
- **Hero 애니메이션**: 타임캡슐 열기 시
- **Lottie**: 캐릭터 애니메이션
- **커스텀 애니메이션**: 진행률 바, 레벨업

### 4. 이미지 처리
- **image_picker**: 사진 첨부 기능
- **cached_network_image**: 이미지 캐싱

## 📝 체크리스트

### 개발 전 준비
- [x] Flutter 개발 환경 설정
- [x] 디자인 시스템 정의
- [x] 데이터 모델 설계
- [x] 상태 관리 구조 설계
- [x] NH 브랜드 가이드라인 확인
- [x] 감정 캐릭터 디자인 확정
- [x] 포인트 시스템 로직 정의
- [x] 애니메이션 스펙 정의

### Phase 1: 기본 구조 (1-2일)
- [x] Flutter 프로젝트 생성
- [x] 필요한 패키지 추가 (pubspec.yaml)
- [x] 프로젝트 구조 생성
- [x] 기본 모델 클래스 구현
  - [x] EmotionCharacter 모델
  - [x] TimeCapsule 모델
  - [x] FinancialDiary 모델
  - [x] UserData 모델
  - [x] Milestone 모델
  - [x] PointSystem 모델
- [x] NH 디자인 시스템 정의 (colors.dart, constants.dart)
- [x] 기본 유틸리티 함수 구현 (date_utils.dart, number_formatter.dart)

### Phase 2: 홈화면 구현 (2-3일)
- [x] NH 헤더 위젯 구현 (nh_header_widget.dart)
- [x] 자산 요약 카드 위젯
- [x] 타임캡슐 현황 섹션
- [x] 열기 가능한 캡슐 강조 표시
- [x] 진행중인 캡슐 목록
- [x] 퀵 액션 버튼들
- [x] 포인트 표시 위젯
- [x] 탭 네비게이션 구현
- [x] 홈화면 상태 관리 (Provider)

### Phase 3: 타임캡슐 생성 (2일)
- [ ] 2단계 생성 플로우 구현
- [ ] 개인형/모임형 선택 UI
- [ ] 6개 카테고리 선택 (여행, 저축, 내집마련, 취미생활, 특별한날, 기타)
- [ ] 제목 입력 및 유효성 검사
- [ ] 목표 금액 입력 (숫자 포맷팅)
- [ ] 기간 선택 (3개월, 6개월, 1년)
- [ ] 첫 기록 작성 (선택사항)
- [ ] 사진 추가 기능
- [ ] 생성 완료 화면
- [ ] 포인트 적립 로직

### Phase 4: 금융일기 구현 (3-4일)
- [ ] 일반 금융일기 화면
  - [ ] 감정 캐릭터 선택 (5개)
  - [ ] 자동 연동 내역 표시
  - [ ] 수동 금액 입력
  - [ ] 사진 첨부 기능
  - [ ] 30P + 사진 15P 포인트 시스템
- [ ] 개인형 타임캡슐 일기 화면
  - [ ] 타임캡슐 연결 및 진행률 표시
  - [ ] 감정 캐릭터 선택
  - [ ] 이정표 시스템 (저축했어요, 참았어요, 목표에 가까워졌어요, 어려움을 극복했어요)
  - [ ] 캐릭터 경험치 시스템
  - [ ] 50P + 보너스 포인트 (이정표별 10-25P)
- [ ] 모임형 타임캡슐 일기 화면
  - [ ] 감정 기록 없음 (실용 중심)
  - [ ] 비용 분할 기능
  - [ ] 영수증 첨부
  - [ ] 멤버 알림 시스템
  - [ ] 25P + 사진 15P 포인트

### Phase 5: 타임캡슐 열기 (2-3일)
- [x] 개인형 타임캡슐 열기 화면
  - [x] 3단계 스토리텔링 플로우
  - [x] Step 0: 타임캡슐 열기 애니메이션
  - [x] Step 1: 캐릭터와 성과 요약
  - [x] Step 2: 상세 분석 및 공유
  - [x] 캐릭터 성장 스토리
  - [x] 감정 분포 분석
  - [x] 여정 하이라이트
  - [x] 인스타그램 공유 기능
  - [x] PDF 다운로드 기능
- [x] 모임형 타임캡슐 열기 화면
  - [x] 모임 성과 중심 분석
  - [x] 멤버별 기여도 순위
  - [x] 비용 구성 분석
  - [x] 정산 완료 확인

### Phase 6: 캐릭터 분석 (2-3일)
- [x] 월간 캐릭터 분석 화면
  - [x] 일반 + 개인형 타임캡슐 통합 분석
  - [x] 캐릭터별 성장 현황
  - [x] 월간 하이라이트
  - [x] 금융 패턴 분석
  - [x] AI 맞춤 금융상품 추천
  - [x] 다음 달 목표 설정
- [x] 타임캡슐 완료시 캐릭터 분석 화면
  - [x] 특정 타임캡슐 기간 집중 분석
  - [x] 감정 여정 스토리텔링
  - [x] 3단계 감정 변화 (시작, 중반, 마지막)
  - [x] 월별 감정 변화 차트
  - [x] 성공 패턴 기반 추천

### Phase 7: 공통 위젯 및 서비스 (1-2일)
- [ ] 감정 캐릭터 위젯 (emotion_character_widget.dart)
- [ ] 진행률 바 위젯 (progress_bar_widget.dart)
- [ ] 타임캡슐 카드 위젯 (capsule_card_widget.dart)
- [ ] 포인트 표시 위젯 (point_display_widget.dart)
- [ ] 이정표 위젯 (milestone_widget.dart)
- [ ] NH 데이터 서비스 (nh_data_service.dart)
- [ ] 포인트 서비스 (point_service.dart)
- [ ] 감정 분석 서비스 (emotion_analysis_service.dart)
- [ ] 저장소 서비스 (storage_service.dart)

### Phase 8: 애니메이션 및 UX 개선 (1-2일)
- [ ] Hero 애니메이션 (타임캡슐 열기)
- [ ] Lottie 애니메이션 (캐릭터)
- [ ] 커스텀 애니메이션 (진행률 바, 레벨업)
- [ ] 페이지 전환 애니메이션
- [ ] 로딩 애니메이션
- [ ] 성공/실패 피드백 애니메이션

### Phase 9: 데이터 관리 및 저장 (1일)
- [ ] SharedPreferences 설정
- [ ] 로컬 JSON 데이터 저장
- [ ] 이미지 캐싱 시스템
- [ ] 데이터 백업/복원
- [ ] 데이터 마이그레이션

### Phase 10: 테스트 및 최적화 (1-2일)
- [ ] 각 화면 플로우 테스트
- [ ] 포인트 적립 확인
- [ ] 캐릭터 레벨업 확인
- [ ] 타임캡슐 열기 애니메이션 테스트
- [ ] 성능 최적화
- [ ] 메모리 누수 확인
- [ ] 크래시 테스트

### 개발 중 확인사항
- [ ] NH 브랜드 가이드라인 준수
- [ ] 감정 캐릭터 일관성 유지
- [ ] 포인트 시스템 정확성
- [ ] 진입점 자동 구분 로직
- [ ] 반응형 디자인 적용
- [ ] 접근성 고려
- [ ] 다크모드 지원 (선택사항)

### 개발 후 테스트
- [ ] 각 화면 플로우 테스트
- [ ] 포인트 적립 확인
- [ ] 캐릭터 레벨업 확인
- [ ] 타임캡슐 열기 애니메이션
- [ ] 데이터 저장/불러오기 테스트
- [ ] 이미지 업로드/캐싱 테스트
- [ ] 공유 기능 테스트
- [ ] 성능 테스트

## 🚀 Cursor에 요청할 때 활용 팁

1. **단계별 요청**: 한 번에 모든 기능을 요청하지 말고 Phase별로 진행
2. **구체적인 요구사항**: 각 화면의 정확한 기능과 디자인 명시
3. **참고 코드 활용**: React 코드를 Flutter 코드로 변환 요청
4. **NH 브랜딩**: 색상과 디자인 가이드라인 명확히 전달
5. **체크리스트 활용**: 각 Phase 완료 후 체크리스트 확인

## 📋 구현 우선순위 매트릭스

| 기능 | 중요도 | 복잡도 | 우선순위 | 예상 소요시간 |
|------|--------|--------|----------|---------------|
| 홈화면 | 높음 | 중간 | 1 | 2-3일 |
| 타임캡슐 생성 | 높음 | 낮음 | 2 | 2일 |
| 개인형 타임캡슐 일기 | 높음 | 중간 | 3 | 2-3일 |
| 개인형 타임캡슐 열기 | 높음 | 높음 | 4 | 2-3일 |
| 일반 금융일기 | 중간 | 낮음 | 5 | 1-2일 |
| 모임형 타임캡슐 일기 | 중간 | 중간 | 6 | 2-3일 |
| 모임형 타임캡슐 열기 | 중간 | 높음 | 7 | 2-3일 |
| 월간 캐릭터 분석 | 중간 | 높음 | 8 | 2-3일 |
| 타임캡슐 캐릭터 분석 | 낮음 | 높음 | 9 | 2-3일 |

## 🎯 성공 지표

### 기술적 지표
- [ ] 앱 크래시율 < 1%
- [ ] 화면 로딩 시간 < 2초
- [ ] 메모리 사용량 < 100MB
- [ ] 배터리 소모 최적화

### 사용자 경험 지표
- [ ] 사용자 만족도 > 4.5/5
- [ ] 일일 활성 사용자 > 80%
- [ ] 타임캡슐 완료율 > 70%
- [ ] 포인트 적립 참여율 > 90%

이 가이드를 참고해서 체계적으로 구현해주세요.