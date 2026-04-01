#!/usr/bin/env bash
set -euo pipefail

if ! command -v cobc >/dev/null 2>&1; then
  echo "Error: GnuCOBOL compiler 'cobc' not found."
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

cd "$repo_root/examples/13_sort_merge"

cobc -x -o sortmerge main.cob

./sortmerge > actual_output.txt

# Normalize any CRLF variation
tr -d '\r' < actual_output.txt > actual_output_unix.txt
tr -d '\r' < expected_output.txt > expected_output_unix.txt

if ! diff -u expected_output_unix.txt actual_output_unix.txt > /dev/null; then
  echo "Output mismatch for examples/13_sort_merge" >&2
  diff -u expected_output_unix.txt actual_output_unix.txt
  exit 1
fi

# Check sorted and merged output ordering (basic checks)
if ! awk '{print substr($0,1,3)}' data/sorted_output.dat | sort -n | diff - data/sorted_output.dat >/dev/null; then
  echo "sorted_output.dat is not correctly ordered by ID" >&2
  exit 1
fi

if ! awk '{print substr($0,1,3)}' data/merged_output.dat | sort -n | diff - data/merged_output.dat >/dev/null; then
  echo "merged_output.dat is not correctly ordered by ID" >&2
  exit 1
fi

echo "examples/13_sort_merge passed"