#!/usr/bin/env bash
set -euo pipefail

in_dir="photos/logos"
shopt -s nullglob

if ! command -v cwebp >/dev/null 2>&1 && ! command -v magick >/dev/null 2>&1 && ! command -v sips >/dev/null 2>&1; then
  echo "No image converter found (need cwebp or ImageMagick 'magick' or macOS 'sips')."
  echo "You can install cwebp via 'brew install webp' (macOS) or your package manager."
  exit 0
fi

convert_one() {
  local src="$1"; local dst="${src%.png}.webp"
  if [[ -f "$dst" ]]; then
    echo "Skip existing $(basename "$dst")"
    return
  fi
  if command -v cwebp >/dev/null 2>&1; then
    cwebp -quiet -q 82 "$src" -o "$dst" && echo "Created $(basename "$dst")" && return
  fi
  if command -v magick >/dev/null 2>&1; then
    magick "$src" -quality 82 "$dst" && echo "Created $(basename "$dst")" && return
  fi
  if command -v sips >/dev/null 2>&1; then
    sips -s format webp "$src" --out "$dst" >/dev/null && echo "Created $(basename "$dst")" && return
  fi
}

for png in "$in_dir"/*.png; do
  convert_one "$png" || true
done

echo "Done. WebP files (if any) saved alongside PNGs."

