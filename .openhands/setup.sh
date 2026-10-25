#!/usr/bin/env bash
# .openhands/setup.sh — OpenHands session bootstrap for shiangking/ui-templates.
#
# This repository is a UI template library: there are no dependencies to
# install and nothing to build. "Setup" means verifying the tooling needed by
# the repo's own scripts (tools/import_template.sh) and validating the
# registry/manifest data so broken JSON is caught at session start.
#
# Idempotent and fast; exit non-zero on failure.

set -euo pipefail
cd "$(dirname "$0")/.."

echo "[setup] ui-templates bootstrap"

# --- required tooling (same commands tools/import_template.sh relies on) -----
for tool in git curl python3 bash; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "[setup] ERROR: required tool '$tool' not found" >&2
    exit 1
  fi
done
echo "[setup] tooling ok: git, curl, python3, bash"

# --- data integrity: every JSON file must parse ------------------------------
python3 - <<'EOF'
import glob, json, sys
failed = []
for path in sorted(glob.glob("**/*.json", recursive=True)):
    if path.startswith(".git/"):
        continue
    try:
        with open(path) as fh:
            json.load(fh)
    except Exception as exc:
        failed.append(f"{path}: {exc}")
if failed:
    print("[setup] ERROR: invalid JSON files:", file=sys.stderr)
    for f in failed:
        print("  -", f, file=sys.stderr)
    sys.exit(1)
print("[setup] all JSON files parse OK")
EOF

# --- registry sanity: unique ids, manifests exist ----------------------------
python3 - <<'EOF'
import json, os, sys
with open("registry.json") as fh:
    reg = json.load(fh)
ids = [t["id"] for t in reg["templates"]]
problems = []
if len(ids) != len(set(ids)):
    problems.append("duplicate template ids in registry.json")
for t in reg["templates"]:
    for key in ("id", "version", "title", "license", "framework", "manifest"):
        if key not in t:
            problems.append(f"{t.get('id', '?')}: registry entry missing '{key}'")
    if not os.path.isfile(t.get("manifest", "")):
        problems.append(f"{t.get('id', '?')}: manifest file not found: {t.get('manifest')}")
if problems:
    print("[setup] ERROR: registry problems:", file=sys.stderr)
    for p in problems:
        print("  -", p, file=sys.stderr)
    sys.exit(1)
print(f"[setup] registry OK: {len(ids)} templates, all manifests present")
EOF

# --- env ---------------------------------------------------------------------
# No required environment variables for this repository. GITHUB_TOKEN is
# optional and only needed for git push; never hardcode credentials anywhere.

echo "[setup] done — library ready (nothing to install or build)"
