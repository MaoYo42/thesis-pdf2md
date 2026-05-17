#!/usr/bin/env bash
set -euo pipefail

# Optional overrides:
#   export PROXY_URL="http://127.0.0.1:1082"
#   export PROXY_TEST_URL="https://huggingface.co"
#   export HF_ENDPOINT="https://hf-mirror.com"
#   export PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
#   export PIP_TRUSTED_HOST="pypi.tuna.tsinghua.edu.cn"

PROXY_URL="${PROXY_URL:-http://127.0.0.1:1082}"
PROXY_TEST_URL="${PROXY_TEST_URL:-https://huggingface.co}"
HF_ENDPOINT="${HF_ENDPOINT:-https://hf-mirror.com}"
PIP_INDEX_URL="${PIP_INDEX_URL:-https://pypi.tuna.tsinghua.edu.cn/simple}"
PIP_TRUSTED_HOST="${PIP_TRUSTED_HOST:-}"

# Always set mirrors (safe even without proxy)
export HF_ENDPOINT
export PIP_INDEX_URL
if [[ -n "$PIP_TRUSTED_HOST" ]]; then
  export PIP_TRUSTED_HOST
fi

# Proxy: enable only when reachable
if command -v curl >/dev/null 2>&1 && curl -sS --max-time 2 --proxy "$PROXY_URL" "$PROXY_TEST_URL" >/dev/null 2>&1; then
  export HTTP_PROXY="$PROXY_URL"
  export HTTPS_PROXY="$PROXY_URL"
  export ALL_PROXY="$PROXY_URL"
  export NO_PROXY="localhost,127.0.0.1"
  echo "[network] Proxy enabled: $PROXY_URL (test=$PROXY_TEST_URL)"
else
  echo "[network] Proxy not reachable: $PROXY_URL (test=$PROXY_TEST_URL; skip proxy, mirrors still enabled)"
fi

echo "[network] HF_ENDPOINT=$HF_ENDPOINT"
echo "[network] PIP_INDEX_URL=$PIP_INDEX_URL"
if [[ -n "$PIP_TRUSTED_HOST" ]]; then
  echo "[network] PIP_TRUSTED_HOST=$PIP_TRUSTED_HOST"
fi
