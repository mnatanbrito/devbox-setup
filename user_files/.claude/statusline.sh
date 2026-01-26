#!/bin/bash
# Claude Code statusline script
input=$(cat)

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
CONTEXT_USED=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
TOTAL_COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Format context size (e.g., 200000 -> 200k)
if [ "$CONTEXT_SIZE" -ge 1000 ]; then
  CONTEXT_DISPLAY="$((CONTEXT_SIZE / 1000))k"
else
  CONTEXT_DISPLAY="$CONTEXT_SIZE"
fi

# Round context used percentage
CONTEXT_USED_INT=$(printf "%.0f" "$CONTEXT_USED")

# Format cost with 3 decimal places
COST_DISPLAY=$(printf "%.3f" "$TOTAL_COST")

echo "[$MODEL] Context: ${CONTEXT_USED_INT}%/${CONTEXT_DISPLAY} | \$${COST_DISPLAY}"
