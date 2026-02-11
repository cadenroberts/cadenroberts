#!/usr/bin/env bash
set -euo pipefail

# Non-interactive validation script for cadenroberts profile README
# Validates link integrity and Markdown formatting
# Exit 0 + DEMO_OK on success, exit 1 on failure

echo "Running link validation..."

# Check if markdown-link-check is installed
if ! command -v markdown-link-check &> /dev/null; then
  echo "Error: markdown-link-check not found"
  echo "Install: npm install -g markdown-link-check"
  exit 1
fi

# Run link checker on README
if markdown-link-check README.md --quiet --config .markdown-link-check.json 2>&1 | grep -q "ERROR"; then
  echo "FAIL: Link validation failed"
  markdown-link-check README.md --config .markdown-link-check.json
  exit 1
fi

echo "✓ README.md: All links valid"

echo ""
echo "Running Markdown lint..."

# Check if markdownlint is installed
if ! command -v markdownlint &> /dev/null; then
  echo "Error: markdownlint-cli not found"
  echo "Install: npm install -g markdownlint-cli"
  exit 1
fi

# Run Markdown linter
if ! markdownlint README.md --config .markdownlint.json; then
  echo "FAIL: Markdown linting failed"
  exit 1
fi

echo "✓ README.md: No errors"

echo ""
echo "DEMO_OK"
exit 0
