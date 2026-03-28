#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <lesson-folder>"
  echo "Example: $0 examples/05_if_and_conditions"
  exit 1
fi

lesson_dir="$1"

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
output_name="lesson.out"

cobc -x -o "$output_name" main.cob
./"$output_name"
