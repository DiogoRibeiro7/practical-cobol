#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <lesson-folder>"
  echo "Example: $0 examples/04_arithmetic_operations"
  exit 1
fi

lesson_dir="$1"

if ! command -v cobc >/dev/null 2>&1; then
  echo "Error: GnuCOBOL compiler 'cobc' not found."
  exit 1
fi

if [[ ! -d "$lesson_dir" ]]; then
  echo "Error: directory '$lesson_dir' not found."
  exit 1
fi

if [[ ! -f "$lesson_dir/main.cob" ]]; then
  echo "Error: '$lesson_dir/main.cob' not found."
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

cd "$repo_root/$lesson_dir"
echo "Compiling $lesson_dir"
cobc -x -o lesson.out main.cob
echo "Compiled successfully: $lesson_dir"
