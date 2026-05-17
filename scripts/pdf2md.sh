#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

DEFAULT_OUTPUT_DIR="$ROOT_DIR/output"

usage() {
  cat <<'USAGE'
Usage:
  scripts/pdf2md.sh setup [--python <python_bin>] [--recreate]
  scripts/pdf2md.sh single <pdf_path> [output_dir]
  scripts/pdf2md.sh batch <pdf_dir> [output_dir]
  scripts/pdf2md.sh fast single|batch <marker_options...>
  scripts/pdf2md.sh doctor

Examples:
  scripts/pdf2md.sh setup --recreate
  scripts/pdf2md.sh single ./papers/a.pdf ./output
  scripts/pdf2md.sh batch ./papers ./output
  scripts/pdf2md.sh fast single ./papers/a.pdf --output_format markdown --output_dir ./output
USAGE
}

choose_python_bin() {
  local requested="${1:-}"
  if [[ -n "$requested" ]]; then
    if command -v "$requested" >/dev/null 2>&1; then
      command -v "$requested"
      return 0
    fi
    log_error "Python binary not found: $requested"
    return 1
  fi

  if command -v /opt/homebrew/bin/python3.12 >/dev/null 2>&1; then
    echo "/opt/homebrew/bin/python3.12"
    return 0
  fi
  if command -v python3.12 >/dev/null 2>&1; then
    command -v python3.12
    return 0
  fi
  if command -v python3 >/dev/null 2>&1; then
    command -v python3
    return 0
  fi

  log_error "No usable python binary found. Install Python 3.12+ first."
  return 1
}

setup_env() {
  local python_bin=""
  local recreate="false"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --python)
        python_bin="${2:-}"
        if [[ -z "$python_bin" ]]; then
          log_error "--python requires a value"
          return 1
        fi
        shift 2
        ;;
      --recreate)
        recreate="true"
        shift
        ;;
      *)
        log_error "Unknown setup option: $1"
        return 1
        ;;
    esac
  done

  python_bin="$(choose_python_bin "$python_bin")"
  log_info "Using python: $python_bin"

  cd "$ROOT_DIR"
  if [[ "$recreate" == "true" && -d "$VENV_DIR" ]]; then
    log_info "Removing old virtualenv: $VENV_DIR"
    rm -rf "$VENV_DIR"
  fi

  "$python_bin" -m venv "$VENV_DIR"
  activate_venv
  python -m pip install --upgrade pip
  python -m pip install -r "$ROOT_DIR/requirements.txt"
  log_info "Setup complete. Activate env with: . $VENV_DIR/bin/activate"
}

convert_single() {
  local pdf_path="${1:-}"
  local output_dir="${2:-$DEFAULT_OUTPUT_DIR}"
  if [[ -z "$pdf_path" ]]; then
    log_error "single mode requires <pdf_path>"
    usage
    return 1
  fi
  if [[ ! -f "$pdf_path" ]]; then
    log_error "PDF file not found: $pdf_path"
    return 1
  fi

  require_venv
  activate_venv
  load_network_profile_if_present
  mkdir -p "$output_dir"
  marker_single "$pdf_path" --output_format markdown --output_dir "$output_dir"
}

convert_batch() {
  local pdf_dir="${1:-}"
  local output_dir="${2:-$DEFAULT_OUTPUT_DIR}"
  if [[ -z "$pdf_dir" ]]; then
    log_error "batch mode requires <pdf_dir>"
    usage
    return 1
  fi
  if [[ ! -d "$pdf_dir" ]]; then
    log_error "PDF directory not found: $pdf_dir"
    return 1
  fi

  require_venv
  activate_venv
  load_network_profile_if_present
  mkdir -p "$output_dir"
  marker "$pdf_dir" --output_format markdown --output_dir "$output_dir" --skip_existing
}

convert_fast() {
  local mode="${1:-}"

  case "$mode" in
    single)
      shift || true
      require_venv
      activate_venv
      load_network_profile_if_present
      marker_single "$@"
      ;;
    batch)
      shift || true
      require_venv
      activate_venv
      load_network_profile_if_present
      marker "$@"
      ;;
    *)
      log_error "fast mode requires subcommand: single|batch"
      usage
      return 1
      ;;
  esac
}

doctor() {
  local ok="true"
  cd "$ROOT_DIR"

  echo "== pdf2md doctor =="
  echo "root: $ROOT_DIR"

  if command -v python3 >/dev/null 2>&1; then
    echo "python3: $(command -v python3)"
  else
    echo "python3: missing"
    ok="false"
  fi

  if [[ -f "$ROOT_DIR/requirements.txt" ]]; then
    echo "requirements.txt: present"
  else
    echo "requirements.txt: missing"
    ok="false"
  fi

  if require_venv >/dev/null 2>&1; then
    echo "venv: present"
    activate_venv
    if command -v marker >/dev/null 2>&1; then
      echo "marker: $(command -v marker)"
    else
      echo "marker: missing in venv"
      ok="false"
    fi
  else
    echo "venv: missing"
    ok="false"
  fi

  if [[ "$ok" == "true" ]]; then
    echo "status: healthy"
  else
    echo "status: issues found"
    return 1
  fi
}

main() {
  local cmd="${1:-}"
  if [[ -z "$cmd" ]]; then
    usage
    exit 1
  fi
  shift || true

  case "$cmd" in
    setup)
      setup_env "$@"
      ;;
    single)
      convert_single "$@"
      ;;
    batch)
      convert_batch "$@"
      ;;
    fast)
      convert_fast "$@"
      ;;
    doctor)
      doctor
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      log_error "Unknown command: $cmd"
      usage
      exit 1
      ;;
  esac
}

main "$@"
