'use strict';
const fs=require('node:fs');
const path=require('node:path');
const assert=require('node:assert/strict');
async function testFlow(html,workflow,assert){
 const clone=x=>JSON.parse(JSON.stringify(x)),trace=[],logs=[],passed=[];
 const procs=[{id:'s1',name:'긴급복지지원',dept:'주민센터 복지팀',form_name:'합성 신청서',cat:'복지',descr:'가상',notes:[]}];
 const lines=['주민센터 복지팀','시청 복지정책과','시청 복지국'].map((dept,seq)=>({proc_id:'s1',seq,dept,label:'결재자 '+'ABC'[seq]}));
 const defs=[{proc_id:'s1',doc_id:'d1',name:'신청서',kind:'manual'},{proc_id:'s1',doc_id:'d2',name:'소득증빙',kind:'gov24'},{proc_id:'s1',doc_id:'d3',name:'첨부자료',kind:'upload'}];
 const findings=['접수','심사','승인'].map((role,stage_seq)=>({role,stage_seq,title:role+' 전용 확인',severity:'high',detail:'가상 검토',evidence:stage_seq===1?[{doc:'소득.pdf',field:'소득',excerpt:'가상 수치'}]:[]}));
 const cases=[{id:'typo',proc_id:'s1',applicant_name:'가상 이름',applicant_ref:'other',form_name:'오탈자 사례',stage:0,status:'접수',reasons:[],findings:[],typo:{field:'이름',wrong:'오타',right:'정상'},created_at:'2026-11-20T00:00:00Z',wf_case_docs:[]}];
 const response=(data,status=200)=>({ok:status<400,status,json:async()=>clone(data),text:async()=>JSON.stringify(data)});
 let conflict=false;
 async function fetchMock(url,opt={}){
  const method=opt.method||'GET',body=opt.body?JSON.parse(opt.body):null;trace.push({url,method,body});
  if(url.endsWith('/api/health'))return response({ai:true});
  if(url.endsWith('/api/check-case'))return response({findings,docs:{d2:{state:'mismatch',sim:95},d3:{state:'ok',sim:100}}});
  const path=url.split('/rest/v1/')[1];if(!path)throw Error('Unexpected endpoint '+url);
  const [table,query='']=path.split('?');const params=Object.fromEntries(query.split('&').filter(Boolean).map(s=>{const i=s.indexOf('=');return [s.slice(0,i),decodeURIComponent(s.slice(i+1))]}));
  if(method==='GET')return response(({wf_procedures:procs,wf_proc_docs:defs,wf_approval_line:lines,wf_cases:cases})[table]||[]);
  if(table==='wf_cases'&&method==='POST'){cases.push({stage:0,status:'접수',created_at:'2026-11-20T00:00:00Z',wf_case_docs:[],...clone(body)});return response([cases.at(-1)],201)}
  if(table==='wf_case_docs'&&method==='POST'){for(const d of body)cases.find(c=>c.id===d.case_id).wf_case_docs.push(clone(d));return response(body,201)}
  if(table==='wf_view_log'&&method==='POST'){logs.push(clone(body));return response(null,204)}
  if(table==='wf_cases'&&method==='PATCH'){const c=cases.find(c=>params.id==='eq.'+c.id&&(!params.stage||params.stage==='eq.'+c.stage)&&(!params.status||params.status==='eq.'+c.status));if(conflict){conflict=false;return response([])}if(!c)return response([]);Object.assign(c,clone(body));return response([c])}
  throw Error('Unexpected '+method+' '+path);
 }
 const dom={},handlers={};
 const document={getElementById:id=>dom[id]||(dom[id]={innerHTML:'',textContent:'',value:'',classList:{toggle(){}},focus(){}}),addEventListener:(name,fn)=>handlers[name]=fn,activeElement:null};
 const window={confirm:()=>true,prompt:()=>null};
 new Function('window',workflow)(window);
 const inline=html.match(/<script>([\s\S]*?)<\/script>/)[1].replace('(async function init() {','const initPromise=(async function init() {');
 const api=new Function('window','document','fetch','AbortController','setTimeout','clearTimeout',inline+'\nreturn {S,initPromise,render,submitCase,approve,revalidateCase,staffDoc,getCase};')(window,document,fetchMock,class{constructor(){this.signal={}}abort(){}},()=>0,()=>{});
 await api.initPromise;const S=api.S,has=x=>dom.app.innerHTML.includes(x),scope=i=>{S.role='staff';S.staffSeq=i;S.dept=lines[i].dept;S.openId=null;S.modal=null;api.render()};
 const check=(name,ok)=>{assert(ok,name);passed.push(name)};
 const rejects=async fn=>{try{await fn();return false}catch(e){return true}};
 check('시민 홈 및 엔진 상태',has('신청서 찾기')&&dom.who.textContent.includes('AI 판독'));
 S.procId='s1';S.step='apply';S.att={d2:{fname:'소득.pdf',data:'ZGVtbw=='},d3:{fname:'첨부.pdf',data:'ZGVtbw=='}};
 await api.submitCase();const item=cases.at(-1),id=item.id;
 check('AI 결과 및 서류 저장',item.findings.length===3&&item.wf_case_docs.length===2&&trace.some(x=>x.url.endsWith('/api/check-case')&&x.body.docs.d2.filename==='소득.pdf'));
 scope(0);check('접수 오류 상세 분리',has('접수 전용 확인')&&!has('심사 전용 확인')&&!has('승인 전용 확인'));
 check('접수 서류 범위',api.staffDoc(api.getCase(id),'d3')&&!api.staffDoc(api.getCase(id),'d2'));
 scope(2);check('미도달 승인 단계 미노출',!has('합성 신청서'));
 check('단계 건너뛰기 차단',await rejects(()=>api.approve(id))&&item.stage===0);
 scope(0);window.prompt=()=>'오타';check('잘못된 수정값 거부',await rejects(()=>api.revalidateCase('typo'))&&!!cases[0].typo);
 window.prompt=()=>'정상';await api.revalidateCase('typo');check('수정값 일치 후 오류 해제',cases[0].typo===null&&cases[0].stage===0);
 conflict=true;check('동시 처리 충돌 차단',await rejects(()=>api.approve(id))&&item.stage===0);
 await api.approve(id);scope(1);check('접수→심사 및 오류 분리',item.stage===1&&has('심사 전용 확인')&&!has('접수 전용 확인')&&!has('승인 전용 확인'));
 check('심사 증빙 범위',api.staffDoc(api.getCase(id),'d2')&&!api.staffDoc(api.getCase(id),'d3'));
 handlers.click({target:{closest:()=>({tagName:'BUTTON',dataset:{act:'view',c:id,v:'d2'}})}});for(let i=0;i<15;i++)await Promise.resolve();
 check('열람 기록 및 모달',logs.some(x=>x.case_id===id&&x.doc_id==='d2'&&x.dept===lines[1].dept)&&S.modal?.d==='d2');
 await api.approve(id);scope(2);check('심사→승인 및 오류 분리',item.stage===2&&has('승인 전용 확인')&&!has('심사 전용 확인'));
 await api.approve(id);api.render();check('완료 후 상세 제한',item.status==='완료'&&!has('승인 전용 확인')&&!api.staffDoc(api.getCase(id),'d2'));
 S.role='citizen';S.step='mine';S.fs='';S.fe='';S.fq='';S.af={s:'',e:'',q:''};S.myOpen=id;api.render();
 check('시민 신청 완료 조회 및 열람 요청',has('나의 신청내역')&&has('완료')&&has('서류 열람 요청'));
 return {passed,requests:trace.length};
}
const root=path.resolve(__dirname,'..');
testFlow(fs.readFileSync(path.join(root,'index.html'),'utf8'),fs.readFileSync(path.join(root,'review-workflow.js'),'utf8'),assert.ok).then(r=>{for(const name of r.passed)console.log('PASS '+name);console.log('Mock API requests: '+r.requests);}).catch(e=>{console.error(e);process.exitCode=1;});
