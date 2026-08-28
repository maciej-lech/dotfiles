#!/usr/bin/env bash
# Custom Claude Code statusline.
# Line: [caveman badge] Model (context label) · <bar> NN% left · used/limit · $cost
# Caveman badge preserved by delegating to the caveman wrapper.

set -eu

CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

# Read the status JSON from stdin.
INPUT=$(cat)

# Pull the fields we need in one jq pass. Context numbers come straight from
# the native context_window block Claude Code reports.
IFS=$'\t' read -r MODEL EFFORT COST USED LIMIT PCT_LEFT <<EOF
$(printf '%s' "$INPUT" | jq -r '
  [ (.model.display_name // "Claude"),
    (.effort.level // ""),
    (.cost.total_cost_usd // 0),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 200000),
    (.context_window.remaining_percentage // 100)
  ] | @tsv')
EOF

[ -z "$USED" ] && USED=0
{ [ -z "$LIMIT" ] || [ "$LIMIT" -le 0 ]; } && LIMIT=200000
PCT_LEFT=${PCT_LEFT%%.*}
[ -z "$PCT_LEFT" ] && PCT_LEFT=100

# Progress bar: filled cells = used fraction.
BAR_WIDTH=14
FILLED=$(( USED * BAR_WIDTH / LIMIT ))
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
[ "$FILLED" -lt 0 ] && FILLED=0
EMPTY=$(( BAR_WIDTH - FILLED ))

fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf '%d.%dM' $(( n / 1000000 )) $(( (n % 1000000) / 100000 ))
  elif [ "$n" -ge 1000 ]; then
    printf '%dk' $(( n / 1000 ))
  else
    printf '%d' "$n"
  fi
}

USED_H=$(fmt_tokens "$USED")
LIMIT_H=$(fmt_tokens "$LIMIT")
COST_H=$(LC_ALL=C printf '%.2f' "$COST")

# Colors.
DIM='\033[2m'
GREY='\033[38;5;245m'
RESET='\033[0m'
SEP="${DIM} · ${RESET}"

# Build bar.
bar=''
i=0
while [ "$i" -lt "$FILLED" ]; do bar="${bar}█"; i=$(( i + 1 )); done
FILL_PART="${GREY}${bar}${RESET}"
bar=''
i=0
while [ "$i" -lt "$EMPTY" ]; do bar="${bar}░"; i=$(( i + 1 )); done
EMPTY_PART="${DIM}${bar}${RESET}"

# Caveman badge (preserved). Strip the plugin's own color, recolor grey.
BADGE_RAW=$(bash "$CONFIG_DIR/bin/caveman-statusline.sh" 2>/dev/null || true)
BADGE_RAW=$(printf '%s' "$BADGE_RAW" | sed 's/\x1b\[[0-9;]*m//g')

# Left group: badge + model + effort. Right group: bar + stats, pushed to the edge.
LEFT_DISP="${GREY}${BADGE_RAW:+$BADGE_RAW }${MODEL}${RESET}${EFFORT:+${SEP}${GREY}${EFFORT}${RESET}}"
LEFT_PLAIN="${BADGE_RAW:+$BADGE_RAW }${MODEL}${EFFORT:+ · ${EFFORT}}"
LEFT_LEN=${#LEFT_PLAIN}

RIGHT_DISP="${FILL_PART}${EMPTY_PART} ${GREY}${PCT_LEFT}% left${RESET}${SEP}${GREY}${USED_H}/${LIMIT_H}${RESET}${SEP}${GREY}\$${COST_H}${RESET}"
STATS_PLAIN="${PCT_LEFT}% left · ${USED_H}/${LIMIT_H} · \$${COST_H}"
RIGHT_LEN=$(( BAR_WIDTH + 1 + ${#STATS_PLAIN} ))

# Terminal width less a margin so the box's right padding never truncates us.
WIDTH=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
USABLE=$(( WIDTH - 3 ))
PAD=$(( USABLE - LEFT_LEN - RIGHT_LEN ))
[ "$PAD" -lt 1 ] && PAD=1
SPACER=$(printf '%*s' "$PAD" '')

printf '%b' "${LEFT_DISP}${SPACER}${RIGHT_DISP}"
