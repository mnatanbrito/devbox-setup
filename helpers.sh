#!/bin/zsh

#######################
# JSON Merge Helpers
#######################

function validate_json() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return 1
    fi
    jq empty "$file" 2>/dev/null
    return $?
}

function deep_merge_json() {
    local source_file="$1"
    local target_file="$2"

    if ! command -v jq &>/dev/null; then
        echo "${RED}jq is required to merge JSON files but was not found${NOCOLOR}"
        return 1
    fi

    # If source doesn't exist, nothing to do
    if [ ! -f "$source_file" ]; then
        echo "${YELLOW}Source file $source_file does not exist, skipping${NOCOLOR}"
        return 0
    fi

    # Validate source JSON
    if ! validate_json "$source_file"; then
        echo "${RED}Invalid JSON in source file: $source_file${NOCOLOR}"
        return 1
    fi

    # If target doesn't exist, just copy source
    if [ ! -f "$target_file" ]; then
        echo "${BLUE}Target $target_file doesn't exist, copying from source${NOCOLOR}"
        mkdir -p "$(dirname "$target_file")"
        cp "$source_file" "$target_file"
        return 0
    fi

    # Validate target JSON
    if ! validate_json "$target_file"; then
        echo "${RED}Invalid JSON in target file: $target_file${NOCOLOR}"
        return 1
    fi

    echo "${BLUE}Merging $source_file into $target_file${NOCOLOR}"

    local tmp_file
    tmp_file=$(mktemp) || {
        echo "${RED}Failed to create temporary file${NOCOLOR}"
        return 1
    }

    # Deep merge: everything already in the target is preserved, the source
    # only fills in what is missing.
    # Objects: recursively merge, keeping the target's key order
    # Arrays: keep the target's items and order, append only new source items
    # Scalars: target value wins (including false and null)
    if ! jq -n --slurpfile t "$target_file" --slurpfile s "$source_file" '
      def merge($a; $b):
        if ($a | type) == "object" and ($b | type) == "object" then
          reduce ($b | keys_unsorted[]) as $k ($a;
            if ($a | has($k)) then .[$k] = merge($a[$k]; $b[$k])
            else .[$k] = $b[$k]
            end)
        elif ($a | type) == "array" and ($b | type) == "array" then
          $a + ($b - $a)
        else $a
        end;
      merge($t[0]; $s[0])
    ' > "$tmp_file"; then
        echo "${RED}Failed to merge JSON files${NOCOLOR}"
        rm -f "$tmp_file"
        return 1
    fi

    # Never overwrite the target with something that isn't valid JSON
    if ! validate_json "$tmp_file"; then
        echo "${RED}Merge produced invalid JSON, leaving $target_file untouched${NOCOLOR}"
        rm -f "$tmp_file"
        return 1
    fi

    local backup_file="$target_file.bak.$(date +%s)"
    if ! cp -p "$target_file" "$backup_file"; then
        echo "${RED}Failed to back up $target_file, aborting merge${NOCOLOR}"
        rm -f "$tmp_file"
        return 1
    fi
    echo "${DARKGRAY}Backed up $target_file to $backup_file${NOCOLOR}"

    # Write through the existing file so its permissions are preserved
    if ! cat "$tmp_file" > "$target_file"; then
        echo "${RED}Failed to write merged content to $target_file${NOCOLOR}"
        rm -f "$tmp_file"
        return 1
    fi

    rm -f "$tmp_file"
    echo "${GREEN}Successfully merged into $target_file${NOCOLOR} ✅"
    return 0
}
