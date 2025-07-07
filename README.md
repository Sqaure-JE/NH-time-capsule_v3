# NH Time Capsule v2

농협 타임캡슐 앱 - 감정 기반 금융 저축 플랫폼

## 📱 프로젝트 소개

NH Time Capsule은 감정 캐릭터와 함께하는 특별한 금융 저축 경험을 제공하는 Flutter 웹 애플리케이션입니다.

### 주요 기능

- **🎭 감정 캐릭터 시스템**: 저축 과정에서 감정 변화를 캐릭터로 표현
- **📝 금융 일기**: 개인형, 모임형, 일반형 금융 일기 작성
- **🎯 타임캡슐**: 목표 기반 저축 시스템
- **📊 감정 분석**: 월간 및 캡슐별 감정 여정 분석
- **👥 모임 기능**: 친구들과 함께하는 그룹 저축

## 🚀 배포

이 프로젝트는 GitHub Actions를 통해 자동으로 배포됩니다.

**배포 URL**: https://sqaure-je.github.io/NH-time-capsule_v2/

### 자동 배포 설정

- `main` 브랜치에 푸시할 때마다 자동으로 GitHub Pages에 배포
- Flutter 웹 빌드 후 `gh-pages` 브랜치에 자동 배포
- 실시간 업데이트 반영

## 🛠 기술 스택

- **Framework**: Flutter 3.24.0
- **Language**: Dart
- **Platform**: Web
- **Deployment**: GitHub Pages
- **CI/CD**: GitHub Actions

## 📁 프로젝트 구조

```
lib/
├── models/          # 데이터 모델
├── screens/         # 화면 구성
│   ├── analysis/    # 분석 화면
│   ├── capsule/     # 타임캡슐 화면
│   ├── diary/       # 일기 화면
│   └── home/        # 홈 화면
├── services/        # 서비스 로직
├── utils/          # 유틸리티
└── widgets/        # 공통 위젯
```

## 🎨 디자인 시스템

- **색상**: NH 브랜드 컬러 기반
- **Typography**: 한국어 최적화 폰트
- **Layout**: 반응형 웹 디자인
- **Animation**: Flutter 기본 애니메이션

## 📝 개발 가이드

### 로컬 개발 환경 설정

```bash
# 의존성 설치
flutter pub get

# 웹 활성화
flutter config --enable-web

# 로컬 서버 실행
flutter run -d chrome
```

### 빌드

```bash
# 웹 빌드
flutter build web --release --web-renderer html
```

## 🔄 업데이트 히스토리

- **v2.0**: 감정 캐릭터 시스템 및 타임캡슐 기능 추가
- **v1.0**: 기본 금융 일기 기능

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.

---

💡 **Tip**: 코드 수정 후 `main` 브랜치에 푸시하면 자동으로 웹사이트가 업데이트됩니다!
