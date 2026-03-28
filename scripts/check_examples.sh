#!/usr/bin/env bash
set -euo pipefail

if ! command -v cobc >/dev/null 2>&1; then
  echo "GnuCOBOL compiler 'cobc' not found. Skipping compile checks."
  exit 0
fi

while IFS= read -r -d '' file; do
  dir="$(dirname "$file")"
  echo "Checking $dir"
  (
    cd "$dir"
    cobc -x -o /tmp/cobol-check-bin main.cob
  )
done < <(find examples -name main.cob -print0)

echo "All COBOL example files compiled successfully."
