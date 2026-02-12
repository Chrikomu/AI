#!/bin/bash
# Claude Code Statusline

input=$(cat)

G='\033[32m'  C='\033[36m'  W='\033[97m'  B='\033[1m'  N='\033[0m'

eval "$(echo "$input" | jq -r '
  @sh "MODEL=\(.model.display_name // "Unknown")",
  @sh "CTX_SIZE=\(.context_window.context_window_size // 200000)",
  @sh "INPUT_TOK=\(.context_window.current_usage.input_tokens // 0)",
  @sh "OUTPUT_TOK=\(.context_window.current_usage.output_tokens // 0)",
  @sh "CACHE_READ=\(.context_window.current_usage.cache_read_input_tokens // 0)",
  @sh "CACHE_CREATE=\(.context_window.current_usage.cache_creation_input_tokens // 0)",
  @sh "CWD=\(.cwd // "")"
' 2>/dev/null)"

TOTAL_USED=$((${INPUT_TOK:-0} + ${OUTPUT_TOK:-0} + ${CACHE_READ:-0} + ${CACHE_CREATE:-0}))
CTX_SIZE="${CTX_SIZE:-200000}"

fmt_k() { if [ "$1" -ge 1000 ]; then echo "$((${1} / 1000))k"; else echo "$1"; fi; }

printf "${G}${B}%s${N} | ${W}%s / %s${N} | ${W}%s${N}\n" \
    "${MODEL:-Unknown}" "$(fmt_k $TOTAL_USED)" "$(fmt_k $CTX_SIZE)" "${CWD:-$PWD}"
