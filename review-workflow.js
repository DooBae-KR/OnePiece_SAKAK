'use strict';
function workflowFactory(){
 const closed=c=>c.status==="완료"||c.status==="반려";
 const stage=c=>Number.isInteger(c.stage)&&c.stage>=0&&c.stage<=2?c.stage:null;
 const route=f=>{if(!f||typeof f!=="object")return null;const role={"접수":0,"심사":1,"승인":2}[f.role];if(f.stage_seq!=null){if(!Number.isInteger(f.stage_seq)||f.stage_seq<0||f.stage_seq>2||(role!=null&&role!==f.stage_seq))return null;return f.stage_seq;}return role==null?null:role;};
 const assigned=(c,lines,scope)=>!!(c&&scope&&Number.isInteger(scope.seq)&&scope.seq>=0&&scope.seq<=2&&scope.dept&&Array.isArray(lines)&&lines.some(l=>l.seq===scope.seq&&l.dept===scope.dept));
 const canList=(c,lines,scope)=>assigned(c,lines,scope)&&stage(c)!==null&&scope.seq<=stage(c);
 const canAct=(c,lines,scope)=>canList(c,lines,scope)&&!closed(c)&&stage(c)===scope.seq;
 const findings=(c,lines,scope)=>canAct(c,lines,scope)?(Array.isArray(c.findings)?c.findings:[]).filter(f=>route(f)===scope.seq):[];
 const unassigned=c=>(Array.isArray(c.findings)?c.findings:[]).some(f=>route(f)===null);
 const norm=x=>String(x||"").normalize("NFC").trim();
 const canDoc=(c,lines,scope,doc,def)=>{if(!canAct(c,lines,scope)||!doc||!def||doc.doc_id!==def.doc_id)return false;const named=norm(doc.fname);if(named&&findings(c,lines,scope).some(f=>Array.isArray(f.evidence)&&f.evidence.some(e=>norm(e.doc)===named)))return true;return scope.seq===0?["manual","upload"].includes(def.kind):scope.seq===1?def.kind==="gov24":false;};
 const canEdit=(c,lines,scope)=>canAct(c,lines,scope)&&scope.seq===0&&!(Array.isArray(c.findings)&&c.findings.length);
 const next=(c,lines,scope)=>{if(!canAct(c,lines,scope)||unassigned(c)||c.typo)return null;const n=stage(c);if(n<2){if(!lines.some(l=>l.seq===n+1&&l.dept))return null;return {stage:n+1,status:n===0?"체크완료":"AI심사"};}return {stage:2,status:"완료"};};
 const scopes=lines=>{const out=[];for(const l of Object.values(lines||{}).flat()){if(Number.isInteger(l.seq)&&l.seq>=0&&l.seq<=2&&l.dept&&!out.some(x=>x.seq===l.seq&&x.dept===l.dept))out.push({seq:l.seq,dept:l.dept});}return out.sort((a,b)=>a.seq-b.seq||a.dept.localeCompare(b.dept));};
 return {closed,stage,route,assigned,canList,canAct,findings,unassigned,canDoc,canEdit,next,scopes};
}
const SakakReview = workflowFactory();
if(typeof module !== 'undefined' && module.exports) module.exports = SakakReview;
else window.SakakReview = SakakReview;
