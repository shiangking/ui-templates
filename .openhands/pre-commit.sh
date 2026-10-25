#!/usr/bin/env bash
# .openhands/pre-commit.sh — pre-commit checks for shiangking/ui-templates.
#
# There is no compiler or test suite here; CI-equivalent feedback means
# validating the data that defines the library before it is committed:
#   1. every JSON file parses
#   2. registry entries reference existing manifests, unique ids
#   3. each manifest declares a complete "files" list (schema requirement) and
#      every listed file exists on disk
#   4. manifest "files" cover everything tracked under its template directory
#      (an importer fetches exactly these paths)
#   5. no shell script in the repo has syntax errors
#   6. no committed file looks like a hardcoded secret
#
# Exit non-zero on any failure so problems surface before push, not in CI.

set -uo pipefail
cd "$(dirname "$0")/.."

fail=0

echo "[pre-commit] 1/6 validating JSON..."
python3 - <<'EOF' || fail=1
import glob, json, sys
bad = []
for path in sorted(glob.glob("**/*.json", recursive=True)):
    if path.startswith(".git/"):
        continue
    try:
        json.load(open(path))
    except Exception as exc:
        bad.append(f"{path}: {exc}")
for b in bad:
    print("  FAIL", b)
sys.exit(1 if bad else 0)
EOF

echo "[pre-commit] 2/6 checking registry <-> manifests..."
python3 - <<'EOF' || fail=1
import json, os, sys
reg = json.load(open("registry.json"))
ids = [t["id"] for t in reg["templates"]]
bad = []
if len(ids) != len(set(ids)):
    bad.append("duplicate ids in registry.json")
for t in reg["templates"]:
    mp = t.get("manifest")
    if not mp or not os.path.isfile(mp):
        bad.append(f"{t.get('id','?')}: manifest missing: {mp}")
        continue
    m = json.load(open(mp))
    if m.get("id") != t.get("id"):
        bad.append(f"{t.get('id','?')}: manifest id mismatch ({m.get('id')})")
for b in bad:
    print("  FAIL", b)
sys.exit(1 if bad else 0)
EOF

echo "[pre-commit] 3/6 checking manifest 'files' completeness..."
python3 - <<'EOF' || fail=1
import json, os, sys
reg = json.load(open("registry.json"))
bad = []
for t in reg["templates"]:
    mp = t.get("manifest")
    if not mp or not os.path.isfile(mp):
        continue
    m = json.load(open(mp))
    tid = t.get("id", "?")
    files = m.get("files")
    if files is None:
        bad.append(f"{tid}: manifest has no 'files' array (schema requires a complete list)")
    elif m.get("import", {}).get("mode") == "external-git":
        # external-git templates intentionally leave files empty: import is a
        # shallow clone at the pinned SHA, byte-identical to upstream.
        pass
    else:
        base = mp.rsplit("/", 1)[0]
        tracked = set()
        for root, _dirs, names in os.walk(base):
            for n in names:
                tracked.add(os.path.relpath(os.path.join(root, n), base))
        missing = sorted(tracked - set(files))
        extra = sorted(set(files) - tracked)
        for f in missing:
            bad.append(f"{tid}: tracked file not in manifest 'files': {f}")
        for f in extra:
            bad.append(f"{tid}: manifest 'files' entry does not exist on disk: {f}")
for b in bad:
    print("  FAIL", b)
sys.exit(1 if bad else 0)
EOF

echo "[pre-commit] 4/6 bash syntax check..."
while IFS= read -r -d '' script; do
  if ! bash -n "$script" 2>/tmp/oh-bashn.err; then
    echo "  FAIL $script:"; cat /tmp/oh-bashn.err; fail=1
  fi
done < <(find . -name "*.sh" -type f -not -path "./.git/*" -print0)

echo "[pre-commit] 5/6 secret scan..."
if git rev-parse HEAD >/dev/null 2>&1; then
  staged=$(git diff --cached --name-only 2>/dev/null || true)
else
  staged=""
fi
[ -z "$staged" ] && staged=$(git ls-files)
if printf '%s\n' "$staged" | grep -Ev '(^$|\.md$)' | xargs -r grep -nEi \
  '(api[_-]?key|secret|password|passwd|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{8,}' 2>/dev/null | \
  grep -Ev 'process\.env|os\.environ|\$[A-Z_]+|secrets\.'; then
  echo "  FAIL possible hardcoded credential above (review before committing)"
  fail=1
fi

echo "[pre-commit] 6/6 summary"
if [ "$fail" -ne 0 ]; then
  echo "[pre-commit] FAILED — fix the issues above before committing." >&2
  exit 1
fi
echo "[pre-commit] all checks passed."
