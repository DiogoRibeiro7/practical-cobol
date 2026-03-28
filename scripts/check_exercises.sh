#!/usr/bin/env bash
set -euo pipefail

if ! command -v cobc >/dev/null 2>&1; then
  echo "Error: GnuCOBOL compiler 'cobc' not found."
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

echo "Compiling COBOL solutions under exercises/solutions..."

shopt -s globstar nullglob
cob_files=($repo_root/exercises/solutions/**/*.cob)

if [ ${#cob_files[@]} -eq 0 ]; then
  echo "No COBOL solution files found under exercises/solutions."
  exit 0
fi

for cob_file in "${cob_files[@]}"; do
  relative_path=${cob_file#$repo_root/}
  echo "  - $relative_path"
  working_dir=$(dirname "$cob_file")
  output_file="$working_dir/$(basename "${cob_file%.cob}")"

  (cd "$working_dir" && cobc -x -o "$output_file" "$(basename "$cob_file")")

  if [ -x "$output_file" ]; then
    echo "    -> compiled OK"
  else
    echo "Error: compilation failed for $relative_path"
    exit 1
  fi

  rm -f "$output_file"

done

echo "All exercise solutions compiled successfully."
