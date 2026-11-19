insert into public.wf_procedures values('s1','시나리오 1. 실직 후 생계 곤란','주민센터 복지팀','긴급복지지원(기초생활보장) 신청서','생활·복지','긴급복지지원·기초생활보장 급여 신청','실직 등으로 생계가 어려워진 가구가 긴급복지지원 또는 기초생활보장 급여를 신청합니다.','실직·소득 단절로 생계가 곤란한 가구 (시연용 예시)','온라인으로 서류를 첨부해 기안한 뒤, 신청서와 동의서는 주민센터를 방문해 작성합니다.','["선행 절차: 고용센터에서 실업급여 신청과 구직 등록 결과를 먼저 확인하세요. (시연 가정)", "같은 소득·재산 서류를 다시 내지 않도록 정부24 연계 서류를 자동으로 대조합니다.", "이직일과 소득 신고 시점이 다르면 담당자 검토로 분류될 수 있습니다."]'::jsonb,0);
insert into public.wf_proc_docs values('s1','s1d1','긴급복지지원(기초생활보장) 신청서','manual','필수 신청서',null,'[]'::jsonb,null,0);
insert into public.wf_proc_docs values('s1','s1d2','소득·재산 확인 동의서','manual','필수 신청서',null,'[]'::jsonb,null,1);
insert into public.wf_proc_docs values('s1','s1d3','이직확인서 (고용센터 발급)','gov24','필수',95,'["이직"]'::jsonb,'이직일: 첨부 2026-10-31 ↔ 고용보험 연계 2026-11-05 (기관 간 시차, 합성 예시)',2);
insert into public.wf_proc_docs values('s1','s1d4','임대차계약서','upload','해당자',92,'["임대"]'::jsonb,null,3);
insert into public.wf_proc_docs values('s1','s1d5','통장 사본','upload','필수',91,'["통장"]'::jsonb,null,4);
insert into public.wf_proc_docs values('s1','s1d6','소득·재산 확인 서류','gov24','필요 시',95,'["소득", "재산"]'::jsonb,null,5);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s1_c2','s1','김민수(합성)','citizen-0002','1974-05-21','긴급복지지원(기초생활보장) 신청서','',96,'[]'::jsonb,null);
insert into public.wf_case_docs values('s1_c2','s1d3',97,'ok',null,null);
insert into public.wf_case_docs values('s1_c2','s1d4',95,'ok',null,null);
insert into public.wf_case_docs values('s1_c2','s1d5',96,'ok',null,null);
insert into public.wf_case_docs values('s1_c2','s1d6',94,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s1_c3','s1','이영희(합성)','citizen-0003','1981-09-02','긴급복지지원(기초생활보장) 신청서','',94,'[]'::jsonb,null);
insert into public.wf_case_docs values('s1_c3','s1d3',95,'ok',null,null);
insert into public.wf_case_docs values('s1_c3','s1d4',93,'ok',null,null);
insert into public.wf_case_docs values('s1_c3','s1d5',94,'ok',null,null);
insert into public.wf_case_docs values('s1_c3','s1d6',96,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s1_c4','s1','박철수(합성)','citizen-0004','1978-02-14','긴급복지지원(기초생활보장) 신청서','사각지대: 실직 시점(10월)과 소득 신고 시점(분기 말)의 시차로 실업급여와 긴급복지가 이중 수급될 위험',61,'["사각지대: 실직 시점(10월)과 소득 신고 시점(분기 말)의 시차로 실업급여와 긴급복지가 이중 수급될 위험", "서류 불일치 의심: 임대차계약서, 통장 사본, 소득·재산 확인 서류"]'::jsonb,null);
insert into public.wf_case_docs values('s1_c4','s1d3',88,'ok',null,null);
insert into public.wf_case_docs values('s1_c4','s1d4',41,'wrong',null,null);
insert into public.wf_case_docs values('s1_c4','s1d5',62,'wrong',null,null);
insert into public.wf_case_docs values('s1_c4','s1d6',54,'wrong',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s1_c5','s1','정우진(합성)','citizen-0005','1985-07-30','긴급복지지원(기초생활보장) 신청서','',97,'[]'::jsonb,'{"k": "c5", "field": "이름", "wrong": "정우짐", "right": "정우진"}'::jsonb);
insert into public.wf_case_docs values('s1_c5','s1d3',98,'ok',null,null);
insert into public.wf_case_docs values('s1_c5','s1d4',97,'ok',null,null);
insert into public.wf_case_docs values('s1_c5','s1d5',96,'ok',null,null);
insert into public.wf_case_docs values('s1_c5','s1d6',98,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s1_c6','s1','최지은(합성)','citizen-0006','1983-11-09','긴급복지지원(기초생활보장) 신청서','사각지대: 직전 직장 소득이 아직 남아 있어 소득 단절이 정상으로 읽힐 위험',92,'["사각지대: 직전 직장 소득이 아직 남아 있어 소득 단절이 정상으로 읽힐 위험"]'::jsonb,null);
insert into public.wf_case_docs values('s1_c6','s1d3',92,'ok',null,null);
insert into public.wf_case_docs values('s1_c6','s1d4',90,'ok',null,null);
insert into public.wf_case_docs values('s1_c6','s1d5',93,'ok',null,null);
insert into public.wf_case_docs values('s1_c6','s1d6',91,'ok',null,null);
insert into public.wf_procedures values('s2','시나리오 2. 부모 장기요양·장애 대리신청','건강보험공단 장기요양운영센터','노인장기요양 인정 신청서','돌봄·장애','노인장기요양 인정·장애인 등록 신청','거동이 어려워진 부모를 위해 노인장기요양 등급과 장애인 등록을 신청합니다. 자녀 등 가족이 대리 신청할 수 있습니다.','장기요양 또는 장애 판정이 필요한 본인, 대리 신청 시 가족 (시연용 예시)','온라인으로 서류를 첨부해 기안한 뒤, 신청서와 본인 의사 확인서는 현장방문으로 작성합니다.','["대리 신청은 위임장과 본인 의사 확인서, 가족관계 확인이 필요합니다.", "판정 결과가 나오기 전까지 임시 지원 연계를 안내받을 수 있습니다. (시연 가정)", "서류 위·변조나 본인 의사 불확인이 의심되면 담당자 검토로 분류됩니다."]'::jsonb,1);
insert into public.wf_proc_docs values('s2','s2d1','노인장기요양 인정 신청서','manual','필수 신청서',null,'[]'::jsonb,null,0);
insert into public.wf_proc_docs values('s2','s2d2','본인 의사 확인서 (대리 신청 시 본인 서명)','manual','대리 신청 시',null,'[]'::jsonb,null,1);
insert into public.wf_proc_docs values('s2','s2d3','의사소견서','upload','필수',93,'["소견"]'::jsonb,null,2);
insert into public.wf_proc_docs values('s2','s2d4','장애진단서','upload','필수',94,'["장애"]'::jsonb,null,3);
insert into public.wf_proc_docs values('s2','s2d5','대리신청 위임장','upload','대리 신청 시',90,'["위임"]'::jsonb,null,4);
insert into public.wf_proc_docs values('s2','s2d6','대리인 관계 확인 서류 (가족관계)','gov24','대리 신청 시',96,'["가족", "관계"]'::jsonb,'대리인 관계: 첨부 자녀 ↔ 정부24 가족관계 확인값 불일치 (합성 예시)',5);
insert into public.wf_proc_docs values('s2','s2d7','소득 증빙 서류','gov24','필요 시',95,'["소득"]'::jsonb,null,6);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s2_c2','s2','김민수(합성)','citizen-0002','1974-05-21','노인장기요양 인정 신청서','',95,'[]'::jsonb,null);
insert into public.wf_case_docs values('s2_c2','s2d3',96,'ok',null,null);
insert into public.wf_case_docs values('s2_c2','s2d4',95,'ok',null,null);
insert into public.wf_case_docs values('s2_c2','s2d5',94,'ok',null,null);
insert into public.wf_case_docs values('s2_c2','s2d6',97,'ok',null,null);
insert into public.wf_case_docs values('s2_c2','s2d7',95,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s2_c3','s2','이영희(합성)','citizen-0003','1981-09-02','노인장기요양 인정 신청서','',94,'[]'::jsonb,null);
insert into public.wf_case_docs values('s2_c3','s2d3',94,'ok',null,null);
insert into public.wf_case_docs values('s2_c3','s2d4',93,'ok',null,null);
insert into public.wf_case_docs values('s2_c3','s2d5',95,'ok',null,null);
insert into public.wf_case_docs values('s2_c3','s2d6',96,'ok',null,null);
insert into public.wf_case_docs values('s2_c3','s2d7',94,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s2_c4','s2','박철수(합성)','citizen-0004','1978-02-14','노인장기요양 인정 신청서','사각지대: 대리 신청인데 본인 의사 확인이 약하고 위임장 서명이 본인 필적과 다를 수 있음(위조·허위 판정 위험)',67,'["사각지대: 대리 신청인데 본인 의사 확인이 약하고 위임장 서명이 본인 필적과 다를 수 있음(위조·허위 판정 위험)", "서류 불일치 의심: 장애진단서, 대리신청 위임장, 대리인 관계 확인 서류 (가족관계)"]'::jsonb,null);
insert into public.wf_case_docs values('s2_c4','s2d3',90,'ok',null,null);
insert into public.wf_case_docs values('s2_c4','s2d4',52,'wrong','장애진단서_박철수_샘플(합성).pdf','["진단일이 신청일(2026-11-18)보다 뒤인 2026-12-03으로 적혀 있음", "발급번호 형식(2026-ZZ-99-0001)이 발급번호 규칙과 다름", "진단 의사 서명 필적이 같은 신청의 의사소견서와 다름"]'::jsonb);
insert into public.wf_case_docs values('s2_c4','s2d5',55,'wrong',null,null);
insert into public.wf_case_docs values('s2_c4','s2d6',49,'wrong',null,null);
insert into public.wf_case_docs values('s2_c4','s2d7',88,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s2_c5','s2','정우진(합성)','citizen-0005','1985-07-30','노인장기요양 인정 신청서','',97,'[]'::jsonb,'{"k": "c5", "field": "이름", "wrong": "정우짐", "right": "정우진"}'::jsonb);
insert into public.wf_case_docs values('s2_c5','s2d3',98,'ok',null,null);
insert into public.wf_case_docs values('s2_c5','s2d4',97,'ok',null,null);
insert into public.wf_case_docs values('s2_c5','s2d5',96,'ok',null,null);
insert into public.wf_case_docs values('s2_c5','s2d6',98,'ok',null,null);
insert into public.wf_case_docs values('s2_c5','s2d7',97,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s2_c6','s2','최지은(합성)','citizen-0006','1983-11-09','노인장기요양 인정 신청서','사각지대: 판정 대기 기간에 임시 지원 연계 정보가 비어 있음',92,'["사각지대: 판정 대기 기간에 임시 지원 연계 정보가 비어 있음"]'::jsonb,null);
insert into public.wf_case_docs values('s2_c6','s2d3',92,'ok',null,null);
insert into public.wf_case_docs values('s2_c6','s2d4',91,'ok',null,null);
insert into public.wf_case_docs values('s2_c6','s2d5',90,'ok',null,null);
insert into public.wf_case_docs values('s2_c6','s2d6',93,'ok',null,null);
insert into public.wf_case_docs values('s2_c6','s2d7',92,'ok',null,null);
insert into public.wf_procedures values('s3','시나리오 3. 가족 사망 후 상속·급여 정리','국민연금공단 유족연금팀','유족연금(사망일시금) 청구서','사망·상속','유족연금·사망일시금 청구 및 상속 정리','가족이 사망한 뒤 사망 신고, 유족연금(사망일시금) 청구, 건강보험 자격 변동을 함께 신청합니다.','배우자 등 가족이 사망한 유족 (시연용 예시)','온라인으로 서류를 첨부해 기안한 뒤, 사망 신고서와 청구서는 현장방문으로 작성합니다.','["기관마다 사망 정보가 반영되는 시점이 달라 연계 정보와 신청 내용이 다를 수 있습니다.", "사망 후에도 급여가 이어지는 사후 수급이 의심되면 담당자 검토로 분류됩니다.", "안심상속 원스톱 조회 결과를 함께 제출합니다. (시연 가정)"]'::jsonb,2);
insert into public.wf_proc_docs values('s3','s3d1','사망 신고서','manual','필수 신청서',null,'[]'::jsonb,null,0);
insert into public.wf_proc_docs values('s3','s3d2','유족연금(사망일시금) 청구서','manual','필수 신청서',null,'[]'::jsonb,null,1);
insert into public.wf_proc_docs values('s3','s3d3','사망진단서','upload','필수',95,'["사망진단"]'::jsonb,null,2);
insert into public.wf_proc_docs values('s3','s3d4','가족관계 기록사항에 관한 증명서','gov24','필수',96,'["가족"]'::jsonb,null,3);
insert into public.wf_proc_docs values('s3','s3d5','안심상속 재산 조회 결과','gov24','필수',94,'["상속"]'::jsonb,'사망일: 첨부 2026-10-28 ↔ 연계 정보 2026-11-03 반영 (기관 간 사망 정보 시차, 합성 예시)',4);
insert into public.wf_proc_docs values('s3','s3d6','건강보험 자격 변동 신고서','upload','필수',91,'["자격"]'::jsonb,null,5);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s3_c2','s3','김민수(합성)','citizen-0002','1974-05-21','유족연금(사망일시금) 청구서','',96,'[]'::jsonb,null);
insert into public.wf_case_docs values('s3_c2','s3d3',96,'ok',null,null);
insert into public.wf_case_docs values('s3_c2','s3d4',97,'ok',null,null);
insert into public.wf_case_docs values('s3_c2','s3d5',95,'ok',null,null);
insert into public.wf_case_docs values('s3_c2','s3d6',94,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s3_c3','s3','이영희(합성)','citizen-0003','1981-09-02','유족연금(사망일시금) 청구서','',94,'[]'::jsonb,null);
insert into public.wf_case_docs values('s3_c3','s3d3',95,'ok',null,null);
insert into public.wf_case_docs values('s3_c3','s3d4',94,'ok',null,null);
insert into public.wf_case_docs values('s3_c3','s3d5',96,'ok',null,null);
insert into public.wf_case_docs values('s3_c3','s3d6',93,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s3_c4','s3','박철수(합성)','citizen-0004','1978-02-14','유족연금(사망일시금) 청구서','사각지대: 사망 후에도 기초연금이 계속 지급 중으로 보임(기관 간 사망 정보 반영 시차, 사후 수급 의심)',90,'["사각지대: 사망 후에도 기초연금이 계속 지급 중으로 보임(기관 간 사망 정보 반영 시차, 사후 수급 의심)"]'::jsonb,null);
insert into public.wf_case_docs values('s3_c4','s3d3',91,'ok',null,null);
insert into public.wf_case_docs values('s3_c4','s3d4',90,'ok',null,null);
insert into public.wf_case_docs values('s3_c4','s3d5',89,'ok',null,null);
insert into public.wf_case_docs values('s3_c4','s3d6',92,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s3_c5','s3','정우진(합성)','citizen-0005','1985-07-30','유족연금(사망일시금) 청구서','',97,'[]'::jsonb,'{"k": "c5", "field": "이름", "wrong": "정우짐", "right": "정우진"}'::jsonb);
insert into public.wf_case_docs values('s3_c5','s3d3',98,'ok',null,null);
insert into public.wf_case_docs values('s3_c5','s3d4',97,'ok',null,null);
insert into public.wf_case_docs values('s3_c5','s3d5',96,'ok',null,null);
insert into public.wf_case_docs values('s3_c5','s3d6',98,'ok',null,null);
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,reasons,typo) values('s3_c6','s3','최지은(합성)','citizen-0006','1983-11-09','유족연금(사망일시금) 청구서','',61,'["서류 불일치 의심: 사망진단서, 가족관계 기록사항에 관한 증명서, 안심상속 재산 조회 결과, 건강보험 자격 변동 신고서"]'::jsonb,null);
insert into public.wf_case_docs values('s3_c6','s3d3',60,'wrong',null,null);
insert into public.wf_case_docs values('s3_c6','s3d4',55,'wrong',null,null);
insert into public.wf_case_docs values('s3_c6','s3d5',72,'wrong',null,null);
insert into public.wf_case_docs values('s3_c6','s3d6',58,'wrong',null,null);
-- 신청일자(가데이터)
update public.wf_cases c set created_at = v.d::timestamptz, updated_at = v.d::timestamptz from (values
('s1_c2','2026-11-03 10:20+09'),('s1_c3','2026-11-05 14:05+09'),('s1_c4','2026-11-09 09:40+09'),('s1_c5','2026-11-12 16:30+09'),('s1_c6','2026-11-16 11:15+09'),
('s2_c2','2026-11-04 13:00+09'),('s2_c3','2026-11-06 15:45+09'),('s2_c4','2026-11-10 10:10+09'),('s2_c5','2026-11-13 09:25+09'),('s2_c6','2026-11-17 14:50+09'),
('s3_c2','2026-11-02 11:30+09'),('s3_c3','2026-11-07 10:00+09'),('s3_c4','2026-11-11 13:40+09'),('s3_c5','2026-11-14 16:10+09'),('s3_c6','2026-11-18 09:55+09')
) as v(id,d) where c.id = v.id;

-- 기안자(홍길동) 신청함 시연용 데이터
insert into public.wf_cases(id,proc_id,applicant_name,applicant_ref,birth,form_name,blind,avg,status,reasons,typo,created_at,updated_at) values
('s1_c1','s1','홍길동(합성)','citizen-0001','1980-01-01','긴급복지지원(기초생활보장) 신청서','',95,'완료','[]'::jsonb,null,'2026-10-28 10:00+09','2026-10-30 15:00+09'),
('s2_c1','s2','홍길동(합성)','citizen-0001','1980-01-01','노인장기요양 인정 신청서','',96,'VALI오류','[]'::jsonb,'{"k":"c1","field":"이름","wrong":"홍길둥","right":"홍길동"}'::jsonb,'2026-11-15 11:20+09','2026-11-15 11:20+09'),
('s3_c1','s3','홍길동(합성)','citizen-0001','1980-01-01','유족연금(사망일시금) 청구서','',94,'체크완료','[]'::jsonb,null,'2026-11-18 09:30+09','2026-11-18 09:30+09');
insert into public.wf_case_docs values
('s1_c1','s1d3',97,'ok',null,null),('s1_c1','s1d4',95,'ok',null,null),('s1_c1','s1d5',96,'ok',null,null),('s1_c1','s1d6',94,'ok',null,null),
('s2_c1','s2d3',96,'ok',null,null),('s2_c1','s2d4',95,'ok',null,null),('s2_c1','s2d5',94,'ok',null,null),('s2_c1','s2d6',97,'ok',null,null),('s2_c1','s2d7',95,'ok',null,null),
('s3_c1','s3d3',95,'ok',null,null),('s3_c1','s3d4',96,'ok',null,null),('s3_c1','s3d5',94,'ok',null,null),('s3_c1','s3d6',93,'ok',null,null);
