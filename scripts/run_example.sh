#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <example-folder>"
  echo "Example: $0 examples/05_if_and_conditions"
  exit 1
fi

example_dir="$1"

if [[ ! -d "$example_dir" ]]; then
  echo "Error: directory '$example_dir' not found."
  exit 1
fi

if [[ ! -f "$example_dir/main.cob" ]]; then
  echo "Error: '$example_dir/main.cob' not found."
  exit 1
fi

cd "$example_dir"
output_name="program.out"

cobc -x -o "$output_name" main.cob
./"$output_name"
