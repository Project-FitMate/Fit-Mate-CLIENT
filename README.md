# FitMate Client

FitMate는 사용자의 사진을 기반으로 체형과 분위기를 분석하고, 조건에 맞는 의류를 추천한 뒤 AI 가상 피팅 이미지를 생성해주는 Flutter 기반 모바일 애플리케이션입니다.

이 레포지토리는 FitMate 프로젝트의 Flutter 클라이언트 앱을 담당합니다.

## Project Overview

FitMate는 생성형 AI 기술을 활용해 온라인 쇼핑에서도 실제 피팅에 가까운 경험을 제공하는 것을 목표로 합니다.

사용자는 자신의 사진을 업로드하고 스타일 및 가격 조건을 설정한 뒤, 자신에게 어울리는 의류를 추천받을 수 있습니다. 이후 선택한 상품을 바탕으로 가상 착용 이미지를 생성해 보다 직관적으로 구매 결정을 내릴 수 있습니다.

## Main Features

- 홈/업로드
  - 사용자 사진 업로드
  - 카메라 촬영
  - 가상 피팅 시작
- 추천 조건 설정
  - 제품 검색
  - 착용 부위 선택
  - 가격 범위 설정
  - 정렬 기준 선택
- 추천 상품 목록
  - AI 기반 의류 추천
  - 상품 선택
  - 카테고리 및 필터 조회
- 가상 피팅 결과
  - AI 착용 이미지 생성
  - 결과 저장 및 재생성
  - 추천 상품 및 구매 링크 제공
- 인증
  - 향후 확장 예정

## Directory Structure

현재 프로젝트는 feature-first + MVVM 기준으로 구조를 정리하고 있습니다.

```text
lib/
├── core/
│   ├── constants/   # 전역 상수
│   ├── network/     # API 클라이언트 및 네트워크 기본 계층
│   ├── theme/       # 앱 공통 테마
│   └── utils/       # 공통 유틸리티
├── shared/
│   └── widgets/     # 여러 feature에서 재사용하는 공통 위젯
├── features/
│   ├── upload/              # 사진 업로드 및 시작 화면
│   ├── styling_condition/   # 추천 조건 설정
│   ├── recommendation/      # 추천 상품 목록 및 선택
│   └── result/              # 가상 피팅 결과
└── main.dart
```

각 feature는 아래 구조를 따릅니다.

```text
feature/
├── model/      # 화면/기능에 필요한 모델
├── view/       # 화면 UI
├── viewmodel/  # 상태 및 액션 관리
└── widget/     # feature 내부 전용 위젯
```

## Current Development Policy

- 초기 PR에서는 기능 완성보다 구조 정리와 역할 분담이 우선입니다.
- 현재 파일들은 placeholder 또는 최소 골격 위주로 구성되어 있습니다.
- 실제 화면 구현, 네비게이션, API 연동은 이후 PR에서 순차적으로 진행합니다.

## Getting Started

```bash
flutter pub get
flutter run
```

## Validation

```bash
flutter analyze
flutter test
```
