#!/usr/bin/env bash
# import_template.sh — fetch an approved UI template from this repo.
#
# Static import only: downloads files listed in the template manifest.
# NEVER executes template code; run templates only in an isolated environment.
#
# Usage:
#   tools/import_template.sh <template-id> [dest-dir]
#   tools/import_template.sh --list

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/shiangking/ui-templates/main"

if [[ "${1:-}" == "--list" || -z "${1:-}" ]]; then
  echo "Available templates:"
  curl -fsSL "$REPO_RAW/registry.json" | python3 -c '
import json, sys
r = json.load(sys.stdin)
for t in r["templates"]:
    print("  %-22s %s" % (t["id"], t["title"]))
'
  exit 0
fi

TPL_ID="$1"
DEST="${2:-./$TPL_ID}"
BASE="$REPO_RAW/templates/$TPL_ID"

MANIFEST=$(curl -fsSL "$BASE/manifest.json") || { echo "error: template '$TPL_ID' not found (try --list)" >&2; exit 1; }

echo "$MANIFEST" | python3 -c '
import json, sys
m = json.load(sys.stdin)
print("importing %s v%s (%s)" % (m["id"], m["version"], m["license"]))
'

mkdir -p "$DEST"
echo "$MANIFEST" | python3 -c '
import json, sys
for f in json.load(sys.stdin)["files"]:
    print(f)
' | while IFS= read -r f; do
  mkdir -p "$DEST/$(dirname "$f")"
  curl -fsSL "$BASE/$f" -o "$DEST/$f"
  echo "  ok: $f"
done

cp "$DEST/manifest.json" "$DEST/manifest.json" 2>/dev/null || true
echo "$MANIFEST" > "$DEST/manifest.json"
ENTRY=$(echo "$MANIFEST" | python3 -c '
import json, sys
print(json.load(sys.stdin)["entry"])
')
echo "imported -> $DEST (entry: $ENTRY)"
echo "reminder: adapt, do not reinvent; preserve tokens, components, responsive + a11y behavior."
