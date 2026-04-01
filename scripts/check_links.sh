#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

# Collect targets for checking
paths=(
  "$repo_root/README.md"
  "$repo_root/docs"
  "$repo_root/examples"
  "$repo_root/exercises"
  "$repo_root/projects"
  "$repo_root/.github"
)

cd "$repo_root"

if command -v lychee >/dev/null 2>&1; then
  echo "Using lychee for markdown link checking"
  lychee --verbose "${paths[@]}"
  exit 0
fi

if command -v npm >/dev/null 2>&1; then
  echo "Using markdown-link-check (npx) for markdown link checking"
  # Install once in temp so we don't alter the repo
  npx markdown-link-check --config scripts/markdown-link-check.json "${paths[@]}"
  exit 0
fi

cat <<'EOF'
Error: neither lychee nor npm are available for markdown link checking.
Install one of:
  - cargo install lychee
  - npm install -g markdown-link-check
EOF
exit 1
