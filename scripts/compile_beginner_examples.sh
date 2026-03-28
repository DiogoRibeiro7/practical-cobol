#!/usr/bin/env bash
set -euo pipefail

if ! command -v cobc >/dev/null 2>&1; then
  echo "Error: GnuCOBOL compiler 'cobc' not found."
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

beginner_lessons=(
  "examples/00_hello_world"
  "examples/01_program_structure"
  "examples/02_variables_and_pic"
  "examples/03_move_accept_display"
  "examples/04_arithmetic_operations"
  "examples/05_if_and_conditions"
  "examples/06_perform_and_paragraphs"
)

for lesson_dir in "${beginner_lessons[@]}"; do
  "$script_dir/compile_lesson.sh" "$lesson_dir"
done

echo "All beginner examples compiled successfully."
