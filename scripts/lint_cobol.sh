#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

echo "Linting COBOL source files..."

# Find all .cob files in lessons, exercises, projects.
IFS=$'\n'
cob_files=($(find "$repo_root" -type f -name "*.cob"))

if [ ${#cob_files[@]} -eq 0 ]; then
  echo "No COBOL source files found."
  exit 0
fi

errors=0

for file in "${cob_files[@]}"; do
  echo "Checking $file"
  line_no=0

  while IFS= read -r line || [ -n "$line" ]; do
    line_no=$((line_no + 1))

    # Tabs are not allowed in fixed-format COBOL source.
    if [[ "$line" == *$'\t'* ]]; then
      printf "  ERROR: %s:%d: contains TAB character\n" "$file" "$line_no"
      errors=$((errors + 1))
    fi

    # Maximum record length check.
    if [ ${#line} -gt 120 ]; then
      printf "  ERROR: %s:%d: line too long (%d > 120)\n" "$file" "$line_no" ${#line}
      errors=$((errors + 1))
    fi

    # In fixed-format COBOL, code starts in column 8. For source lines not comment in col 7, cols 1-6 should be spaces.
    if [ ${#line} -ge 1 ]; then
      # For comment marker, check if char in col 7 is '*'; this is index 6 in 0-based
      indicator=""
      if [ ${#line} -ge 7 ]; then
        indicator=${line:6:1}
      fi

      if [ "$indicator" != "*" ] && [ "$indicator" != ">" ] && [ "$indicator" != "C" ] && [ "$indicator" != "c" ]; then
        prefix="${line:0:6}"
        if [ "${prefix// /}" != "" ]; then
          printf "  WARN: %s:%d: columns 1-6 should be spaces for fixed-format code\n" "$file" "$line_no"
        fi
      fi
    fi

    # Encourage uppercase keywords: if any lowercase letter appears in data and procedure divisions.
    if [[ "$line" =~ [a-z] ]]; then
      # allow string literals and comments
      if [[ ! "$line" =~ ^[[:space:]]*\*> ]]; then
        printf "  WARN: %s:%d: lowercase letters found; use uppercase COBOL keywords and identifiers\n" "$file" "$line_no"
      fi
    fi

  done < "$file"

done

if [ "$errors" -ne 0 ]; then
  echo "\nLint failed with $errors errors."
  exit 1
fi

echo "COBOL lint check passed."
