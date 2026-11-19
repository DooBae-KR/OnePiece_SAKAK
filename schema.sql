
create table public.wf_procedures(
  id text primary key, title text not null, dept text not null, form_name text not null, cat text not null,
  name text not null, descr text, target text, how_to text, notes jsonb not null default '[]', sort int not null default 0);
create table public.wf_proc_docs(
  proc_id text not null references public.wf_procedures(id) on delete cascade, doc_id text not null,
  name text not null, kind text not null check (kind in ('manual','gov24','upload')), req text,
  good int, keys jsonb not null default '[]', diff text, sort int not null default 0, primary key(proc_id, doc_id));
create table public.wf_cases(
  id text primary key, proc_id text not null references public.wf_procedures(id) on delete cascade,
  applicant_name text not null, applicant_ref text, birth date, form_name text, blind text not null default '',
  avg int, status text not null default '접수' check (status in ('접수','체크완료','AI심사','VALI오류','완료','반려')),
  reasons jsonb not null default '[]', typo jsonb, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table public.wf_case_docs(
  case_id text not null references public.wf_cases(id) on delete cascade, doc_id text not null,
  sim int, state text not null default 'ok' check (state in ('ok','wrong','mismatch','missing')), fname text, signs jsonb,
  primary key(case_id, doc_id));
create table public.wf_view_log(
  id bigserial primary key, case_id text, doc_id text, dept text, viewed_at timestamptz not null default now());
create index on public.wf_cases(proc_id);
alter table public.wf_procedures enable row level security;
alter table public.wf_proc_docs enable row level security;
alter table public.wf_cases enable row level security;
alter table public.wf_case_docs enable row level security;
alter table public.wf_view_log enable row level security;
-- 시연용(합성 데이터 전용) 정책: 안내·서류 정의는 읽기만, 신청 카드와 서류 상태는 CRUD, 열람 기록은 쓰기·읽기
create policy wf_proc_read on public.wf_procedures for select to anon, authenticated using (true);
create policy wf_pdocs_read on public.wf_proc_docs for select to anon, authenticated using (true);
create policy wf_cases_all on public.wf_cases for all to anon, authenticated using (true) with check (true);
create policy wf_cdocs_all on public.wf_case_docs for all to anon, authenticated using (true) with check (true);
create policy wf_log_ins on public.wf_view_log for insert to anon, authenticated with check (true);
create policy wf_log_sel on public.wf_view_log for select to anon, authenticated using (true);
comment on table public.wf_cases is '시연용 합성 신청 카드. 실제 개인정보를 넣지 않는다.';
