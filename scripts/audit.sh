#!/usr/bin/env bash
# tidy-skills audit - READ-ONLY scan of AI agent skill directories.
# Reports symlinks, real copies, dead links, and cross-directory duplicate
# names. Never modifies anything.
#
# Usage:
#   bash audit.sh                 # scan default locations that exist
#   bash audit.sh ~/my/skills     # scan defaults + extra directories

set -u

DEFAULT_DIRS=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.cursor/skills"
  "$HOME/.gemini/skills"
  "$HOME/.agents/skills"
  "$HOME/.skillshub"
)

DIRS=()
for d in "${DEFAULT_DIRS[@]}" "$@"; do
  [ -d "$d" ] && DIRS+=("$d")
done

if [ ${#DIRS[@]} -eq 0 ]; then
  echo "No skill directories found. Pass paths explicitly: bash audit.sh <dir> [...]"
  exit 1
fi

TMP_REAL="$(mktemp)"
trap 'rm -f "$TMP_REAL"' EXIT

total_dead=0
total_copies=0

for dir in "${DIRS[@]}"; do
  echo "=== $dir ==="
  links=0; copies=0; dead=0
  for entry in "$dir"/*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    name=$(basename "$entry")
    if [ -L "$entry" ] && [ ! -e "$entry" ]; then
      echo "  DEAD LINK : $name -> $(readlink "$entry")"
      dead=$((dead+1))
    elif [ -L "$entry" ]; then
      links=$((links+1))
    elif [ -d "$entry" ]; then
      echo "  REAL COPY : $name"
      copies=$((copies+1))
      echo "$name|$dir" >> "$TMP_REAL"
    fi
  done
  echo "  subtotal: $links symlinks / $copies real dirs / $dead dead links"
  total_dead=$((total_dead+dead))
  total_copies=$((total_copies+copies))
  echo
done

echo "=== duplicate names among real directories (potential divergent copies) ==="
dupes=$(cut -d'|' -f1 "$TMP_REAL" | sort | uniq -d)
if [ -n "$dupes" ]; then
  while IFS= read -r name; do
    echo "  $name"
    grep "^$name|" "$TMP_REAL" | cut -d'|' -f2 | sed 's/^/    - /'
  done <<< "$dupes"
else
  echo "  none"
fi

echo
echo "=== summary ==="
echo "  directories scanned : ${#DIRS[@]}"
echo "  dead links          : $total_dead"
echo "  real (non-library) copies to review: see REAL COPY lines above"
echo
echo "Note: real directories inside the central library are expected (they ARE"
echo "the canonical copies). Real directories inside tool directories are the"
echo "ones worth consolidating - unless declared tool-exclusive."
