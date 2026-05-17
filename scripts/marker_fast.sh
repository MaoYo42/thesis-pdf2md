#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" || "${1:-}" == "help" ]]; then
  cat <<'USAGE'
Usage:
  scripts/marker_fast.sh single <pdf_path> --output_format markdown --output_dir <dir>
  scripts/marker_fast.sh batch <pdf_dir> --output_format markdown --output_dir <dir> [--skip_existing]
USAGE
  exit 0
fi

exec "$ROOT_DIR/scripts/pdf2md.sh" fast "$@"
