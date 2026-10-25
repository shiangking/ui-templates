#!/usr/bin/env bash
# ============================================================
# fetch_fonts.sh — one-time, build-time font fetch for
#   templates/orbita-dark-landing  (v1.1.0)
#
# Downloads the 4 pinned variable woff2 files ONCE, verifies
# SHA-256, and vendors them into assets/fonts/.
# After this runs, the site is fully offline-capable:
# zero runtime network requests (repo policy: fonts are
# self-hosted; no CDNs at page load).
#
# Usage:  bash fetch_fonts.sh [target-template-dir]
# Re-run anytime: existing verified files are kept.
# ============================================================
set -u

DEST="${1:-.}/assets/fonts"
mkdir -p "$DEST"

# name|url|sha256
FONTS=(
  "fraunces-var.woff2|https://fonts.gstatic.com/s/fraunces/v38/6NU78FyLNQOQZAnv9bYEvDiIdE9Ea92uemAk_WBq8U_9v0c2Wa0KxC9TeA.woff2|7234ed860a9cc83045413c4faee63c960a8f2d1917adcf728119307d56e0d783"
  "fraunces-italic-var.woff2|https://fonts.gstatic.com/s/fraunces/v38/6NU58FyLNQOQZAnv9ZwNjucMHVn85Ni7emAe9lKqZTnbB-gzTK0K1ChjeveQ.woff2|066710ce7ed235a339d3d6cdcc8b55c0bea5632232662d83aacea25852108271"
  "inter-var.woff2|https://fonts.gstatic.com/s/inter/v20/UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa1ZL7.woff2|3100e775e8616cd2611beecfa23a4263d7037586789b43f035236a2e6fbd4c62"
  "jetbrains-mono-var.woff2|https://fonts.gstatic.com/s/jetbrainsmono/v24/tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPxDcwg.woff2|83c005d49d8a6a50474c73a5a36ac0468076e9c4a29da7bdb14995d80560a5be"
)

UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36"
fail=0

for entry in "${FONTS[@]}"; do
  IFS='|' read -r name url want <<<"$entry"
  out="$DEST/$name"

  if [ -f "$out" ] && echo "$want  $out" | sha256sum -c - >/dev/null 2>&1; then
    echo "ok (cached)  $name"
    continue
  fi

  echo "fetching     $name"
  if ! curl -fsSL -A "$UA" -o "$out" "$url"; then
    echo "ERROR        download failed: $name" >&2
    fail=1; continue
  fi

  if echo "$want  $out" | sha256sum -c - >/dev/null 2>&1; then
    echo "ok           $name"
  else
    echo "ERROR        checksum mismatch: $name" >&2
    rm -f "$out"; fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo "One or more fonts failed verification. Fix before building." >&2
  exit 1
fi

# Ship the fonts' license with the vendored files (all three families are SIL OFL 1.1)
cat > "$DEST/LICENSE-OFL.txt" <<'EOF'
The fonts vendored into this directory are subject to the SIL Open Font License, Version 1.1:
- Fraunces   (c) The Fraunces Project Authors — https://github.com/undercasetype/Fraunces
- Inter      (c) The Inter Project Authors    — https://github.com/rsms/inter
- JetBrains Mono (c) JetBrains                — https://github.com/JetBrains/JetBrainsMono
Full license text: https://openfontlicense.org
EOF

echo "All fonts vendored into $DEST — the site now makes zero runtime requests."
