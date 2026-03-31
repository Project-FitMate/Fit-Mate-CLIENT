# AGENTS.md

This file defines repository-specific rules for AI coding agents working in this project.

## Project Goal

FitMate is a Flutter mobile app that:

- uploads a user photo
- configures styling conditions
- recommends clothing items
- generates AI-based virtual try-on results

## Required Architecture

- Use `feature-first + MVVM`.
- Keep app-wide code in `lib/core`.
- Keep reusable shared widgets in `lib/shared/widgets`.
- Keep feature-specific code in `lib/features/<feature>`.

## Feature Structure

Every feature should follow this layout unless explicitly told otherwise:

```text
feature/
├── model/
├── view/
├── viewmodel/
└── widget/
```

## Naming

- Dart file names must use `snake_case.dart`.
- Widget classes use `PascalCase`.
- Screen widgets must end with `View`.
- ViewModel classes must end with `ViewModel`.

## Implementation Constraints

- Do not implement full UI unless the user explicitly asks for it.
- If the request is about structure, create placeholders and skeleton files only.
- Do not invent extra architecture layers unless needed for the request.
- Prefer minimal, readable starter code over speculative abstractions.
- Use `ChangeNotifier` for ViewModels unless the user asks for a different state management solution.

## Shared Code Rules

- Put code in `shared` only when it is reused by 2 or more features.
- Keep feature-only widgets inside that feature's `widget` folder.
- Put theme, constants, utilities, and network base code in `core`.

## Git Workflow

- Do not work directly on `develop`.
- Keep commits scoped to one logical change.
- For structure/setup PRs, keep the PR focused on layout and starter files.

## Validation

Run these when code changes are made:

```bash
flutter analyze
flutter test
```

## Current Preferred Features

The current primary features are:

- `upload`
- `styling_condition`
- `recommendation`
- `result`

Authentication is planned but not required in the initial structure PR.
