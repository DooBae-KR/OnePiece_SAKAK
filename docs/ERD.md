# ERD (Supabase `wf_` 테이블)

```mermaid
erDiagram
    wf_procedures ||--o{ wf_proc_docs : "필요 서류 정의"
    wf_procedures ||--o{ wf_approval_line : "결재선(3단계)"
    wf_procedures ||--o{ wf_cases : "신청"
    wf_cases ||--o{ wf_case_docs : "제출 서류"
    wf_cases ||--o{ wf_view_log : "열람·열람요청 기록"

    wf_procedures {
        text id PK
        text title
        text dept "담당 부서"
        text form_name
        text cat
        text name
        text descr
        text target
        text how_to
        jsonb notes
        int sort
    }
    wf_proc_docs {
        text proc_id PK,FK
        text doc_id PK
        text name
        text kind "manual / gov24 / upload"
        text req
        int good "시연용 기준 점수"
        jsonb keys "파일명 키워드"
        text diff "정부24 불일치 예시"
        int sort
    }
    wf_approval_line {
        text proc_id PK,FK
        int seq PK "0=A 1=B 2=C"
        text label
        text dept
    }
    wf_cases {
        text id PK
        text proc_id FK
        text applicant_name
        text applicant_ref
        date birth
        text form_name
        text blind "사각지대 메모"
        int avg
        text status "접수/체크완료/AI심사/VALI오류/완료/반려"
        jsonb reasons
        jsonb typo
        int stage "현재 결재 단계"
        timestamptz created_at
        timestamptz updated_at
    }
    wf_case_docs {
        text case_id PK,FK
        text doc_id PK "wf_proc_docs.doc_id (FK 없음)"
        int sim
        text state "ok/wrong/mismatch/missing"
        text fname
        jsonb signs "위조 의심 징후"
    }
    wf_view_log {
        bigint id PK
        text case_id "FK 없음"
        text doc_id
        text dept
        timestamptz viewed_at
    }
```

## 참고
- `wf_case_docs.doc_id`는 `wf_proc_docs(proc_id, doc_id)`를 논리적으로 가리키지만 FK로 걸려 있지 않습니다.
- `wf_view_log.case_id`도 FK가 없습니다. 신청 건을 삭제해도 열람 기록은 남습니다.
- 모든 데이터는 시연용 합성 데이터입니다.
