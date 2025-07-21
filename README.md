# NH 금융 타임캡슐 v3 🏦✨

## 📖 프로젝트 개요

NH 금융 타임캡슐은 **금융과 함께하는 나만의 감정일기**를 컨셉으로 한 혁신적인 저축 및 습관 관리 앱입니다. 사용자들이 목표를 달성하면서 감정을 기록하고, 캐릭터와 함께 성장해나가는 재미있는 금융 관리 도구입니다.

## ✨ 주요 기능

### 🏡 홈 화면
- **나의 타임캡슐 정원**: 진행률에 따라 타임캡슐이 땅에서 서서히 나타나고, 100% 달성 시 하늘로 승천
- **실시간 진행률 표시**: 각 타임캡슐의 완성도와 이름이 명확히 표시
- **푸시 알림**: X 버튼으로 즉시 닫기 가능한 스마트 알림

### 💰 타임캡슐 생성
- **개인형/모임형 타임캡슐**: 다양한 목표 설정 가능
- **목표금액 없음 옵션**: 토글 방식으로 선택/해제 가능
- **습관 관리**: 독서, 러닝 등 일상 습관 추적

### 📝 금융일기 작성
- **무제한 타임캡슐**: 기간 제한 없이 자유롭게 기록
- **개인형/모임형 지원**: 모든 타입의 타임캡슐에서 일기 작성
- **습관별 맞춤 표시**: 독서/러닝은 일자 기반, 금융은 금액 기반으로 표시
- **AI 글쓰기 추천**: 감정과 상황에 맞는 맞춤형 콘텐츠 생성

### 🎭 감정 캐릭터 시스템
- **5가지 감정 캐릭터**: 기쁨이, 슬픔이, 분노, 불안이, 까칠이
- **레벨업 시스템**: 일기 작성으로 경험치 획득
- **캐릭터별 분석**: 월간/타임캡슐별 감정 패턴 분석

### 🏆 리워드 시스템
- **포인트 적립**: 일기 작성, 사진 첨부, 이정표 달성으로 포인트 획득
- **쿠폰 시스템**: 받은 쿠폰과 앞으로 받을 수 있는 쿠폰 모두 스크롤 가능
- **이정표 달성**: 카테고리별 맞춤 이정표 (저축/독서/러닝)

## 🛠️ 기술 스택

- **Framework**: Flutter 3.32.2
- **Language**: Dart
- **Platform**: Android, iOS, Web
- **Architecture**: Clean Architecture with Provider pattern
- **CI/CD**: GitHub Actions

## 📱 지원 플랫폼

- ✅ Android (API 21+)
- ✅ iOS (iOS 12.0+)
- ✅ Web (PWA 지원)

## 🚀 설치 및 실행

### 사전 요구사항
- Flutter SDK 3.32.2 이상
- Dart SDK 3.5.0 이상
- Android Studio / VS Code
- Git

### 클론 및 실행
```bash
# 리포지토리 클론
git clone https://github.com/Sqaure-JE/NH-time-capsule_v3.git

# 프로젝트 디렉토리로 이동
cd NH-time-capsule_v3

# 의존성 설치
flutter pub get

# 앱 실행 (개발 모드)
flutter run

# 빌드 (릴리즈 모드)
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

## 📁 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   ├── time_capsule.dart
│   ├── user_data.dart
│   ├── emotion_character.dart
│   └── ...
├── screens/                  # UI 화면
│   ├── home/
│   ├── capsule/
│   ├── diary/
│   └── analysis/
├── widgets/                  # 재사용 가능한 위젯
├── utils/                    # 유틸리티 함수
└── services/                 # 비즈니스 로직
```

## 🎯 주요 업데이트 (v3)

### ✨ UI/UX 개선
- 홈 화면 subtitle: "금융과 함께하는 나만의 감정일기"로 변경
- 타임캡슐 정원의 시각적 개선 (흙 비율 증가, 진행률 표시)
- 완성된 타임캡슐의 "하늘 승천" 애니메이션

### 🔧 기능 개선
- "매일러닝" → "러닝" 카테고리로 통합
- 습관형 타임캡슐의 일자 기반 진행률 표시
- 100% 완료된 타임캡슐 자동 숨김 (일기 작성/분석 목록에서)
- 쿠폰 모달의 양방향 스크롤 지원

### 🐛 버그 수정
- "Infinity" 오류 해결 (습관형 타임캡슐 진행률 계산)
- 푸시 알림 X 버튼 동작 개선
- 타임캡슐 생성 시 "목표금액 없음" 토글 기능 개선

## 🤝 기여 방법

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 연락처

- **개발팀**: Sqaure-JE
- **GitHub**: [https://github.com/Sqaure-JE/NH-time-capsule_v3](https://github.com/Sqaure-JE/NH-time-capsule_v3)

## 🌟 스크린샷

### 홈 화면
- 타임캡슐 정원과 진행률 표시
- 감정 캐릭터 상태

### 일기 작성
- 감정 선택과 이정표 설정
- AI 추천 글쓰기 기능

### 캐릭터 분석
- 월간 감정 패턴 분석
- 카테고리별 맞춤 분석

---

**NH 금융 타임캡슐 v3**로 더 스마트하고 재미있는 금융 관리를 경험해보세요! 🎉
