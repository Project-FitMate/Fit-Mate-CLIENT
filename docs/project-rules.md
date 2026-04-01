# FitMate Project Rules

FitMate Flutter 클라이언트 개발 시 팀이 공통으로 따를 기본 규칙입니다.

## 1. Architecture

- 프로젝트는 `feature-first + MVVM` 구조를 사용합니다.
- 공통 코드는 `core`, 재사용 UI는 `shared`, 기능 단위 코드는 `features` 아래에 둡니다.
- 현재 핵심 기능은 아래 4개 feature를 기준으로 나눕니다.
  - `upload`
  - `styling_condition`
  - `recommendation`
  - `result`
- 기능이 커지더라도 우선은 위 구조를 유지하고, 필요할 때만 추가 레이어를 도입합니다.

## 2. Directory Rules

- `lib/core`
  - 앱 전역에서 공통으로 쓰는 코드만 둡니다.
  - 예: 상수, 테마, 네트워크, 유틸
- `lib/shared`
  - 두 개 이상의 feature에서 재사용하는 UI만 둡니다.
  - 특정 feature에만 쓰는 위젯은 해당 feature 내부에 둡니다.
- `lib/features/<feature>`
  - 각 feature는 아래 구조를 기본으로 사용합니다.

```text
feature/
├── model/
├── view/
├── viewmodel/
└── widget/
```

## 3. Responsibility by Layer

- `model`
  - 화면 또는 기능에서 사용하는 데이터 구조를 정의합니다.
  - 지나치게 많은 로직을 넣지 않습니다.
- `view`
  - 화면 UI를 담당합니다.
  - 가능한 한 상태 계산 로직은 직접 들고 있지 않습니다.
- `viewmodel`
  - 화면 상태와 액션을 관리합니다.
  - 현재 기준으로는 `ChangeNotifier` 기반을 사용합니다.
- `widget`
  - 해당 feature 안에서만 사용하는 세부 UI 조각을 둡니다.

## 4. Naming Rules

- 파일명은 `snake_case.dart`를 사용합니다.
- 클래스명은 `PascalCase`를 사용합니다.
- 화면 위젯은 `...View`로 끝냅니다.
  - 예: `UploadView`
- ViewModel 클래스는 `...ViewModel`로 끝냅니다.
  - 예: `UploadViewModel`
- 공용 버튼/카드 같은 위젯은 역할이 드러나는 이름을 사용합니다.
  - 예: `PrimaryActionButton`

## 5. UI and Implementation Rules

- 구조를 먼저 잡는 PR에서는 placeholder 또는 최소 골격만 작성해도 됩니다.
- 화면 구현 요청이 없는 경우, 상세 UI를 과하게 완성하지 않습니다.
- 네비게이션, API 연동, 상태 공유는 요청 범위 안에서만 구현합니다.
- 공통 스타일은 `core/theme` 또는 `core/constants`에서 관리합니다.
- 모바일 화면은 다양한 높이에서 깨지지 않도록 반응형으로 작성합니다.
- 큰 세로 간격이나 카드 높이를 고정값으로만 처리하지 않습니다.
- `LayoutBuilder`, `Flexible`, 스크롤 가능한 레이아웃을 우선 검토합니다.

## 6. State Management Rules

- 현재는 `ChangeNotifier` 기반 MVVM을 기본으로 합니다.
- 단순 화면 상태는 각 feature의 `viewmodel`에서 관리합니다.
- 여러 feature가 공유하는 상태가 생기기 전까지는 전역 상태 관리 도구를 도입하지 않습니다.

## 7. Collaboration Rules

- `develop` 브랜치에 직접 작업하지 않습니다.
- 기능 단위 브랜치를 생성해 작업합니다.
- 하나의 PR은 하나의 목적만 담도록 합니다.
  - 예: 구조 세팅, 특정 화면 구현, API 연동
- Flutter가 익숙하지 않은 팀원도 이해할 수 있도록 구조와 의도를 명확히 유지합니다.
- 작업이 커지기 전에, 의미 있는 단위로 자주 커밋합니다.
  - 예: 레이아웃 완성, 공용 위젯 정리, 네비게이션 연결

## 8. PR Rules

- PR 본문에는 아래 내용을 포함합니다.
  - 작업 목적
  - 변경 범위
  - 아직 하지 않은 것
  - 검증 방법
- 구조 PR에서는 반드시 “구조만 세팅한 PR”인지 여부를 명시합니다.

## 9. Commit Rules

- 커밋은 너무 커지기 전에, 하나의 논리적 변경 단위로 나눕니다.
- 화면 구현 중에도 아래 기준을 넘기면 중간 커밋을 남깁니다.
  - 한 화면의 레이아웃이 안정적으로 잡혔을 때
  - 공용 위젯을 분리했을 때
  - 상태 관리 또는 네비게이션 연결이 완료됐을 때
- “작업 중간 저장”이 아니라, 되돌릴 수 있는 의미 단위 커밋을 목표로 합니다.
- 추천 예시
  - `feat: implement upload screen layout`
  - `refactor: extract shared action button`
  - `docs: update feature workflow rules`

## 10. Validation

- 코드 변경 후 아래 검증을 기본으로 합니다.

```bash
flutter analyze
flutter test
```

## 11. Future Expansion

- 인증 기능은 추후 별도 feature로 확장합니다.
- API 연결이 본격화되면 feature 내부에 `repository` 또는 `data` 레이어 도입을 검토합니다.
- 기능이 커지면 `upload`, `styling_condition`, `recommendation`, `result`를 하나의 흐름으로 묶는 구조를 다시 검토할 수 있습니다.
