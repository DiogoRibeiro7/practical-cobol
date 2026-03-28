#!/usr/bin/env bash
set -euo pipefail

if ! command -v cobc >/dev/null 2>&1; then
  echo "Error: GnuCOBOL compiler 'cobc' not found."
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

while IFS= read -r -d '' file; do
  dir="$(dirname "$file")"
  echo "Checking $dir"
  (
    cd "$dir"
    cobc -x -o lesson.out main.cob
  )
done < <(find "$repo_root/examples" -name main.cob -print0)

echo "All COBOL example files compiled successfully."
