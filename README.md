# 복지행정 오류·사각지대 점검 서비스 입니다.

## AI Double Check 판독 엔진 연동 (핵심 기능 01)
`index.html`은 판독 엔진이 켜져 있으면 **첨부 파일의 내용을 실제로 읽어** 서류 종류·원본 대조·정책 검증을 하고,
꺼져 있으면 기존 시연 방식(파일 이름 키워드)으로 동작합니다. 화면 상단에 어느 쪽인지 표시됩니다.

### 실행
```bash
# 1) 판독 엔진 (welfare_ai 저장소)
python3 welfare_ai/src/server.py          # http://127.0.0.1:8787, 규칙 판독
python3 welfare_ai/src/server.py --ai     # Gemini 판독까지 (welfare_ai/.env 의 무료 키 사용, 하루 한도 있음)
# 2) 앱: index.html 을 브라우저로 열기
```

### DB 변경 (Supabase SQL Editor에서 1회)
`migrations/002_double_check.sql`
- `wf_cases.findings`(jsonb) 칸 추가: 엔진의 점검 결과(오류·담당·근거 문장·원본값·조치)
- 엔진이 실제 서류를 점검한 시연 신청 3건(`s1_dc`, `s2_dc`, `s3_dc`) 추가
- 적용 전에도 앱은 동작합니다. 신청 제출 시 findings 칸이 없으면 요약(reasons)만 저장합니다.

### 화면에서 달라진 점
- 시민 기안: 서류를 첨부하면 엔진이 내용을 읽어 맞는 서류인지 판정 (틀리면 "판독 결과: ○○" 안내).
  서류 안에 판독을 조작하려는 문장이 있으면 담당자 확인 안내.
- 기안 제출: 신청 전체를 엔진이 점검해 칸별 상태(일치·정부24 대조 불일치·서류 불일치·미첨부)와 점검 결과를 저장.
- 담당자 결재함: **"AI Double Check 점검 결과"를 결재선 단계별로** 표시 — 결재자 A(접수: 입력 오류) ·
  B(심사: 자격 오류) · C(승인: 종합 검토). 현재 단계는 노란색. 오류마다 근거 문장·원본값·조치.

### 엔진 API
| 주소 | 입력 | 출력 |
|---|---|---|
| `GET /api/health` | — | `{ok, ai}` |
| `POST /api/check-doc` | `{proc_id, doc_id, filename, data(base64)}` | `{state: ok|wrong, sim, detected_type, fields, suspicious}` |
| `POST /api/check-case` | `{proc_id, docs: {doc_id: {filename, data}}}` | `{summary, findings[], docs: {doc_id: {state, sim}}}` |

- 엔진은 127.0.0.1에서만 열리고, 로컬에서 연 앱만 호출할 수 있습니다(CORS). 파일은 판독 후 바로 지웁니다.
- PDF·텍스트만 판독합니다(스캔 이미지는 다음 단계). 모든 데이터는 합성 데이터입니다.
