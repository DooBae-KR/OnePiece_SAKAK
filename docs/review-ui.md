# 담당자 검토 UI — 핵심 기능 02

기준: feature/double-check-engine (f603ec6). 기존 시민 화면, Supabase 테이블 및 AI 엔진 API를 유지한다.

## 변경 사항
- 결재선 부서·순번에 따라 접수/심사/승인 화면과 오류 상세 및 증빙 표시 범위를 분리.
- 현재 단계만 처리, 이전 단계는 상태만 표시, 이후 단계는 숨김.
- 오탈자 참조값 대조, 단계별 담당자 확인 후 전달, 기존 상태 조건으로 갱신.
- 증빙 파일명 또는 시연용 문서 유형 기준의 열람 범위와 wf_view_log 연동.

## 실행 및 테스트
기존 README의 Supabase 및 AI 엔진 설정을 따른다. 별도 마이그레이션 없음.
node tests/review-workflow.test.js — 권한/단계 판정 테스트 19개 통과. 브라우저·원격 DB·AI 엔진 통합 테스트는 미진행.

## 제한
합성 데이터 전용 UI 시연이다. 기존 RLS 공개 접근 정책 때문에 실제 인증이나 서버측 접근 제어를 제공하지 않는다. 개인정보 입력 금지. 문서 종류 매핑은 시연용이고 재검증은 참조값 대조이며 전체 AI 재실행이 아니다. 실제 결재·급여 결정은 수행하지 않는다.

상세 기획 및 작업 기록: https://app.notion.com/p/41d9ffcd2d168178bdc3c52e8e7a8963

## 추가 통합 검증 (모의 API)
`node tests/review-integration.test.js` — 15개 통과. 실제 index.html의 JS와 권한 모듈을 모의 DOM 및 Supabase/AI 응답으로 실행했다. 실제 브라우저, 운영 DB, 실제 AI 판독은 아직 미검증이다. 실 DB 변경 없음.

## 실제 API 연결 점검
`python3 tests/live_api_smoke.py`로 Supabase 읽기 4종과 로컬 AI health 확인. 합성 PDF/TXT 및 해당 절차·서류 ID를 `--fixture`, `--proc-id`, `--doc-id`로 지정하면 엔진 POST 2종도 확인한다. 공유 DB 쓰기는 하지 않는다. 현재 실행 환경에서 DNS 해석 실패, 로컬 엔진 연결 거부로 실제 API 결과 미검증.
