#!/usr/bin/env bash
# Downloads the libraries the game uses into app/src/main/assets/www/lib
# so the Android app runs 100% offline. Run once before building.
set -euo pipefail
cd "$(dirname "$0")/.."

LIB="app/src/main/assets/www/lib"
mkdir -p "$LIB/fontawesome/css" "$LIB/fontawesome/webfonts" "$LIB/cairo"

get() { # get <url> <dest> [required]
  echo "-> $2"
  if ! curl -fsSL --retry 3 -o "$2.part" "$1"; then
    rm -f "$2.part"
    if [ "${3:-optional}" = "required" ]; then echo "FAILED (required): $1" >&2; exit 1; fi
    echo "skipped (optional): $1" >&2
    return 0
  fi
  mv "$2.part" "$2"
}

# 3D engine (required)
get "https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.min.js" "$LIB/three.min.js" required

# Tailwind CSS runtime (required for the menus layout)
get "https://cdn.tailwindcss.com/3.4.16" "$LIB/tailwind.js"
[ -s "$LIB/tailwind.js" ] || get "https://cdn.tailwindcss.com" "$LIB/tailwind.js" required

# Font Awesome icons
FA="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0"
get "$FA/css/all.min.css" "$LIB/fontawesome/css/all.min.css"
for f in fa-solid-900 fa-regular-400 fa-brands-400 fa-v4compatibility; do
  get "$FA/webfonts/$f.woff2" "$LIB/fontawesome/webfonts/$f.woff2"
  get "$FA/webfonts/$f.ttf" "$LIB/fontawesome/webfonts/$f.ttf"
done

# Cairo Arabic font
CA="https://cdn.jsdelivr.net/npm/@fontsource/cairo@5/files"
for w in 600 700 800 900; do
  for s in arabic latin; do
    get "$CA/cairo-$s-$w-normal.woff2" "$LIB/cairo/cairo-$s-$w-normal.woff2"
  done
done

echo "Done. Libraries are in $LIB"
