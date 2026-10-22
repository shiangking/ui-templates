#!/usr/bin/env bash
# import_template.sh — fetch an approved UI template from this repo.
#
# Modes:
#   vendored      — downloads files listed in the template manifest (from this repo)
#   external-git  — shallow-clones the upstream repo at the PINNED commit SHA and
#                   copies the pinned path. Byte-identical to upstream, no drift.
#
# Static import only: NEVER executes template code; run templates only in an
# isolated environment. For build-step frameworks (astro/react/next), dependency
# installation requires explicit exec approval.
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
    mode = t.get("import", {}).get("mode", "vendored")
    print("  %-24s [%s] %s" % (t["id"], mode, t["title"]))
'
  exit 0
fi

TPL_ID="$1"
DEST="${2:-./$TPL_ID}"
BASE="$REPO_RAW/templates/$TPL_ID"

MANIFEST=$(curl -fsSL "$BASE/manifest.json") || { echo "error: template '$TPL_ID' not found (try --list)" >&2; exit 1; }

MODE=$(echo "$MANIFEST" | python3 -c '
import json, sys
m = json.load(sys.stdin)
print(m.get("import", {}).get("mode", "vendored"))
')

echo "$MANIFEST" | python3 -c '
import json, sys
m = json.load(sys.stdin)
print("importing %s v%s (%s)" % (m["id"], m["version"], m["license"]))
'

mkdir -p "$DEST"

if [[ "$MODE" == "external-git" ]]; then
  REPO=$(echo "$MANIFEST" | python3 -c 'import json,sys; print(json.load(sys.stdin)["import"]["repo"])')
  SHA=$(echo "$MANIFEST" | python3 -c 'import json,sys; print(json.load(sys.stdin)["import"]["sha"])')
  SUBPATH=$(echo "$MANIFEST" | python3 -c 'import json,sys; print(json.load(sys.stdin)["import"]["path"])')
  TMP=$(mktemp -d)
  trap 'rm -rf "$TMP"' EXIT
  echo "  cloning $REPO at pinned $SHA ..."
  git clone --no-checkout --filter=blob:none --quiet "$REPO" "$TMP/repo"
  git -C "$TMP/repo" fetch --depth 1 --quiet origin "$SHA"
  git -C "$TMP/repo" checkout --quiet FETCH_HEAD
  SRC="$TMP/repo"
  [[ "$SUBPATH" != "." ]] && SRC="$TMP/repo/$SUBPATH"
  cp -R "$SRC/." "$DEST/"
  echo "$MANIFEST" > "$DEST/manifest.json"
  echo "  ok: copied $(find "$DEST" -type f | wc -l | tr -d ' ') files from pinned upstream"
elif [[ "$MODE" == "vendored" ]]; then
  echo "$MANIFEST" | python3 -c '
import json, sys
for f in json.load(sys.stdin)["files"]:
    print(f)
' | while IFS= read -r f; do
    mkdir -p "$DEST/$(dirname "$f")"
    curl -fsSL "$BASE/$f" -o "$DEST/$f"
    echo "  ok: $f"
  done
  echo "$MANIFEST" > "$DEST/manifest.json"
else
  echo "error: unknown import mode '$MODE'" >&2
  exit 1
fi

ENTRY=$(echo "$MANIFEST" | python3 -c '
import json, sys
print(json.load(sys.stdin)["entry"])
')
echo "imported -> $DEST (entry: $ENTRY)"
echo "reminder: adapt, do not reinvent; preserve tokens, components, responsive + a11y behavior."
echo "reminder: template code was imported, NOT executed; execute only in isolation with approval."
