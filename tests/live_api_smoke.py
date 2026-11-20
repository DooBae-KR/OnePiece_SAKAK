"""Read-only REST checks; optional local engine test with synthetic fixture."""
import argparse
import base64
import json
import re
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
html = (ROOT / "index.html").read_text(encoding="utf-8")
def config(name):
    return re.search(r"const " + name + r"\s*=\s*'([^']+)'", html).group(1)

def request(url, headers=None, body=None):
    with urlopen(Request(url, data=None if body is None else json.dumps(body).encode(),
                        headers=headers or {}), timeout=45 if body else 8) as res:
        return res.status, json.load(res)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--fixture", type=Path, help="Synthetic PDF or TXT only")
    parser.add_argument("--proc-id")
    parser.add_argument("--doc-id")
    args = parser.parse_args()
    if any([args.fixture, args.proc_id, args.doc_id]) and not all([args.fixture, args.proc_id, args.doc_id]):
        parser.error("Supply --fixture, --proc-id and --doc-id together")
    results = []
    def check(label, fn):
        try:
            detail = fn()
            print("PASS", label, detail)
            results.append(True)
        except Exception as exc:
            print("FAIL", label, type(exc).__name__, str(exc)[:220])
            results.append(False)
    db = config("SUPABASE_URL") + "/rest/v1/"
    headers = {"apikey": config("SUPABASE_KEY"), "Content-Type": "application/json"}
    for table, query in [
        ("wf_procedures", "select=id&limit=1"),
        ("wf_proc_docs", "select=proc_id,doc_id,kind&limit=1"),
        ("wf_approval_line", "select=proc_id,seq,dept&limit=1"),
        ("wf_cases", "select=id,stage,status,findings,wf_case_docs(doc_id)&limit=1"),
    ]:
        def db_check(table=table, query=query):
            status, data = request(db + table + "?" + query, headers)
            assert isinstance(data, list), "Expected array"
            return f"HTTP {status}, sample rows={len(data)}"
        check(table, db_check)
    engine = config("ENGINE_URL")
    def health():
        status, data = request(engine + "/api/health")
        assert data.get("ok") is True and isinstance(data.get("ai"), bool), "Invalid health response"
        return f"HTTP {status}, ai={data['ai']}"
    check("engine health", health)
    if args.fixture:
        if args.fixture.suffix.lower() not in (".pdf", ".txt"):
            parser.error("Fixture must be a synthetic PDF or TXT")
        doc = {"filename": args.fixture.name, "data": base64.b64encode(args.fixture.read_bytes()).decode()}
        def check_doc():
            status, data = request(engine + "/api/check-doc", {"Content-Type":"application/json"},
                {"proc_id":args.proc_id,"doc_id":args.doc_id,**doc})
            assert data.get("state") in ("ok","wrong") and isinstance(data.get("sim"), (float,int))
            return f"HTTP {status}, state={data['state']}"
        def check_case():
            status, data = request(engine + "/api/check-case", {"Content-Type":"application/json"},
                {"proc_id":args.proc_id,"docs":{args.doc_id:doc}})
            assert isinstance(data.get("findings"), list) and isinstance(data.get("docs"), dict)
            assert args.doc_id in data["docs"]
            return f"HTTP {status}, findings={len(data['findings'])}"
        check("check-doc", check_doc)
        check("check-case", check_case)
    else:
        print("SKIP check-doc / check-case: provide synthetic fixture and matching IDs")
    print(f"{sum(results)}/{len(results)} executed checks passed; no DB writes")
    return 0 if all(results) else 1

if __name__ == "__main__":
    raise SystemExit(main())
