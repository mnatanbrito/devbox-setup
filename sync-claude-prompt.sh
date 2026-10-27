#!/bin/zsh

# Copies the live global Claude Code prompt back into the repo so that
# setup.sh installs the latest version on new machines.

cd "$(dirname "$0")"
source "colors.sh"

source_file="$HOME/.claude/CLAUDE.md"
target_file="user_files/.claude/CLAUDE.md"

if [ ! -f "$source_file" ]; then
    echo "${RED}$source_file does not exist${NOCOLOR}🚫"
    exit 1
fi

if [ -f "$target_file" ] && cmp -s "$source_file" "$target_file"; then
    echo "${GREEN}Claude prompt is already in sync${NOCOLOR} ✅"
    exit 0
fi

mkdir -p "$(dirname "$target_file")"
cp "$source_file" "$target_file"

echo "${GREEN}Copied $source_file to $target_file${NOCOLOR} ✅"
git --no-pager diff --stat -- "$target_file"
