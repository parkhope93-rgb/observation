# Observatory — Flutter starter

웹 / iOS / Android용 개인 프로젝트 관리 앱의 첫 MVP입니다.

## 포함된 기능
- 이메일 회원가입 / 로그인 (Supabase Auth)
- 카테고리 목록 및 카테고리 생성
- 카테고리별 Projects / Tasks / Schedule 탭
- 프로젝트 생성 및 진행률 / 마감일 표시
- 독립 Task 및 프로젝트 하위 Task 저장 구조
- 일정(Event) 등록 및 목록
- 홈 대시보드: 프로젝트 카드 + Tasks + Schedule

## 1. Supabase 준비
1. Supabase 프로젝트를 생성합니다.
2. SQL Editor에서 `supabase_schema.sql` 전체를 실행합니다.
3. Project Settings → API에서 Project URL과 anon/publishable key를 확인합니다.

## 2. Flutter 실행
```bash
flutter pub get
flutter run -d chrome --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

macOS / iOS Simulator:
```bash
flutter run -d ios --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

## 3. 프로젝트 폴더로 사용하기
압축을 푼 폴더에서 `flutter create . --platforms=web,ios,android`를 한 번 실행한 뒤 위 명령을 실행하면 됩니다.

## 데이터 구조
- `categories`: 최상위 카테고리
- `projects`: 반드시 하나의 카테고리에 속함
- `tasks`: 반드시 하나의 카테고리에 속함. `project_id`가 NULL이면 독립 태스크, 값이 있으면 해당 프로젝트의 하위 태스크
- `events`: 카테고리에 속하는 일정

프로젝트 하위 Task는 DB 트리거가 프로젝트의 category_id를 자동으로 따라가게 합니다. RLS는 로그인한 사용자 본인의 데이터만 접근하도록 설정되어 있습니다.

## 다음 개발 단계
현재 코드는 첫 동작 확인용 MVP입니다. 다음 단계에서 프로젝트 상세 페이지, 작업 편집/삭제, 월간 캘린더 UI, 카테고리 색상 선택, 프로젝트 진행률 자동 계산, 검색/필터를 추가하는 것이 좋습니다.
