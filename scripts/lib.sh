#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

log_info() {
  echo "[pdf2md] $*"
}

log_error() {
  echo "[pdf2md][error] $*" >&2
}

require_venv() {
  if [[ ! -f "$VENV_DIR/bin/activate" ]]; then
    log_error "Virtualenv not found at $VENV_DIR. Run: scripts/pdf2md.sh setup"
    return 1
  fi
}

activate_venv() {
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
}

load_network_profile_if_present() {
  if [[ -f "$ROOT_DIR/scripts/network_accelerate.sh" ]]; then
    # shellcheck disable=SC1091
    source "$ROOT_DIR/scripts/network_accelerate.sh"
  fi
}

